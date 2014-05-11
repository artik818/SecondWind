#include "FakeSensorSource.h"
#include <pthread.h>
#include <unistd.h>

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.FakeSensorSource");


FakeSensorSource::FakeSensorSource(ISensorClient * cli):
    mAlive(1),
    mClient(cli),
    samplesInterval(0.020)
{
    start();
}

void FakeSensorSource::setStepsInterval(float sec){
    cycleLen = sec / samplesInterval;
    LOG4CPLUS_INFO_FMT(logger, "steps interval set to %f", cycleLen * samplesInterval);
}


void FakeSensorSource::run(){
    setStepsInterval(0.4);
    static int sampleNo = 0;
    const int highLevelLen = 0.1 / samplesInterval;
    const float highLevel = 15;
    const float lowLevel = 7;
    long long timestamp;

    mAlive = 1;

    while (mAlive){
        float val = sampleNo<highLevelLen?highLevel:lowLevel;
        float data[3] = {val, val, val};
        if (mClient)
            mClient->handleSensorData(timestamp, 3, data);
        usleep(samplesInterval * 1e6);
        timestamp += samplesInterval * 1e6;
        sampleNo ++;
        sampleNo %= cycleLen;
    }
}

FakeSensorSource::~FakeSensorSource(){
    mAlive = false;
    join();
}
