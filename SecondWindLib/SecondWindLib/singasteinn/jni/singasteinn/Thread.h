#ifndef THREAD_H
#define THREAD_H
#include <pthread.h>


class Thread{
    pthread_t mThread;
    static void * threadMain(void*);
    bool mAutodelete;
    bool mStarted;
public:
    Thread();
    virtual ~Thread(){}
    virtual void run() = 0;
    void start();
    void join();
    bool isStarted();
};


#endif
