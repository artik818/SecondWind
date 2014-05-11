#ifndef WAVSTREAMWRITER_H
#define WAVSTREAMWRITER_H
#include "IStreamPlayer.h"
#include "../threading/WorkerThread.h"
#include <stdio.h>
#include <string>

namespace singasteinn{

class WavStreamWriter: public IStreamPlayer, public IMessageCallback{
    ISoundSource * mSoundSource;
    FILE * f;
    WorkerThread mWorker;
    std::string mOutFileName;
    ISoundSource::SampleType * mBuffer;
    int mBufferLen;

protected:
    void writeHeader();
    void handleMessage(int code, WorkerThread::MessagePtr arg);

public:
    WavStreamWriter();
    void setOutput(std::string path);
    virtual void setSource(ISoundSource * src);
    virtual ~WavStreamWriter(){}
    virtual void run(){}
    virtual void play(){}
    virtual void pause(){}
    virtual void resume(){}
    virtual ISoundSource * getCurrentStream(){return mSoundSource;}
    void closeOutput();
};
}





#endif

