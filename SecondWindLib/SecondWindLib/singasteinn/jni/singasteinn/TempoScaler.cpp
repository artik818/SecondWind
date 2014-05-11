#include "TempoScaler.h"

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.TempoScaler");

TempoScaler::TempoScaler(ISoundSource *src):
mSrc(src),
mBufferLen(102400),
  mEOF(0)
{
    mScaler = new soundtouch::SoundTouch();
    mScaler -> setSampleRate(src->getSampleRate());
    mScaler -> setChannels(1);
    mBuffer = new soundtouch::SAMPLETYPE[mBufferLen];
    
}

int TempoScaler::read(SampleType *buf, int len){
//    LOG4CPLUS_DEBUG_FMT(logger, "read(%d)", len);
    int totalRead = 0;
    while(totalRead < len){
        int lastRead = mScaler->receiveSamples(buf + totalRead, len - totalRead);
        totalRead += lastRead;
        if (!lastRead && mSrc->isEOF()){
            mEOF = true;
            break;
        }
        LOG4CPLUS_TRACE_FMT(logger, "read(%d)", len);
        if (totalRead < len){
            feedData();
        }
    }
    return totalRead;
}

void TempoScaler::feedData(){
    // assume SAMPLETYPE=short
    int l = mSrc->read(mBuffer, mBufferLen);
    mScaler->putSamples(mBuffer, l);
}


TempoScaler::~TempoScaler(){
    delete mScaler;
    delete [] mBuffer;
}

void TempoScaler::setTempo(float tempo){
    mScaler -> setTempo(tempo);
}

void TempoScaler::seekSec(float pos){
    ISeekable * src = dynamic_cast<ISeekable *>(mSrc);
    if (src){
        src->seekSec(pos);
        mScaler->clear();
    }
    else{
        LOG4CPLUS_ERROR(logger, "input stream is not seekable");
    }
}

float TempoScaler::tellSec(){
    ISeekable * src = dynamic_cast<ISeekable *>(mSrc);
    if (src){
        return src->tellSec();
    }
    else{
        LOG4CPLUS_ERROR(logger, "input stream is not seekable");
        return 0;
    }

}


