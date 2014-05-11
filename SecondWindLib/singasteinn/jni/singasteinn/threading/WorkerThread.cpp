#include "WorkerThread.h"
#include "../logging.h"

using namespace singasteinn;
#include "ScopedLock.h"

LOGGER("singasteinn.WorkerThread");

WorkerThread::WorkerThread(IMessageCallback *msgCallback):
    mMsgCallback(msgCallback)
{
    pthread_mutex_init(&mQueueMutex, 0);
    pthread_cond_init(&mQueueCond, 0);
}

void WorkerThread::run(){
    mStopRequested = false;
    LOGW("Thread starting");
    while (!mStopRequested){
        WorkerTask::Ptr task;
        pthread_mutex_lock(&mQueueMutex);
        if (mQueue.empty()){
//            LOGI("Queue is empty, waiting");
            pthread_cond_wait(&mQueueCond, &mQueueMutex);
        }
        mCurrentTask = mQueue.front();
        mQueue.pop_front();

        pthread_mutex_unlock(&mQueueMutex);
        mCurrentTask->execute();
        {
            ScopedLock l(&mQueueMutex);
            mCurrentTask.reset();
        }
    }
    LOGW("Thread exitting");
}


WorkerTask::Ptr WorkerThread::postTask(WorkerTask::Ptr task){
//    LOGIF("Adding task %d", &(*task));
    if (!isStarted())
        start();
    {
        ScopedLock lock(&mQueueMutex);
        for (std::deque<WorkerTask::Ptr>::const_iterator i = mQueue.begin();
             i != mQueue.end();
             i++){
            if ((*i)->isDuplicateOf(*task)){
                LOGI("Task already exists, returning the existing one");
                return *i;
            }
        }
        if (mCurrentTask && mCurrentTask->isDuplicateOf(*task)){
            return mCurrentTask;
        }
        mQueue.push_back(task);
    }
    pthread_cond_broadcast(&mQueueCond);
    return task;
}

WorkerTask::Ptr WorkerThread::postMessage(int code, WorkerThread::MessagePtr arg){
    LOGIF("Post message %d to %p", code, mMsgCallback);
    WorkerTask::Ptr ret(new MessageTask(code, arg, mMsgCallback));
    postTask(ret);
    return ret;
}

ForwardTask::ForwardTask(shared_ptr<WorkerThread> worker, WorkerTask::Ptr task):
    mWorker(worker),
    mTask(task)
{
}

void ForwardTask::real_execute(){
    mWorker -> postTask(mTask);
}

MessageTask::MessageTask(int messageCode, WorkerThread::MessagePtr arg, IMessageCallback *cb):
    mCode(messageCode),
    mArg(arg),
    mCallback(cb)
{
    assert(mCallback);
}

void MessageTask::real_execute(){
    assert(mCallback);
    mCallback -> handleMessage(mCode, mArg);
}


