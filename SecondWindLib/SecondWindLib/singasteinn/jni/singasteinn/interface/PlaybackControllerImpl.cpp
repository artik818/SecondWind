#include "PlaybackControllerImpl.h"
#include "../SingasteinnEngine.h"
#include "../logging.h"

using namespace singasteinn;

LOGGER("PlaybackController");

PlaybackControllerImpl::PlaybackControllerImpl(SingasteinnEngine *eng):
    mEngine(eng)
{

}


PlaybackControllerImpl::PlaybackState PlaybackControllerImpl::getPlaybackState(){
    switch (mEngine->getPlaybackState()) {
    case SingasteinnEngine::Paused:
        return PS_Paused;
    case SingasteinnEngine::Playing:
        return PS_Playing;
    case SingasteinnEngine::Stopped:
        return PS_Stopped;
    }
    return PS_Error;
}

float PlaybackControllerImpl::getCurrentItemDuration(){
    LOGW("Current item duration not implemented");
    return -1;
}

float PlaybackControllerImpl::getPlaybackPosition(){
    LOGW("Current item position not implemented");
    return 10;
}

void PlaybackControllerImpl::setPlaybackState(PlaybackState state){
    PlaybackState currState = getPlaybackState();
    if (state == currState)
        return;
    switch (state) {
    case PS_Playing:
        mEngine->sendMessage(SingasteinnEngine::MSG_START_PLAYBACK);
        break;
    case PS_Stopped:
        mEngine->sendMessage(SingasteinnEngine::MSG_STOP_PLAYBACK);
        break;
    case PS_Paused:
        mEngine->sendMessage(SingasteinnEngine::MSG_PAUSE_PLAYBACK);
        break;
    }
}

void PlaybackControllerImpl::seekPlayback(float position){

}

void PlaybackControllerImpl::setCallback(IPlaybackCallback *callback){
    mCallback = callback;
}


void PlaybackControllerImpl::switchToSong(Song::Ptr song){
    mEngine->switchToSong(song);
}

IPlaybackCallback * PlaybackControllerImpl::getCallback(){
    return mCallback;
}
