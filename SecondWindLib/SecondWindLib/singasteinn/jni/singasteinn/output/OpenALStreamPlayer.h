#ifndef STREAMPLAYER_H
#define STREAMPLAYER_H
#include "IStreamPlayer.h"
#include <OpenAl/alc.h>
#include <OpenAl/al.h>

#include <vector>
#include "../Thread.h"
class ISoundSource;

class OpenALStreamPlayer: public IStreamPlayer, public Thread{
    ALCcontext* mContext;
    ALCdevice* mDevice;
    ALuint mSource;
    ALuint * mBufferIds;

    int mSampleRate;
    int mBufLen;
    int mBufferCount;
    int mChannels;
    
    short * mBuffer;
    int mLoadedFramesCount;
    ISoundSource * mSoundSource;
    void refillBuffer();
    void loadBuffer(ALuint bufId);
    void errCheck(int lineNo);
    void genSine(float freq);
    void initOpenal();
    void setVolume(float val);

public:
    OpenALStreamPlayer();
    virtual void setSource(ISoundSource * src){mSoundSource = src;}
    virtual ~OpenALStreamPlayer();
    virtual void run();
    virtual void play();
    virtual void pause();
    virtual void resume();
    virtual ISoundSource * getCurrentStream(){return mSoundSource;}

};

#endif
