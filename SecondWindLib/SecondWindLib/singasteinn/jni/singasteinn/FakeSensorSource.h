#ifndef FAKESENSORSOURCE_H
#define FAKESENSORSOURCE_H
#include "SensorHandler.h"
#include "Thread.h"
#include <pthread.h>
class FakeSensorSource: public ISensorSource, public Thread{
    bool mAlive;
    ISensorClient * mClient;

    float samplesInterval;
    int cycleLen;

public:
    FakeSensorSource(ISensorClient * cli);
    virtual void run();
    FakeSensorSource();
    virtual ~FakeSensorSource();

    void setStepsInterval(float sec);


};

#endif
