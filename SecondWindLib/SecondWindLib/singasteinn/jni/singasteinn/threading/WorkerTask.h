#ifndef SINGASTEINN_WORKERTASK
#define SINGASTEINN_WORKERTASK
#include "../SmartPtr.h"
#include <pthread.h>


namespace singasteinn{

    class WorkerTask{
        bool mDone;
        pthread_mutex_t mMutex;
        pthread_cond_t mCond;
        pthread_mutex_t mCallbackMutex;
    protected:
        virtual void real_execute() = 0;

    public:
        typedef shared_ptr<WorkerTask> Ptr;
        WorkerTask();
        virtual ~WorkerTask(){}
        virtual void execute();
        virtual bool isDuplicateOf(const WorkerTask & other) const;
        void wait();
        bool isDone();
    };
}


#endif
