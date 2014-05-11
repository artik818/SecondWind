#include "DummyUi.h"
#include "analysis/SongAnalysisService.h"
#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>
#include <unistd.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.DUI");

DummyUI::DummyUI(){

}

DummyUI::~DummyUI(){

}

void DummyUI::onCurrentTrackChanged(){
    LOG4CPLUS_WARN(logger, "Current track changed");
}


void DummyUI::onPlaybackStateChanged(){
//    LOG4CPLUS_WARN_FMT(logger, "Playback state changed to %d", mEngine.getPlaybackState());
}

void DummyUI::loadAnalysisQueue(){
//    SongAnalysisQueue * q = new SongAnalysisQueue;
//    Song::Ptr s = new Song("/Users/vvs/Downloads/parov_stelar_-_all_night_(zaycev.net).mp3");
//    Song::Ptr s = new Song("file:///Users/vvs/Downloads/Eminem ft 50 Cent - Till I Collapse [pleer.com].mp3");
//    q->queueSong(s, this);

//    s->getTempoData()->print();
}

void DummyUI::onSongAnalysisFinished(singasteinn::Song::Ptr mSong){
    LOG4CPLUS_WARN_FMT(logger, "Async song analysis finished: %s", mSong->getUrl().c_str());
    mSong -> getTempoData()->print();


}

void DummyUI::main(){
//    loadAnalysisQueue();
    mEngine.playSong(singasteinn::Song::Ptr(new singasteinn::Song("/Users/vvs/tmp/music/out/pink_-_raise_your_glass_(zaycev.net).mp3")));
    while(true){
        sleep (5);
    }


}
