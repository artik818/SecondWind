//
// Created by vvs on 16.07.2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#include "../fft/kissfft.hh"
#include "../fft/kiss_fft.h"
#include "SongAnalyzer.h"
#include "cmath"
#include <assert.h>
#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>

log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.SongAnalyzer");
log4cplus::Logger valLogger = log4cplus::Logger::getInstance("singasteinn.SongAnalyzerValues");

using namespace singasteinn;

SpecStream::SpecStream(int specStep, int specWin, ISoundSource * src):
    mSpecStep(specStep),
    mSpecWin(specWin),
    mInputBuffer(0),
    mFeedBuffer(0),
    mOutBuffer(0),
    mPeriodogramBuffer(0),
    mSource(src),
    mKissCfg(0)
{
    mInputBuffer = new ISoundSource::SampleType[specWin];
    mKissCfg = kiss_fft_alloc(specWin, 0, 0, 0);
    mFeedBuffer = new kiss_fft_cpx[mSpecWin];
    mOutBuffer = new kiss_fft_cpx[mSpecWin];
    mPeriodogramBuffer = new float[mSpecWin];
}

SpecStream::~SpecStream(){
    if (mInputBuffer)
        delete[] mInputBuffer;
    if (mKissCfg)
        free(mKissCfg);
    if (mFeedBuffer)
        delete [] mFeedBuffer;
    if (mOutBuffer)
        delete [] mOutBuffer;
}

bool SpecStream::refillBuffer(){
    //LOG4CPLUS_TRACE(logger, "refillBuffer");
    if (mSource->isEOF())
        return false;
    int overlapLen = mSpecWin - mSpecStep;
    if (overlapLen>0){
        for (int i = 0; i<overlapLen;i++){
            mInputBuffer[i] = mInputBuffer[i+mSpecStep];
        }
        mSource->read(mInputBuffer + overlapLen, mSpecStep);
    }
    else if (overlapLen <= 0){
        while (overlapLen < 0){
            int t = (-overlapLen) > mSpecWin ? mSpecWin : -overlapLen;
            overlapLen += mSource -> read(mInputBuffer, t);
        }
        mSource->read(mInputBuffer, mSpecWin);
        
    }
    return true;
}

bool SpecStream::prefillBuffer(){
    if (mSource->isEOF())
        return false;
    mSource->read(mInputBuffer, mSpecWin);
    return true;
}

void SpecStream::fillFeedBuffer(){
    for (int i = 0; i < mSpecWin; i++){
        mFeedBuffer[i].r = mInputBuffer[i];
        //printf("feeding %f\n", mFeedBuffer[i].r);
        mFeedBuffer[i].i = 0;
    }
}

bool SpecStream::computeNextStep(){
    if (! mFeedBuffer){      
        prefillBuffer();
    }
    else{
        if (!refillBuffer())
            return false;
    }
    fillFeedBuffer();
    kiss_fft(mKissCfg, mFeedBuffer, mOutBuffer);
    for (int i = 0; i< mSpecWin;i++){
        //mPeriodogramBuffer[i] = 0;
        mPeriodogramBuffer[i] = std::sqrt(mOutBuffer[i].r * mOutBuffer[i].r + mOutBuffer[i].i * mOutBuffer[i].i);
    }
    return true;
}

SongAnalyzer::SongAnalyzer(ISoundSource * source):
    mSpecStream(0),
    mSpecStep(128),
mSpecWin(128),
mAcorrStep(2048),
mAcorrWin(2048), // FIXME crash when win=1024
mMinFreq(2000),
mMaxFreq(15000),
mDecoder(0)
{
    mAcorrOutBuffer = new float[mAcorrWin];
    mAcorrInBuffer = new float[mAcorrWin];
    mAcorrSmooth = new float[mAcorrWin];
    mAcorrDeriv = new float[mAcorrWin - 1];
    setSource(source);
    
}

SongAnalyzer::~SongAnalyzer(){
    if (mSpecStream)
        delete mSpecStream;
    if (mAcorrInBuffer)
        delete [] mAcorrInBuffer;
    if (mAcorrOutBuffer)
        delete [] mAcorrOutBuffer;
    if (mAcorrDeriv)
        delete [] mAcorrDeriv;
    if (mAcorrSmooth)
        delete [] mAcorrSmooth;
}

void SongAnalyzer::setSource(ISoundSource* source){
    mDecoder = source;
    //((MpegDecoder*)mDecoder)->open(fn);
    //((MpegDecoder*)mDecoder)->getFormat();
    mSpecStream = new SpecStream(mSpecStep, mSpecWin, mDecoder);
    
    mMinFreqIdx = mMinFreq / mSpecStream->getSpectralResolution();
    mMaxFreqIdx = mMaxFreq / mSpecStream->getSpectralResolution();
    
    LOG4CPLUS_INFO_FMT(logger, "Decoder init OK. min idx: %d, max idx: %d", mMinFreqIdx, mMaxFreqIdx);
    LOG4CPLUS_INFO_FMT(logger, "Spectrum sample interval: %f sec", mSpecStream->getSamplesInterval());
    LOG4CPLUS_INFO_FMT(logger, "Acorr win length: %f sec", mSpecStream->getSamplesInterval() * mAcorrWin);
    LOG4CPLUS_INFO_FMT(logger, "fourier bins: %d:%d", mMinFreqIdx, mMaxFreqIdx);
}


const SongAnalyzer::Result SongAnalyzer::analyze(){
    firstPass();
    secondPass();
    return selectValues();
    
}

float peakShadow(float dt){
    return 1 - std::abs(dt);
}

void SongAnalyzer::computeAcorr(){
    static int aa = 0;
    aa++;
    const float MIN_INTERVAL = 0.25;
    float tSum = 0;
    for (int i = 0; i<mAcorrWin;i++){
        tSum = 0;
        for (int j = 0; j<mAcorrWin - i; j++){
            tSum += mAcorrInBuffer[j] * mAcorrInBuffer[i+j];
        }
        mAcorrOutBuffer[i] = std::sqrt(tSum);
        //fprintf(stderr, "%.3e\n", mAcorrInBuffer[i]);
    }
    float absVal = mAcorrOutBuffer[0];
    float max = 0;
    float maxPos = 0;
    mAcorrSmooth[0] = mAcorrOutBuffer[0];
    mAcorrSmooth[mAcorrWin-1] = 0;
    for (int i = 1; i< mAcorrWin - 1;i++){
        mAcorrSmooth[i] = mAcorrOutBuffer[i-1]* 0.2 + mAcorrOutBuffer[i]*0.6 + mAcorrOutBuffer[i+1]*0.2;
        //printf("%e ", mAcorrOutBuffer[i] / absVal);
    }
    //printf("\n");
    computeDerivative(mAcorrSmooth, mAcorrDeriv, mAcorrWin);
    
    float acorrStep = mSpecStream -> getSamplesInterval();
    std::vector<AcorrMaximum> maxima;
    
    const int nLen = 20;                // we will check if amplitude of each maximum exceeds mean value of it
    const float nMeanThreshold = 1;     // neighbourhood multiplied bu nMeanThreshold

    //LOG4CPLUS_DEBUG(logger, "Acorr calculated, looking for maxima");
    for (int i = 0; i < mAcorrWin-1; i++){
        if (mAcorrDeriv[i] * mAcorrDeriv[i+1] < 0){
            int maxIdx = i+1;
            bool isMaximum = mAcorrDeriv[i]>0;
            if (!isMaximum)
                continue;
            int amp = mAcorrSmooth[maxIdx];
            
            
            float nhoodMean = 0;
            
            for (int j = std::max(i-nLen, 0); j<std::min(i+nLen, mAcorrWin - 1);j++)
                nhoodMean += mAcorrSmooth[j];
            nhoodMean /= (std::min(i+nLen, mAcorrWin - 1) - std::max(i - nLen, 0));
            
            if (amp / nhoodMean > nMeanThreshold){
                maxima.push_back(AcorrMaximum(maxIdx * acorrStep, amp/absVal, amp));
                LOG4CPLUS_TRACE_FMT(logger, "Maximum at %.3f, rel amp: %.3f", maxIdx * acorrStep, amp/absVal);
                //if (aa == 4)
                //    printf("%.3f %.3f %.3f\n", maxIdx * acorrStep, amp/absVal, amp / nhoodMean);
            }
        }
    }
    mAcorrMaxima.push_back(maxima);
}

void SongAnalyzer::readDrumVolume(float *buf, int len){
    for (int i = 0; i<len; i++){
        float dVol = 0;
        if (!mSpecStream -> computeNextStep())
            break;
        for (int i = mMinFreqIdx; i<mMaxFreqIdx; i++){
            dVol += mSpecStream->getPeriodogram()[i];
        }
        buf[i] = dVol;
    }
}

void SongAnalyzer::firstPass(){
    try {
        readDrumVolume(mAcorrInBuffer, mAcorrWin);
        computeAcorr();
        int samplesToReuse = mAcorrWin - mAcorrStep;
        samplesToReuse = samplesToReuse>0?samplesToReuse:0;
        int samplesToDrop = mAcorrStep - mAcorrWin;
        samplesToDrop = samplesToDrop>0?samplesToDrop:0;
        while (!mDecoder->isEOF() && !mAbort){
            for (int i = 0; i< samplesToReuse;i++){
                mAcorrInBuffer[i] = mAcorrInBuffer[i+mAcorrStep];
            }
            for (int i = 0; i<samplesToDrop; i++){
                mSpecStream->computeNextStep();
            }
            readDrumVolume(mAcorrInBuffer+samplesToReuse, std::min(mAcorrStep, mAcorrWin));
            computeAcorr();
        }
    } catch (std::exception & eof) {  // TODO clean up
        LOG4CPLUS_WARN(logger, "EOF reached");
    }
}

void SongAnalyzer::secondPass(){
    const float MIN_INTERVAL = 0.3;
    const float MAX_INTERVAL = 1;
    const int numBins = 30;
    const float groupWidth = 0.02;
    float binWidth = (MAX_INTERVAL + groupWidth - MIN_INTERVAL + groupWidth) / numBins;

    float hist[numBins];
    float histMean[numBins];
    float avgAmplitude[numBins];

    
    std::vector<AcorrMaximum> maxima;
    for (std::vector<std::vector<AcorrMaximum> >::iterator i = mAcorrMaxima.begin(); i!= mAcorrMaxima.end();i++){
        for (std::vector<AcorrMaximum>::iterator j = i->begin(); j!= i->end(); j++){
            maxima.push_back(*j);
        }
    }
    
    for (int i = 0; i< numBins; i++){
        float mid = MIN_INTERVAL + groupWidth + binWidth * i;
        float minInt = mid - groupWidth;
        float maxInt = mid + groupWidth;
        hist[i] = 0;
        histMean[i] = 0;
        std::vector<AcorrMaximum> matches;
        for (MaxIterator m = maxima.begin(); m!= maxima.end(); m++){
            float amp = m->mAmp;
            float t = m->mInterval;
            if (t > minInt && t < maxInt){
                hist[i] += amp;
                histMean[i] += t;
                matches.push_back(*m);
            }
            
        }
        if (!matches.empty()){
            histMean[i] /= matches.size();
            avgAmplitude[i] = hist[i] / matches.size();
        }
        //hist[i] /= mAcorrMaxima.size();
        //fprintf(stderr, "%.3f %.3f %.3f\n", (minInt + maxInt)/2, hist[i], histMean[i]);
    }
    for (int k = 0; k<5; k++){
        int maxPos = -1;
        float maxAmp = 0;
        for (int i = 0; i< numBins; i++){
            if (hist[i] > maxAmp){
                bool tooClose = false;
                for (MaxIterator j = mPeriodCondensationPoints.begin(); j!= mPeriodCondensationPoints.end(); j++){
                    if (std::abs(histMean[i] - j->mInterval) < groupWidth){
                        tooClose = true;
                    }
                }
                if (!tooClose){
                    maxAmp = hist[i];
                    maxPos = i;
                }
            }
        }
        if (maxPos > 0){
            LOG4CPLUS_DEBUG_FMT(logger, "condensation point at %.3f, amp %6.3f rel amp %.3f", histMean[maxPos], hist[maxPos], avgAmplitude[maxPos]);
            mPeriodCondensationPoints.push_back(AcorrMaximum(histMean[maxPos], avgAmplitude[maxPos], -1));
        }
    }
}

const SongAnalyzer::Result SongAnalyzer::selectValues(){
    float timeStep = mSpecStream->getSamplesInterval() * mAcorrStep;
    float acorrWinSec = mSpecStream->getSamplesInterval() * mAcorrWin;
    float ref_idx = 0;
    for (int i = 0; i<mPeriodCondensationPoints.size(); i++){
        if (mPeriodCondensationPoints[i].mAmp > mPeriodCondensationPoints[ref_idx].mAmp)
            ref_idx = i;
    }
    AcorrMaximum reference = mPeriodCondensationPoints[ref_idx];

    Result res;
//    res.mFlatTempoFactor = -1;
    for (int i = 0; i<mAcorrMaxima.size(); i++){
        float currTime = i * timeStep;
        std::vector<AcorrMaximum> &maxima = mAcorrMaxima[i];
        AcorrMaximum bestMatch(0, 0, 0);
        float minDistance = 100;
        for (MaxIterator m = maxima.begin(); m!= maxima.end(); m++){
            float dst = std::abs(m->mInterval - reference.mInterval);
            float weightedDst = (1 - m->mAmp)*dst;
            if (dst > 0.2)
                weightedDst = 10;
            if (weightedDst < 2)
                LOG4CPLUS_DEBUG_FMT(logger, "int: %.3f, amp: %.3f, dst: %.3f, wdst: %.4f", m->mInterval, m->mAmp, dst, weightedDst);
            if (weightedDst < minDistance && m->mAmp > reference.mAmp * 0.8){
                bestMatch = *m;
                minDistance = weightedDst;
            }
        }
        res.put(currTime, bestMatch.mInterval);
        LOG4CPLUS_DEBUG_FMT(logger, "Tempo for T = %6.2fs: %.3f", currTime, bestMatch.mInterval);
        
    }
    LOG4CPLUS_WARN(logger, "analysis finished");
    return res;
}


float SongAnalyzer::Result::get(float time) const{
    for (int i = 0; i < mTimeMarks.size(); i++){
        if (mTimeMarks[i]>time)
            return mValues[i];
    }
    return -1;
}

void SongAnalyzer::Result::put(float time, float val){
    if (mTimeMarks.size()){
        // time must increase, I'm too lazy to add sorting
        assert(mTimeMarks[mTimeMarks.size() - 1] < time);
    }
    mTimeMarks.push_back(time);
    mValues.push_back(val);
}

void SongAnalyzer::Result::print() const{
    LOG4CPLUS_WARN_FMT(valLogger, "= Begin tempo data (len: %d)=", mTimeMarks.size());
    for (int i = 0; i < mTimeMarks.size(); i++){
        LOG4CPLUS_WARN_FMT(valLogger, "%5.1f: %.3f (%5.1f bpm)", mTimeMarks[i], mValues[i], 60.0 / mValues[i]);
    }
    LOG4CPLUS_WARN(valLogger, "= End tempo data =");
}

void SongAnalyzer::computeDerivative(float *in, float *out, int len){
    for (int i = 0; i<len-1; i++){
        out[i] = in[i+1] - in[i];
    }
}
