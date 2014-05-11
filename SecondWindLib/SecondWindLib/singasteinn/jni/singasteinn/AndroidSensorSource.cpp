#include "AndroidSensorSource.h"
#include <android/looper.h>
#include <android/sensor.h>
#include <stdio.h>
#include <unistd.h>
#include <cmath>
#include "logging.h"


#include <log4cplus/logger.h>
#include <log4cplus/loglevel.h>
#include <log4cplus/loggingmacros.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.AndroidSensorSrc");

AndroidSensorSource::AndroidSensorSource(ISensorClient *client):
    mClient(client),
    mIsAlive(1)
{
    start();
}

void AndroidSensorSource::readValues(){
    ASensorEvent ev;
    ASensorEventQueue_getEvents(mSensorEventQueue, &ev, 1);
    ASensorVector & a = ev.acceleration;
    if (mClient){
        mClient->handleSensorData(ev.timestamp, 3, &a.x);
    }

}

int AndroidSensorSource::sensorCallback(int fd, int events, void *data){
    ((AndroidSensorSource*)data)->readValues();
    return 1;
}

void AndroidSensorSource::startLooper(){
    ALooper* looper = ALooper_forThread();
    if(looper == NULL)
        looper = ALooper_prepare(ALOOPER_PREPARE_ALLOW_NON_CALLBACKS);

    ASensorManager * sensorManager = ASensorManager_getInstance();
    const ASensor * accelerometerSensor = ASensorManager_getDefaultSensor(sensorManager, ASENSOR_TYPE_ACCELEROMETER);
    const int rate = 20000;
    int ret = 0;
    mSensorEventQueue = ASensorManager_createEventQueue(sensorManager, looper,  3, sensorCallback, this);
    ret = ASensorEventQueue_enableSensor(mSensorEventQueue, accelerometerSensor);
    fprintf(stderr, "enable sensor: %d\n", ret);

    LOGDF("Initlaizing sensor, rate = %d", rate);
    ret = ASensorEventQueue_setEventRate(mSensorEventQueue, accelerometerSensor, rate);
    assert (ret >= 0);

    while (mIsAlive){
        int outFd;
        int outEvents;
        void * data;
        ret = ALooper_pollAll(1000, &outFd, &outEvents, &data);
    }
    LOGE("Looper finished");
    ASensorEventQueue_disableSensor(mSensorEventQueue, accelerometerSensor);
    // FIXME destruct the looper

}

void AndroidSensorSource::run(){
    startLooper();
}

AndroidSensorSource::~AndroidSensorSource(){
    mIsAlive = false;
    join();

}
