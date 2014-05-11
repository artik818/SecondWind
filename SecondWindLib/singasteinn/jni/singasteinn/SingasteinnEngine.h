#ifndef SINGASTEINN_ENGINE_H
#define SINGASTEINN_ENGINE_H

#include "output/IStreamPlayer.h"
#include "TempoScaler.h"
#include "SimpleMixer.h"
#include "ITempoStorage.h"
#include "Song.h"
#include <pthread.h>
#include <vector>
#include "threading/WorkerThread.h"
#include "analysis/SongAnalysisService.h"
#include "interface/IFittingController.h"

namespace singasteinn{
class IPlaybackController;
class IFittingController;
class Song;
class SongStream;
class PlaybackControllerImpl;
class SensorHandler;


class SingasteinnEngine: public IStreamPlayerClient, public SimpleMixer::Callback, public IMessageCallback{
public:
    typedef std::vector<Song::Ptr> Tracklist;
    enum PlaybackState{
        Stopped = 1,
        Playing = 2,
        Paused = 3
    };
private:
    static SingasteinnEngine * mInstance;
    SensorHandler *mSensorHandler;
    ::shared_ptr<IStreamPlayer> mPlayer;
    SimpleMixer * mMixer;
    ITempoStorage * mTempoStorage;
    PlaybackControllerImpl * mPlaybackController;
    IFittingController * mFittingController;
    int mCurrentTrack;
    bool mAlive;
    Tracklist mPlaylist;
    PlaybackState mPlaybackState;
    SongAnalysisService mAnalysisQueue;

    std::string mWavOutPath;
    WorkerThread mWorker;

//    void setCurrentTrackIndex(int n);
protected:
    void initSensor();
    virtual void handleMessage(int code, WorkerThread::MessagePtr arg);
    virtual void onEOF(IStreamPlayer *player);
public:
    static const int
        MSG_START_PLAYBACK,
        MSG_STOP_PLAYBACK,
        MSG_PAUSE_PLAYBACK,
        MSG_SET_CURRENT_TRACK,
        MSG_SET_CURRENT_TRACKLIST;

    SingasteinnEngine(std::string cachePath = "");
    static void initializeLogging();

    virtual ~SingasteinnEngine();
    static SingasteinnEngine * get();

    void run();

    void playSong(Song::Ptr song);
    void playDirectory(std::string path);

    void switchToSong(Song::Ptr song);

//    Tracklist getCurrentList();
//    void setCurrentList(Tracklist);
//    int getCurrentTrackIndex();

    PlaybackState getPlaybackState(){
        return mPlaybackState;
    }

    // callbacks

    void onMixerTrackEnd(SimpleMixer *mixer);

    SensorHandler * getSensorHandler(){
        return mSensorHandler;
    }

    void setWavDumpPath(std::string path){
        mWavOutPath = path;
    }

    ITempoStorage * getTempoStorage(){
        return mTempoStorage;
    }



    shared_ptr<IStreamPlayer> getStreamPlayer();

    void sendMessage(int code, WorkerThread::MessagePtr msg = WorkerThread::MessagePtr()){
        mWorker.postMessage(code, msg);
    }


    /*
     * Note we are assuming that there is at most one songstream so crossfade is not supported
     * Crossfade support needs phase sync but phase analysis is not implemented yet
     */
    shared_ptr<SongStream> getCurrentStream();

    /*
     *  The methods above is for internal use only
     *  They will be hidden domehow later.
     *  Please use the following controllers to interact with the engine
     */

    IPlaybackController * getPlaybackController();
    IFittingController * getFittingController();
};

}


#endif
