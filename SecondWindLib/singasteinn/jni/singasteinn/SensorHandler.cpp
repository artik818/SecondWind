#include "SensorHandler.h"
#include <vector>
#include <stdio.h>
#include <assert.h>
#include "platform.h"
#include <cmath>
#include "logging.h"

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>


static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.sensor.SensorHandler");
using namespace singasteinn;

SensorHandler * SensorHandler::mInstance = 0;

SensorHandler * SensorHandler::getInstance(){
    return mInstance;
}

SensorHandler::SensorHandler(int bufferLen):
    mAcorrBufferLen(bufferLen/2),
    mSamplesInterval(-1),
    mOverrideIntervalValue(-1),
    mSampleBuffer(bufferLen)
{
    mSource = new PlatformSensorSource(this); // TODO: correct destruction
    mAcorrInBuffer = new float[mAcorrBufferLen];
    mAcorrOutBuffer = new float[mAcorrBufferLen];
    mTmpSamplesBuffer = new Sample[mAcorrBufferLen];
    setAsInstance();
}

SensorHandler::~SensorHandler(){
    delete [] mAcorrInBuffer;
    delete [] mAcorrOutBuffer;
    delete [] mTmpSamplesBuffer;
}

void SensorHandler::computeAcorr(){
    static long idx = 0;
    mSampleBuffer.readLast(mTmpSamplesBuffer, mAcorrBufferLen);
    for (int i = 0; i<mAcorrBufferLen; i++){
        mAcorrInBuffer[i] = mTmpSamplesBuffer[i].value;
    }
    for(int i = 0; i<mAcorrBufferLen; i++){
        mAcorrOutBuffer[i] = 0;
        for (int j = 0; j<mAcorrBufferLen-i; j++){
            mAcorrOutBuffer[i] += mAcorrInBuffer[j] * mAcorrInBuffer[i+j];
        }
        mAcorrOutBuffer[i] /= mAcorrBufferLen;
        mAcorrOutBuffer[i] /= (((float)mAcorrBufferLen - i)/mAcorrBufferLen);
    }
    idx ++;
}

float SensorHandler::computeStepsInterval(){
    if (mOverrideIntervalValue > 0){
        return mOverrideIntervalValue;
    }
    const float MIN_DT = 0.1;
    const float MAX_DT = 1;
    const float AMP_THRESHOLD = 0.2;
    if (mSamplesInterval < 0){
        return -1;
    }
    computeAcorr();
    std::vector<int> maxima;
    for (int i = MIN_DT / mSamplesInterval; i< MAX_DT / mSamplesInterval;i++){
        float v = mAcorrOutBuffer[i];
        if (mAcorrOutBuffer [i-2] < v && mAcorrOutBuffer[i+2] < v && mAcorrOutBuffer[i-1] < v && mAcorrOutBuffer[i+1]<v){
            maxima.push_back(i);
        }
    }
    if (maxima.empty()){
        LOG4CPLUS_INFO(logger, "no maxima detected");
        return -1;
    }
    
    int maxIdx = 0;
    for (int i = 0; i<maxima.size(); i++){
        if (mAcorrOutBuffer[maxima[i]]>mAcorrOutBuffer[maxima[maxIdx]])
            maxIdx = i;
    }
    
    float minVal = 100;
    for (int i = 0; i < maxima[maxIdx]; i++){
        if (mAcorrOutBuffer[i] < minVal)
            minVal = mAcorrOutBuffer[i];
    }
    
    float ret = maxima[maxIdx] * mSamplesInterval;
    float amp = (mAcorrOutBuffer[maxima[maxIdx]] - minVal) / mAcorrOutBuffer[0];
    LOGIF("detected steps interval: %f, amplitude: %f, threshold: %f", ret, amp, AMP_THRESHOLD);
    return amp > AMP_THRESHOLD?ret:-1;
}


void SensorHandler::handleSensorData(int64_t timestampUsec, int dim, float *data){
    const int PERF_LEN = 100;
    static int timeIntervals[PERF_LEN];
    static int currentInterval = 0;
    static int64_t prevTime = 0;

    assert(dim == 3);
    float x = data[0];
    float y = data[1];
    float z = data[2];
    putSample(Sample(timestampUsec, std::sqrt(x * x + y * y + z * z)));
    timeIntervals[currentInterval] = timestampUsec - prevTime;
    prevTime = timestampUsec;
    currentInterval++;
    if (currentInterval == PERF_LEN){
        float mean = 0;
        float dev = 0;
        for (int i = 0; i< PERF_LEN; i++){
            mean += timeIntervals[i];
        }
        mean /= PERF_LEN;

        for (int i = 0; i< PERF_LEN; i++){
            dev += (timeIntervals[i] - mean)*(timeIntervals[i] - mean);
        }
        dev = std::sqrt(dev/PERF_LEN);
        setSamplesInterval(mean / 1e6);
        LOGDF("sensor perf: %f (dev %f), approx buffer refill time: %fs", mean/1e3, dev/1e3, mean * mAcorrBufferLen / 1e6);
        currentInterval = 0;

    }
}
