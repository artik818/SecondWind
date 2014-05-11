#include "LogcatAppender.h"
#include "android/log.h"

LogcatAppender::LogcatAppender(){
}

LogcatAppender::~LogcatAppender(){

}

void LogcatAppender::append(const log4cplus::spi::InternalLoggingEvent &event){
    log4cplus::tstring txt = formatEvent(event);
    __android_log_write(ANDROID_LOG_WARN, "singasteinn", txt.c_str());
}
