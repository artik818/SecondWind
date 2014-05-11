#ifndef SLESSTREAMPLAYER_H
#define SLESSTREAMPLAYER_H
#include "IStreamPlayer.h"
#include <SLES/OpenSLES.h>
#include <SLES/OpenSLES_Android.h>

class SlesStreamPlayer: public IStreamPlayer{
    ISoundSource * mSrc;

    SLObjectItf mEngineObject;
    SLEngineItf mEngineEngine;
    SLObjectItf outputMixObject;

    SLObjectItf bqPlayerObject;
    SLPlayItf bqPlayerPlay;
    SLAndroidSimpleBufferQueueItf bqPlayerBufferQueue;
    SLEffectSendItf bqPlayerEffectSend;

    void * mOutLock;

    int currentOutputIndex;

    short *outputBuffer[2];
    int outBufSamples;

    int mChannels;

    void setupOpenSL();
    void cleanupOpenSl();
    void checkCall(int lineNumber, int ret){

        if (ret!=SL_RESULT_SUCCESS){
            fprintf(stderr, "line %d: error: return code: %x\n", lineNumber, ret);
        }
        else{
            fprintf(stderr, "line %d ok\n", lineNumber);
        }
  }
  static void playerCallback(SLAndroidSimpleBufferQueueItf bq, void *context);

  void audioOut();
  void requestBufferFlip();
  void flipBuffers();
  void refillBuffer();
  bool mNeedToFlip;

public:
    virtual void setSource(ISoundSource * src){mSrc = src;}
    virtual void mainLoop();
    virtual void play();
    virtual ISoundSource * getCurrentStream(){return mSrc;}
    virtual void pause(){}
    virtual void resume(){}

    SlesStreamPlayer();
    virtual ~SlesStreamPlayer();

};


#endif




