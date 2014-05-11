#include "SongAnalysisService.h"

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>
#include <unistd.h>
#include "../logging.h"

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.SongAnalysisQueue");
using namespace singasteinn;

SongAnalysisService::SongAnalysisService():
    mTempoStorage(0)
{
    mWorker.start();
}


void SongAnalysisService::processSongSync(Song::Ptr song){
    if (mTempoStorage)
        song->readTempoData(mTempoStorage);
    if (!song -> getTempoData()){
        song->generateTempoData();
        if (mTempoStorage)
            song->saveTempoData(mTempoStorage);
    }
}

SongAnalysisService::SongAnalysisTask::SongAnalysisTask(Song::Ptr song, SongAnalysisService *analyzer):
    mSong(song),
    mAnalyzer(analyzer)
{
    assert(analyzer);
}

bool SongAnalysisService::SongAnalysisTask::isDuplicateOf(const WorkerTask &other) const{
    const SongAnalysisTask * t = dynamic_cast<const SongAnalysisTask*>(&other);
    if (!t){
        LOGI("Song analysis task is compared to another task");
        return false;
    }
    LOGIF("Comparing analysis tasks: %s, %s", mSong -> getUrl().c_str(), t -> mSong -> getUrl().c_str());
    return mSong -> getUrl() == t -> mSong -> getUrl();
}


void SongAnalysisService::SongAnalysisTask::real_execute(){
    mAnalyzer->processSongSync(mSong);
}

WorkerTask::Ptr SongAnalysisService::queueSong(Song::Ptr song, WorkerTask::Ptr callback){
    WorkerTask::Ptr ret(new SongAnalysisTask(song, this));
    ret = mWorker.postTask(ret);
    if (callback)
        mWorker.postTask(callback);
    return ret;
}



