#ifndef ISENSORSOURCE_H
#define ISENSORSOURCE_H

#include <sys/types.h>

class ISensorClient{
public:

    virtual ~ISensorClient(){}
    virtual void handleSensorData(int64_t timestamp, int dim, float* data) = 0;
};

class ISensorSource{
public:
    virtual ~ISensorSource(){}    
};



#endif
