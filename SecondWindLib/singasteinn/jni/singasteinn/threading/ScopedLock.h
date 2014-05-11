#ifndef SINGASTEINN_SCOPEDLOCK
#define SINGASTEINN_SCOPEDLOCK
#include <pthread.h>

namespace singasteinn{

class ScopedLock{
    pthread_mutex_t * mMutex;
public:
    ScopedLock(pthread_mutex_t * mutex);
    ~ScopedLock();

};
}


#endif
