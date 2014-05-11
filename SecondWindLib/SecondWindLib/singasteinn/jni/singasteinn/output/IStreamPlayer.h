#ifndef ISTREAMPLAYER_H
#define ISTREAMPLAYER_H
#include "../ISoundStream.h"

class IStreamPlayerClient;

class IStreamPlayer{
    IStreamPlayerClient * mClient; // TODO create come kind of BasicPlayer and move the field there
public:
    IStreamPlayer():mClient(0){}

    virtual void setSource(ISoundSource *) = 0;
    virtual void play() = 0;
    virtual void pause() = 0;
    virtual void resume() = 0;

    virtual ISoundSource * getCurrentStream() = 0;
    virtual ~IStreamPlayer(){}

    void setClient(IStreamPlayerClient *cli){mClient = cli;}
    IStreamPlayerClient * getClient(){return mClient;}

};

class IStreamPlayerClient {
public:
    virtual ~IStreamPlayerClient(){}
    virtual void onEOF(IStreamPlayer * player) = 0;
};

#endif
