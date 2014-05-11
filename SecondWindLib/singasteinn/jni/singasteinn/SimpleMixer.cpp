#include "SimpleMixer.h"

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>
#include "logging.h"

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.SimpleMixer");


int SimpleMixer::read(SampleType *buf, int len){
    if (mCurrentStream){
//        LOG4CPLUS_DEBUG(logger, "read()");
        try {
            return mCurrentStream->read(buf, len);
        }
        catch (EOFException & exc){
            LOGW("got EOF exception, requesting track change");
            if (mCallback)
                mCallback->onMixerTrackEnd(this);
            LOGI("now trying to re-read samples");
            return mCurrentStream->read(buf, len);
        }
    }
    throw EOFException("Tried to read from mixer without source");
}

bool SimpleMixer::isEOF(){
    if (mCurrentStream){
        return mCurrentStream->isEOF();
    }
    return true;
}

int SimpleMixer::getSampleRate(){
    if (mCurrentStream)
        return mCurrentStream->getSampleRate();
    LOG4CPLUS_ERROR(logger, "getSampleRate: no active stream");
    return 0;

}
