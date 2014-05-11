#ifndef SENSORLOGGER_H
#define SENSORLOGGER_H
#include <string>
#include "ISensorSource.h"
#include <stdio.h>


class SensorLogger: public ISensorClient{
    ISensorSource * mSrc;
    FILE * out;
public:
    SensorLogger(std::string path);
    virtual ~SensorLogger();

    void handleSensorData(int64_t timestamp, int dim, float *data);
};




#endif
