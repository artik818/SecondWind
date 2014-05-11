#ifndef LOGCATAPPENDER_H
#define LOGCATAPPENDER_H
#include "log4cplus/appender.h"

class LogcatAppender: public log4cplus::Appender{

protected:
    virtual void append(const log4cplus::spi::InternalLoggingEvent &event);

public:
    LogcatAppender();
    ~LogcatAppender();

    virtual void close(){}


};




#endif
