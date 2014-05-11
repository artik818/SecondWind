#ifndef SENSORHANDLER_H
#define SENSORHANDLER_H
#include "RingBuffer.h"
#include <unistd.h>
#include "ISensorSource.h"

namespace singasteinn {



class SensorHandler: public ISensorClient{
    static SensorHandler * mInstance;
    ISensorSource * mSource;

    float * mAcorrInBuffer;
    float * mAcorrOutBuffer;

    void computeAcorr();
    int mAcorrBufferLen;
    float mSamplesInterval;
    float mOverrideIntervalValue;
protected:

    bool mAlive;

    struct Sample{
        Sample():value(-1), timestamp(-1){}
        Sample(int64_t t, float v):value(v), timestamp(t){}
        Sample(const Sample& s):value(s.value), timestamp(s.timestamp){}
        float value;
        int64_t timestamp;
    };

    void putSample(const Sample& sample) {mSampleBuffer.feed(sample);}
    void setSamplesInterval(float value) {mSamplesInterval = value;}
    void setAsInstance(){mInstance = this;}
private:
    RingBuffer<Sample> mSampleBuffer;
    Sample * mTmpSamplesBuffer;

public:
    SensorHandler(int bufferLen);
    virtual ~SensorHandler();
    static SensorHandler * getInstance();
    float computeStepsInterval();
    ISensorSource * getSource(){
        return mSource;
    }

    void handleSensorData(int64_t timestamp, int dim, float *data);

    void setOverrideStepsInterval(float val){
        mOverrideIntervalValue = val;
    }

    float getOverrideStepsInterval(){
        return mOverrideIntervalValue;
    }

};
}

#endif
