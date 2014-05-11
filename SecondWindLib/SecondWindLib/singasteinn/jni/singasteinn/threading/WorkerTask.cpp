#include "WorkerTask.h"

using namespace singasteinn;

WorkerTask::WorkerTask():
    mDone(0)
{
    pthread_mutex_init(&mMutex, 0);
    pthread_cond_init(&mCond, 0);
}

void WorkerTask::execute(){
    real_execute();
    mDone = true;
    pthread_cond_broadcast(&mCond);
}

void WorkerTask::wait(){
    pthread_mutex_lock(&mMutex);
    pthread_cond_wait(&mCond, &mMutex);
    pthread_mutex_unlock(&mMutex);
}

bool WorkerTask::isDuplicateOf(const WorkerTask &other) const {
    return false;
}
