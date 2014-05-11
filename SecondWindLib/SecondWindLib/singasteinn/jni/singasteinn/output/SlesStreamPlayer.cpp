#include "SlesStreamPlayer.h"
#include <unistd.h>
#define C(foo) checkCall(__LINE__, (foo))


SlesStreamPlayer::SlesStreamPlayer():
    mSrc(0),
    mChannels(1),
    outBufSamples(44100),
    currentOutputIndex(0)
{
    outputBuffer[0] = new short[outBufSamples];
    outputBuffer[1] = new short[outBufSamples];
    setupOpenSL();
}

void SlesStreamPlayer::setupOpenSL(){
/*
 *openSLCreateEngine
 *openSLPlayOpen
 *
 *android_audoiout
 */

    C(slCreateEngine(&mEngineObject, 0, 0, 0, 0, 0));
    C((*mEngineObject)->Realize(mEngineObject, SL_BOOLEAN_FALSE));
    C((*mEngineObject)->GetInterface(mEngineObject, SL_IID_ENGINE, &mEngineEngine));


    // output setup
    int speakers = SL_SPEAKER_FRONT_CENTER;
    SLDataFormat_PCM format_pcm = {SL_DATAFORMAT_PCM, mChannels, SL_SAMPLINGRATE_44_1,
                                   SL_PCMSAMPLEFORMAT_FIXED_16, SL_PCMSAMPLEFORMAT_FIXED_16,
                                   speakers, SL_BYTEORDER_LITTLEENDIAN};

    const SLInterfaceID ids[] = {SL_IID_ENVIRONMENTALREVERB};
    const SLboolean req[] = {SL_BOOLEAN_FALSE};
    C((*mEngineEngine)->CreateOutputMix(mEngineEngine, &outputMixObject, 0, ids, req));
    C((*outputMixObject)->Realize(outputMixObject, SL_BOOLEAN_FALSE));



    SLDataLocator_AndroidSimpleBufferQueue loc_bufq = {SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE, 2};
    SLDataSource audioSrc = {&loc_bufq, &format_pcm};

    // configure audio sink
    SLDataLocator_OutputMix loc_outmix = {SL_DATALOCATOR_OUTPUTMIX, outputMixObject};
    SLDataSink audioSnk = {&loc_outmix, NULL};




    const SLInterfaceID ids1[] = {SL_IID_ANDROIDSIMPLEBUFFERQUEUE};
//   const SLInterfaceID ids1[] = {SL_IID_BUFFERQUEUE};
    const SLboolean req1[] = {SL_BOOLEAN_TRUE};
    C((*mEngineEngine)->CreateAudioPlayer(mEngineEngine, &bqPlayerObject, &audioSrc, &audioSnk,
                                                   1, ids1, req1));

    C((*bqPlayerObject)->Realize(bqPlayerObject, SL_BOOLEAN_FALSE));


    // get the play interface
    C((*bqPlayerObject)->GetInterface(bqPlayerObject, SL_IID_PLAY, &bqPlayerPlay));

    // get the buffer queue interface
    C((*bqPlayerObject)->GetInterface(bqPlayerObject, SL_IID_ANDROIDSIMPLEBUFFERQUEUE,
                                                &bqPlayerBufferQueue));

    // register callback on the buffer queue
    C((*bqPlayerBufferQueue)->RegisterCallback(bqPlayerBufferQueue, playerCallback, this));

    // set the player's state to playing
    C((*bqPlayerPlay)->SetPlayState(bqPlayerPlay, SL_PLAYSTATE_PLAYING));
    mNeedToFlip = true;
}

// buffer finished
void SlesStreamPlayer::playerCallback(SLAndroidSimpleBufferQueueItf bq, void *context){
    static_cast<SlesStreamPlayer *>(context)->requestBufferFlip();

}

void SlesStreamPlayer::requestBufferFlip(){
    fprintf(stderr, "Buffer flip request\n");
    mNeedToFlip = true;
}

void SlesStreamPlayer::refillBuffer(){
    mSrc->read(outputBuffer[currentOutputIndex], outBufSamples);
}

void SlesStreamPlayer::flipBuffers(){
    fprintf(stderr, "Enqueuing buffer %d\n", currentOutputIndex);
    C((*bqPlayerBufferQueue)->Enqueue(bqPlayerBufferQueue,
                                      outputBuffer[currentOutputIndex],outBufSamples*sizeof(short)));
    currentOutputIndex = currentOutputIndex?0:1;
}

void SlesStreamPlayer::mainLoop(){
    refillBuffer();
    while (true){
        fprintf(stderr, "main loop\n");
        if (mNeedToFlip){
            flipBuffers();
            refillBuffer();
            mNeedToFlip = false;
        }
        usleep (10 * 1000);

    }

    // Android_AudoiOut

}

SlesStreamPlayer::~SlesStreamPlayer(){
    cleanupOpenSl();
}

void SlesStreamPlayer::cleanupOpenSl(){

}

void SlesStreamPlayer::play(){

}
