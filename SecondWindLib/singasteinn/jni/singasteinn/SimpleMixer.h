 #ifndef SIMPLEMIXER_H
#define SIMPLEMIXER_H

#include "ISoundStream.h"
#include "SmartPtr.h"

class SimpleMixer: public ISoundSource {
public:
    class Callback{
        friend class SimpleMixer;
    protected:
        virtual void onMixerTrackEnd(SimpleMixer* mixer) = 0;
    };
private:
    bool mRepeatOne;
    bool mAutoDeleteStreams;
    shared_ptr<ISoundSource> mCurrentStream;
    Callback * mCallback;


public:

    SimpleMixer(Callback* callback):
        mAutoDeleteStreams(1),
        mCurrentStream(),
        mCallback(callback){}
    virtual ~SimpleMixer(){}
    void switchTo(shared_ptr<ISoundSource> src){
        mCurrentStream = src;
    }
    shared_ptr<ISoundSource> getCurrentStream(){
        return mCurrentStream;
    }

    virtual int getSampleRate();
    virtual int read(SampleType * buf, int len);
    virtual bool isEOF();



};

#endif
