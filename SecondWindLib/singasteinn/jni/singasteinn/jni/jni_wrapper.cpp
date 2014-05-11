#include "jni_wrapper.h"
#include "../SensorLogger.h"
#include "../LogcatAppender.h"
#include "log4cplus/logger.h"

#include <log4cplus/logger.h>
#include <log4cplus/loglevel.h>
#include <log4cplus/loggingmacros.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.JNI");

void initLogging(){
    log4cplus::initialize ();
    log4cplus::SharedAppenderPtr append_1(new LogcatAppender);
    append_1->setName(LOG4CPLUS_TEXT("Console"));
    append_1->setLayout(std::auto_ptr<log4cplus::Layout>(new log4cplus::PatternLayout("%d{%H:%M:%S.%q} %c{1}: %m\n")));
    log4cplus::Logger::getRoot().addAppender(append_1);

    //log4cplus::Logger::getRoot().setLogLevel(log4cplus::WARN_LOG_LEVEL);
    LOG4CPLUS_INFO(logger, "Logging init Ok");
}

jlong Java_su_eqx_accellogger_NativeLogger_startLog(JNIEnv *env , jclass cls, jstring path){
    initLogging();
    const char *str = env->GetStringUTFChars( path, 0);
    SensorLogger * logger = new SensorLogger(str);
    printf("Hello.....");
    return (jlong)logger;
}

void Java_su_eqx_accellogger_NativeLogger_stopLog(JNIEnv *, jclass cls, jlong ptr)
{
    LOG4CPLUS_DEBUG(logger, "Stopping logger");
    delete (SensorLogger *) ptr;
}
