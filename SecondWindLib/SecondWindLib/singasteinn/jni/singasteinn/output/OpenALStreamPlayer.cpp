#include "OpenALStreamPlayer.h"
#include <stdlib.h>
#include <stdio.h>
#include <cstring>
#include <cmath>
#include <unistd.h>
#include <OpenAL/al.h>
#include <OpenAL/alc.h>
#include "../ISoundStream.h"

#define ERR (errCheck(__LINE__))

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>

OpenALStreamPlayer::OpenALStreamPlayer():
mSampleRate(44100),
mBufferCount(4),
mBufferIds(0),
mChannels(1),
mSoundSource(0)
{
    float desiredBufLen = 1;
    mBufLen = desiredBufLen * mSampleRate * mChannels;
    mBuffer = new short[mBufLen];

}


static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.SLESPlayer");

void OpenALStreamPlayer::setVolume(float val){
    alSourcef(mSource, AL_GAIN, val);
}

void OpenALStreamPlayer::initOpenal(){
//    const ALCchar *devices = alcGetString(mDevice, ALC_DEVICE_SPECIFIER);
//    const ALCchar *device = devices, *next = devices + 1;
//    size_t len = 0;
    
//    LOG4CPLUS_INFO(logger,  "Devices list:");
//    while (device && *device != '\0' && next && *next != '\0') {
//        LOG4CPLUS_INFO_FMT(logger, " %s", device);
//        len = std::strlen(device);
//        break;
//        device += (len + 1);
//        next += (len + 2);
//    }

    mDevice = alcOpenDevice(0);
    mContext = alcCreateContext(mDevice, 0);
    ERR;
    if (!alcMakeContextCurrent(mContext)){
        LOG4CPLUS_ERROR(logger,  "alcMakeCurrent failed");
        ERR;
    }

    mBufferIds = new ALuint[mBufferCount];
    alGenBuffers((ALuint)mBufferCount, mBufferIds);
    ERR;
    alGenSources((ALuint)1, &mSource);
    ERR;
    alSourcei(mSource, AL_LOOPING, AL_FALSE);
    
    for (int i = 0; i< mBufferCount; i++){
        refillBuffer();
        loadBuffer(mBufferIds[i]);
    }
    //setVolume(0.02);
}

void OpenALStreamPlayer::play(){
    LOG4CPLUS_WARN(logger, "play()");
    initOpenal();
    LOG4CPLUS_WARN_FMT(logger, "source valid: %d", alIsSource(mSource));

    alSourcePlay(mSource);
    ERR;
    start();
}


void OpenALStreamPlayer::loadBuffer(ALuint bufId){
    LOG4CPLUS_DEBUG_FMT(logger, "loadBuffer( %d )", bufId);
    int dataLen = mLoadedFramesCount * 2; //TODO channels count
    alBufferData(bufId, AL_FORMAT_MONO16, mBuffer, dataLen, mSampleRate);
    ERR;
    alSourceQueueBuffers(mSource, 1, &bufId);
    ERR;
}

void OpenALStreamPlayer::genSine(float freq){
    for (int i = 0; i<mBufLen; i++){
        mBuffer[i] = std::sin(((float)i)/mSampleRate*freq*M_PI)*3000;
    }
    mLoadedFramesCount = mBufLen;
}

void OpenALStreamPlayer::refillBuffer(){
    mLoadedFramesCount = mSoundSource->read(mBuffer, mBufLen);
}

void OpenALStreamPlayer::errCheck(int lineNo){
    ALenum ret = alGetError();
    if (ret != AL_NO_ERROR){
        LOG4CPLUS_ERROR_FMT(logger, "ERROR: return value %x at %d", ret, lineNo);
    }
}

void OpenALStreamPlayer::run(){
    LOG4CPLUS_WARN(logger, "starting thread");
    ALint oldProc = 0;
    while (!mSoundSource->isEOF()){
        ALint buffersProcessed = -1;
        ALint buffersQueued = -1;
        alGetSourcei(mSource, AL_BUFFERS_PROCESSED, &buffersProcessed);
//        LOG4CPLUS_DEBUG_FMT(logger, "buffers processed: %d", buffersProcessed);
        if (buffersProcessed != 0){
            oldProc = buffersProcessed;
//            LOG4CPLUS_DEBUG(logger, "flipping buffers...");
            ALuint bufId = -1;
            alSourceUnqueueBuffers(mSource, 1, &bufId);
            ERR;
            refillBuffer();
            loadBuffer(bufId); // don't check loaded frames count here, because i'm sure we will exit the loop by EOF
        }
        else{
            usleep(100000);
        }
    }
    LOG4CPLUS_WARN(logger, "thread exitted");
}

void OpenALStreamPlayer::pause(){
    alSourcePause(mSource);
//    LOG4CPLUS_ERROR(logger, "OpenAL: pause() unimplemented");
}

void OpenALStreamPlayer::resume(){
    alSourcePlay(mSource);
//    LOG4CPLUS_ERROR(logger, "OpenAL: resume() unimplemented");
}

OpenALStreamPlayer::~OpenALStreamPlayer(){
    LOG4CPLUS_WARN(logger, "destructor called");
    alDeleteSources(1, &mSource);
    ERR;
    alDeleteBuffers(mBufferCount, mBufferIds);
    ERR;
    alcMakeContextCurrent(NULL);
    ERR;
    alcDestroyContext(mContext);
    ERR;
    alcCloseDevice(mDevice);
    ERR;
}
