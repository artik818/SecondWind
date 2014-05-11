#ifndef IPLAYBACKCONTROLLER
#define IPLAYBACKCONTROLLER

#include "../Song.h"


namespace singasteinn{

class IPlaybackCallback;

class IPlaybackController{

public:
    enum PlaybackState{
        PS_Error = -1,
        PS_Stopped,
        PS_Playing,
        PS_Paused
    };


    virtual void switchToSong(Song::Ptr song) = 0;


    virtual PlaybackState getPlaybackState() = 0;
    virtual void setPlaybackState(PlaybackState state) = 0;

    /**
     * @return current track duration in seconds or -1 if not implemented/unapplicable
     */
    virtual float getCurrentItemDuration() = 0;

    /**
     * @return current track position in seconds or -1 if not implemented/unapplicable
     */
    virtual float getPlaybackPosition() = 0;
    /**
     * @brief try to seek the currently playing stream, if seeking is not supported, nothing happens
     */
    virtual void seekPlayback(float position) = 0;

    virtual void setCallback(IPlaybackCallback * callback) = 0;
};

class IPlaybackCallback{
public:
    /**
     * @brief called when the next track is required.
     * The callback should call IPlaybackController::switchToSong() from this method
     * in order to continue playback
     */
    virtual void onTrackEnd() = 0;

    /**
     * @brief called after playback state transition
     */
    virtual void onPlaybackStateChanged(IPlaybackController::PlaybackState) = 0;

    /**
     * TBD
     */
    virtual void onPlaybackPositionChanged(float position){}
};


}

#endif
