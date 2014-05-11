#ifndef PLAYBACKCONTROLLERIMPL_H
#define PLAYBACKCONTROLLERIMPL_H

#include "IPlaybackController.h"

namespace singasteinn {
class SingasteinnEngine;

class PlaybackControllerImpl: public IPlaybackController{
    SingasteinnEngine * mEngine;
    IPlaybackCallback * mCallback;
public:
    PlaybackControllerImpl(SingasteinnEngine *eng);

    virtual PlaybackState getPlaybackState();
    virtual void setPlaybackState(PlaybackState state);

    virtual float getCurrentItemDuration();
    virtual float getPlaybackPosition();
    virtual void seekPlayback(float position);

    virtual void switchToSong(Song::Ptr song);

    virtual void setCallback(IPlaybackCallback * callback);

    IPlaybackCallback * getCallback();

};

}


#endif
