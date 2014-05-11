//
//  MpegDecoder.cpp
//  singasteinn
//
//  Created by Во on 16.07.2013.
//
//

#include "MpegDecoder.h"

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.MpegDecoder");


bool MpegDecoder::mpg123Initialized = false;
int desiredFormat = MPG123_ENC_SIGNED_16;

MpegDecoder::MpegDecoder():
mHandle(0),
sampleRate(0),
  mEOF(0)
{
    LOG4CPLUS_DEBUG(logger, "created");
    if (!mpg123Initialized)
        mpg123_init();
    mHandle = mpg123_new(0, 0);
    mpg123_param(mHandle, MPG123_FLAGS, MPG123_MONO_MIX, 0);
    mpg123_format(mHandle, 44100, MPG123_MONO, desiredFormat);
}

MpegDecoder::~MpegDecoder(){
    mpg123_delete(mHandle);
    LOG4CPLUS_DEBUG(logger, "destroyed");
}

int MpegDecoder::tell(){
    return mpg123_tell(mHandle);
}

long MpegDecoder::len(){
    return mpg123_length(mHandle);
}

void MpegDecoder::open(std::string fn){
    if (fn.substr(0, 5) == "file:")
        fn = fn.substr(5);
    LOG4CPLUS_INFO_FMT(logger, "opening file '%s'", fn.c_str());
    checkError(mpg123_open(mHandle, fn.c_str()));
    getFormat();
}

int MpegDecoder::seek(int sample){
    return mpg123_seek(mHandle, sample, SEEK_SET);
}

int MpegDecoder::read(SampleType *buf, int len) {
    size_t done = -1;
    if (mEOF){
        throw EOFException();
    }
    //printf("reading %d samples\n", len);
    int ret = mpg123_read(mHandle, (unsigned char *)buf, len*2, &done);
    //fprintf(stderr, "%d bytes read\n", done);
    if (ret == MPG123_DONE)
        mEOF=true;
    else if (ret == MPG123_NEW_FORMAT){
        getFormat();
        return read(buf, len); // FIXME
    }
    else
        checkError(ret);

    
    return done/2;
}

bool MpegDecoder::isEOF(){
    return mEOF;
}

void MpegDecoder::getFormat(){
    checkError(mpg123_getformat(mHandle, &sampleRate, &channels, &encoding));
    if (encoding!= desiredFormat){
        throw DecoderException("Unsupported format");
    }
    LOG4CPLUS_INFO_FMT(logger, "getformat: position = %d", tell());
    LOG4CPLUS_INFO_FMT(logger, "getformat: sample rate: %d, channels: %d, encoding: %x", (int)sampleRate, channels, encoding);
}

void MpegDecoder::checkError(int retcode){
    if (!retcode)
        return;
    std::string msg;
    if (retcode == -1)
        msg = mpg123_strerror(mHandle);
    else
        msg = mpg123_plain_strerror(retcode);
    LOG4CPLUS_WARN_FMT(logger, "ERROR: %s", msg.c_str());
    throw DecoderException(msg);
}

float MpegDecoder::tellSec(){
    return tell() / (float)getSampleRate();
}

void MpegDecoder::seekSec(float pos){
    seek(pos * getSampleRate());
}
