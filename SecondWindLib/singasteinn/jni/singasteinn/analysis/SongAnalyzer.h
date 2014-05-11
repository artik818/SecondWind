//
// Created by vvs on 16.07.2013.
//
// To change the template use AppCode | Preferences | File Templates.
//



#ifndef __SongAnalyzer_H_
#define __SongAnalyzer_H_

#include <iostream>
#include <vector>

#include "ISongAnalyzer.h"
#include "../ISoundStream.h"
#include "../fft/kiss_fft.h"

namespace singasteinn{

class SpecStream {
public:
    //typedef float SampleType;
private:
    int mSpecStep, mSpecWin;
    //SampleType * mInputBuffer;
    ISoundSource::SampleType * mInputBuffer;
    kiss_fft_cpx * mFeedBuffer;
    kiss_fft_cpx * mOutBuffer;
    float * mPeriodogramBuffer;
    ISoundSource * mSource;
    kiss_fft_cfg mKissCfg;
    
    bool refillBuffer();
    bool prefillBuffer();
    void fillFeedBuffer();
public:
    SpecStream(int specStep, int specWinLen, ISoundSource * src);
    bool computeNextStep();
    virtual ~SpecStream();


    float * getPeriodogram(){
        return mPeriodogramBuffer;
    }
    float getSpectralResolution(){
        float winLen = ((float)mSpecWin) / mSource->getSampleRate();
        return 1/winLen;
    }
    float getSamplesInterval(){
        return ((float)mSpecStep) / mSource->getSampleRate();
    }

};


class SongAnalyzer: public ISongAnalyzer {
public:

    SongAnalyzer(ISoundSource *source);
    ~SongAnalyzer();

private:

    struct AcorrMaximum{
        float mInterval;
        float mAmp;
        float mAbsAmp;
        AcorrMaximum(float interval, float amp, float absAmp): mInterval(interval), mAmp(amp), mAbsAmp(amp){}
    };
    typedef std::vector<AcorrMaximum>::iterator MaxIterator;

    SpecStream *mSpecStream;
    int mSpecStep, mSpecWin;
    int mAcorrStep, mAcorrWin;
    int mAcorrOutLen, mAcorrMidPos;
    float mMinFreq, mMaxFreq;
    bool mAbort;
    
    int mMinFreqIdx, mMaxFreqIdx;
    ISoundSource * mDecoder;
    float * mAcorrInBuffer;
    float * mAcorrOutBuffer;
    float * mAcorrSmooth;
    float * mAcorrDeriv;
    std::vector<AcorrMaximum> mPeriodCondensationPoints;
    std::vector<float> mPeriodCondensationAmplitudes;
    
    std::vector<float>mDrumVolume;
    std::vector<std::vector<AcorrMaximum> >mAcorrMaxima;
    std::vector<AcorrMaximum> mAcorrMaximaPlain;
    void setSource(ISoundSource *source);
    void readDrumVolume(float * buf, int len);
    void computeAcorr();
    void firstPass();
    void secondPass();
    const Result selectValues();
public:

    
    virtual const Result analyze();
//    void abortAnalysis();
    static void computeDerivative(float * in, float * out, int len);
};
}


#endif //__SongAnalyzer_H_
