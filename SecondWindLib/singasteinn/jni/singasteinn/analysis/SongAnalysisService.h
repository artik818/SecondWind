#ifndef SONGANALYSUSQUEUE_H
#define SONGANALYSUSQUEUE_H

#include <pthread.h>
#include <queue>
#include <utility>
#include "../Song.h"
#include "../Thread.h"
#include "../threading/WorkerThread.h"

class ITempoStorage;

//using singasteinn::WorkerTask;
//using singasteinn::WorkerThread;
namespace singasteinn{
class SongAnalysisService{

public:

    class SongAnalysisTask: public WorkerTask{
        Song::Ptr mSong;
        SongAnalysisService *mAnalyzer;
    protected:
        void real_execute();
    public:
        SongAnalysisTask(Song::Ptr song, SongAnalysisService *analyzer);
        bool isDuplicateOf(const WorkerTask &other) const;
    };

private:
    WorkerThread mWorker;
    ITempoStorage * mTempoStorage;
public:

    void setTempoStorage(ITempoStorage * storage){
        mTempoStorage = storage;
    }
    SongAnalysisService();
    WorkerTask::Ptr queueSong(Song::Ptr song, WorkerTask::Ptr callback=WorkerTask::Ptr());

    /*
     * Use this method to start song processing
     * The method can be invoked from different threads at the same time
     */
    void processSongSync(Song::Ptr song);
};
}

#endif
