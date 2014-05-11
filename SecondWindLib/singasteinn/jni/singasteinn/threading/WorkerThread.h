#ifndef SINGASTEINN_WORKERTHREAD
#define SINGASTEINN_WORKERTHREAD
#include "../Thread.h"
#include "WorkerTask.h"
#include <deque>
namespace singasteinn{

class IMessageCallback;
class WorkerThread: public Thread{
    std::deque<WorkerTask::Ptr> mQueue;
    WorkerTask::Ptr mCurrentTask;
    pthread_mutex_t mQueueMutex;
    pthread_cond_t mQueueCond;
    bool mStopRequested;
    IMessageCallback * mMsgCallback;


public:
    struct Message{
        Message(int arg, void * obj=0): mArg(arg), mObj(obj){}
        int mArg;
        void * mObj;
    };
    typedef shared_ptr<Message> MessagePtr;

    WorkerThread(IMessageCallback * msgCallback=0);

    virtual void run();
    void stop();
    WorkerTask::Ptr postTask(WorkerTask::Ptr task);
    WorkerTask::Ptr postMessage(int code, MessagePtr msg=MessagePtr());
};

class IMessageCallback{
friend class MessageTask;
protected:
    virtual void handleMessage(int code, WorkerThread::MessagePtr arg) = 0;
};


class MessageTask: public WorkerTask{
    IMessageCallback * mCallback;
    int mCode;
    WorkerThread::MessagePtr mArg;
protected:
    virtual void real_execute();
public:
    MessageTask(int messageCode, WorkerThread::MessagePtr arg, IMessageCallback *cb);
    virtual ~MessageTask(){}
};

class ForwardTask: public WorkerTask{
    shared_ptr<WorkerThread> mWorker;
    WorkerTask::Ptr mTask;
protected:
    virtual void real_execute();
public:
    ForwardTask(shared_ptr<WorkerThread> worker, WorkerTask::Ptr task);
    virtual ~ForwardTask(){}

};


}




#endif
