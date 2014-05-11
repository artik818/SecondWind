#ifndef LOGGING_MIXIN_H
#define LOGGING_MIXIN_H
#include <string>
#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>

class LoggerMixin{
    log4cplus::Logger mLogger;
protected:
    LoggerMixin(std::string tagName):
        mLogger(log4cplus::Logger::getInstance(tagName))
    {

    }

    void log(char * format, ...){
        mLogger.
    }

};




#endif
