#include "ScopedLock.h"
#include <pthread.h>

using namespace singasteinn;

ScopedLock::ScopedLock(pthread_mutex_t *mutex):
    mMutex(mutex)
{
    pthread_mutex_lock(mMutex);
}

ScopedLock::~ScopedLock(){
    pthread_mutex_unlock(mMutex);
}
