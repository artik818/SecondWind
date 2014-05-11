#ifndef ANDROIDSENSORSOURCE_H
#define ANDROIDSENSORSOURCE_H
#include "SensorHandler.h"
#include "ISensorSource.h"
#include <android/sensor.h>

#include "Thread.h"

class AndroidSensorSource: public ISensorSource, public Thread{

    static int sensorCallback(int fd, int events, void* data);
    char * mSensorData;
    bool mIsAlive;
    ASensorEventQueue* mSensorEventQueue;

    ISensorClient * mClient;

    void startLooper();
    static void * threadStart(void *);

public:
    AndroidSensorSource(ISensorClient * client);
    virtual ~AndroidSensorSource();
    void readValues();
    virtual void run();



};






#endif
