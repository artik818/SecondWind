#ifndef TEMPOSCALER_H
#define TEMPOSCALER_H
#include "SoundTouch.h"
#include "ISoundStream.h"

class TempoScaler: public ISoundSource, public ISeekable{
    ISoundSource * mSrc;
    soundtouch::SoundTouch * mScaler;
    soundtouch::SAMPLETYPE * mBuffer;
    int mBufferLen;
    bool mEOF;
    void feedData();
public:
    TempoScaler(ISoundSource * src);
    virtual ~TempoScaler();
    virtual int read(SampleType * buf, int len);
    virtual int getSampleRate(){return mSrc -> getSampleRate();}
    void setTempo(float tempo);
    virtual bool isEOF(){return mEOF;}

    virtual float tellSec();
    virtual void seekSec(float pos);
};


#endif //TEMPOSCALER_H
