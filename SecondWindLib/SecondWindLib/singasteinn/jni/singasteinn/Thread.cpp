#include "Thread.h"

#include <log4cplus/logger.h>
#include <log4cplus/loglevel.h>
#include <log4cplus/loggingmacros.h>

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.Thread");

void *Thread::threadMain(void *ptr){
    Thread * t = static_cast<Thread*>(ptr);
    t->run();
    LOG4CPLUS_DEBUG_FMT(logger, "Thread %d exitted", t->mThread);
    if (t->mAutodelete)
        delete t;
}

Thread::Thread():
    mAutodelete(false),
    mStarted(0)
{
}

void Thread::start(){
    assert(!mStarted); // Thread shouldn't be started twice
    pthread_create(&mThread, 0, threadMain, this);
    mStarted = true;
//    LOG4CPLUS_DEBUG_FMT(logger, "Thread started: %d", mThread);
}

void Thread::join(){
//    LOG4CPLUS_DEBUG_FMT(logger, "Joining thread %d", mThread);
    pthread_join(mThread, 0);
}

bool Thread::isStarted(){
    return mStarted;
}
