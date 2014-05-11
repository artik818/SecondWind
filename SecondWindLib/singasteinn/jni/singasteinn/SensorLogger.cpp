#include "SensorLogger.h"
#include "platform.h"
#include "logging.h"
#include <log4cplus/logger.h>
#include <log4cplus/loglevel.h>
#include <log4cplus/loggingmacros.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.SensorLogger");


SensorLogger::SensorLogger(std::string path):
    out(0)
{
    LOGWF("Sensor logger init, fn = '%s'", path.c_str());
    mSrc = new PlatformSensorSource(this);
    out = fopen(path.c_str(), "w");
    assert(out);
    fprintf(out, "ALOG\n");
    fflush(out);

}

SensorLogger::~SensorLogger(){
    FILE * _out = out;
    out = 0;
    fclose(_out);
    delete mSrc;
}

void SensorLogger::handleSensorData(int64_t timestamp, int dim, float *data){
    if (!out)
        return;
    float x = data[0];
    float y = data[1];
    float z = data[2];
    fprintf(out, "%lld %10.7f %10.7f %10.7f\n", timestamp, x, y, z);
}
