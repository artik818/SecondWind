#include "SingasteinnEngine.h"
#include "platform.h"
#include "Song.h"
#include "SongStream.h"
#include "SimpleTempoStorage.h"
#include "output/WAvStreamWriter.h"
#include "interface/IPlaybackController.h"

#include <log4cplus/consoleappender.h>
#include <log4cplus/socketappender.h>
#include <log4cplus/logger.h>
#include <log4cplus/loglevel.h>
#include <log4cplus/loggingmacros.h>
#include <signal.h>
#include "logging.h"
#include "dirent.h"
#include "interface/PlaybackControllerImpl.h"
#include "interface/FittingControllerImpl.h"

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.Engine");

using namespace singasteinn;

SingasteinnEngine * SingasteinnEngine::mInstance = 0;

const int SingasteinnEngine::MSG_START_PLAYBACK = 10;
const int SingasteinnEngine::MSG_STOP_PLAYBACK = 11;
const int SingasteinnEngine::MSG_PAUSE_PLAYBACK = 12;
const int SingasteinnEngine::MSG_SET_CURRENT_TRACK = 15;
const int SingasteinnEngine::MSG_SET_CURRENT_TRACKLIST = 16;

using singasteinn::WavStreamWriter;

SingasteinnEngine::SingasteinnEngine(std::string cachePath):
    mAlive(1),
    mCurrentTrack(0),
    mTempoStorage(0),
    mWorker(this)
{
    assert(!mInstance); // I'm singletone!
    mInstance = this;
    initializeLogging();
    mSensorHandler = new SensorHandler(1024);
    mTempoStorage = new SimpleTempoStorage(cachePath);
    dynamic_cast<SimpleTempoStorage*>(mTempoStorage)->setWriteOnly(true);
    mMixer = new SimpleMixer(this);
    mWorker.start();
    mPlaybackController = new PlaybackControllerImpl(this);
    mFittingController = new FittingControllerImpl(this);

}

SingasteinnEngine::~SingasteinnEngine(){
    if (mPlayer)
        mPlayer.reset();
}

void SingasteinnEngine::initializeLogging(){
    signal(SIGPIPE, SIG_IGN);
    static bool initialized = false;
    if (initialized){
        return;
    }
    log4cplus::initialize ();
    log4cplus::SharedAppenderPtr append_1(new log4cplus::ConsoleAppender());
    append_1->setName(LOG4CPLUS_TEXT("Console"));
    append_1->setLayout(std::auto_ptr<log4cplus::Layout>(new log4cplus::PatternLayout("%d{%H:%M:%S.%q} %c{1}: %m\n")));
    //log4cplus::SharedAppenderPtr append_2(new log4cplus::SocketAppender("192.168.1.14", 6666, "randir"));
    //append_2->setName(LOG4CPLUS_TEXT("Network"));
    //append_2->setLayout(std::auto_ptr<log4cplus::Layout>(new log4cplus::PatternLayout("%d{%H:%M:%S.%q} %c{1}: %m\n")));
    log4cplus::Logger::getRoot().addAppender(append_1);
    //log4cplus::Logger::getRoot().addAppender(append_2);

    LOG4CPLUS_INFO(logger, "Logging init Ok");
    initialized = true;
}

void SingasteinnEngine::playSong(Song::Ptr song){
//    LOG4CPLUS_WARN_FMT(logger, "Playing song %s", song->getUrl().c_str());
    /*if (!song->readTempoData(mTempoStorage)){
        song->generateTempoData();
        song->saveTempoData(mTempoStorage);
    }
    song->getTempoData()->print();*/
//    std::vector<Song::Ptr> p;
//    p.push_back(song);
//    p.push_back(song);
//    p.push_back(song);
//    setCurrentList(p);
//    mCurrentTrack = 0;
//    sendMessage(MSG_START_PLAYBACK);
}

void SingasteinnEngine::playDirectory(std::string path){
    DIR * dir = opendir(path.c_str());
//    LOGIF("Opening directory %s", path.c_str());
    assert(dir);
    struct dirent * entry;
    Tracklist t;
    while ((entry = readdir(dir))){
        std::string fn = std::string(entry->d_name, entry->d_namlen);
        if (entry->d_namlen > 4 && fn.substr(entry->d_namlen - 4) == ".mp3"){
            LOGIF("Adding song %s", fn.c_str());
            t.push_back(Song::Ptr(new Song("file://" + path + "/" + fn)));
        } else {
            LOGIF("Skipping entry '%s'", fn.c_str());
        }
    }
//    setCurrentList(t);


}

void SingasteinnEngine::run(){
    while (mAlive){

        sleep(1);
    }
}

void SingasteinnEngine::onEOF(IStreamPlayer *player){
    assert(player == mPlayer.get());
    LOG4CPLUS_WARN(logger, "EOF");

}

//void SingasteinnEngine::setCurrentList(Tracklist pl){
//    LOG4CPLUS_INFO_FMT(logger, "Playlist changed, new length: %d", (int)pl.size());
//    sendMessage(MSG_SET_CURRENT_TRACKLIST, WorkerThread::MessagePtr(new WorkerThread::Message(0, new Tracklist(pl))));
//}

//int SingasteinnEngine::getCurrentTrackIndex(){
//    return mCurrentTrack;
//}


void SingasteinnEngine::onMixerTrackEnd(SimpleMixer *mixer){
    LOG4CPLUS_WARN_FMT(logger, "track ended, switching to next (%d)", mCurrentTrack);
//    mWorker.postMessage(MSG_SET_CURRENT_TRACK, WorkerThread::MessagePtr(new WorkerThread::Message(mCurrentTrack + 1)))->wait();
    IPlaybackCallback * callback = mPlaybackController->getCallback();
    if (callback)
        callback->onTrackEnd();
}

//void SingasteinnEngine::setCurrentTrackIndex(int n){
//    LOG4CPLUS_INFO_FMT(logger, "set current track: %d", n);
//    mCurrentTrack = n;
//    if (mCurrentTrack >= mPlaylist.size())
//        return;
//    assert(mCurrentTrack < mPlaylist.size());
//    Song::Ptr song = mPlaylist[mCurrentTrack];
//    if (!song->getTempoData()){
//        LOGW("Song has no tempo data, queuing for analysis and waiting...");
//        mAnalysisQueue.queueSong(song)->wait();
//        LOGW("Ready to play!");
//    }
//    if (!mWavOutPath.empty()){
//        LOGW("Reopening output stream...");
////        WavStreamWriter * ww = dynamic_cast<WavStreamWriter *>(mPlayer.get());t
//        ::shared_ptr<WavStreamWriter> ww = ::dynamic_pointer_cast<WavStreamWriter>(mPlayer);
////        assert(ww);
//        ww->setOutput(SimpleTempoStorage::escapeUrl(song->getUrl()) + ".wav");

//    }
//    // TODO apply playback mode here
//    mMixer->switchTo(shared_ptr<ISoundSource>(new SongStream(mPlaylist.at(mCurrentTrack))));
//}

void SingasteinnEngine::switchToSong(Song::Ptr song){
    mMixer->switchTo(shared_ptr<ISoundSource>(new SongStream(song)));
}

shared_ptr<SongStream> SingasteinnEngine::getCurrentStream(){

    if (!mMixer){
        return shared_ptr<SongStream>();
    }
    return dynamic_pointer_cast<SongStream>(mMixer->getCurrentStream());
}

IPlaybackController * SingasteinnEngine::getPlaybackController(){
    return mPlaybackController;
}

//SingasteinnEngine::Tracklist SingasteinnEngine::getCurrentList(){
//    return mPlaylist;
//}

SingasteinnEngine * SingasteinnEngine::get(){
    return mInstance;
}

void SingasteinnEngine::handleMessage(int code, WorkerThread::MessagePtr msg){
    LOGIF("Handling message %d", code);
    switch(code){
    case MSG_START_PLAYBACK:
        mPlaybackState = Playing;
        if (mPlayer){
            LOG4CPLUS_WARN(logger, "startPlayback: streamplayer exists, assuming paused state");
            mPlayer->resume();
            return;
        }
        if (mWavOutPath.empty()){
            mPlayer = ::shared_ptr<IStreamPlayer>(new PlatformStreamPlayer());
        }
        else{
            mPlayer = ::shared_ptr<IStreamPlayer>(new WavStreamWriter());
            //dynamic_cast<WavStreamWriter*>(mPlayer)->setOutput(SimpleTempoStorage::escapeUrl());
        }
//        setCurrentTrackIndex(mCurrentTrack);
        mPlayer->setSource(mMixer);
        mPlayer->setClient(this);
        mPlayer->play();
        break;
    case MSG_STOP_PLAYBACK:
        if (!mPlayer){
            LOG4CPLUS_ERROR(logger, "stopPlayback called but streamplayer does not exists");
            return;
        }
        mPlaybackState = Stopped;
        // TODO check if destructor stops playback correctly
        mPlayer.reset();
        break;
    case MSG_PAUSE_PLAYBACK:
        if (!mPlayer){
            LOG4CPLUS_ERROR(logger, "pausePlayback called but streamplayer does not exists");
            return;
        }
        mPlaybackState = Paused;
        mPlayer->pause();

        break;

    case MSG_SET_CURRENT_TRACK:
//        setCurrentTrackIndex(msg->mArg);
        break;
//    case MSG_SET_CURRENT_TRACKLIST:
//        Tracklist * tr = (Tracklist*) msg->mObj;
//        mPlaylist = *tr;
//        delete tr;
//        mCurrentTrack = 0;
//        for (Tracklist::iterator i = mPlaylist.begin();
//             i != mPlaylist.end();
//             i++){
//            mAnalysisQueue.queueSong(*i);
//        }
//        setCurrentTrackIndex(0);
//        break;

    }

}

IFittingController * SingasteinnEngine::getFittingController(){
    return mFittingController;
}

