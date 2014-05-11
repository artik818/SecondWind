#ifndef RINGBUFFER_H
#define RINGBUFFER_H
#include <pthread.h>
#include <stdio.h>
#include <assert.h>
#include <memory.h>

template<typename SampleType>
class RingBuffer{
    SampleType * mBuffer;
    pthread_mutex_t mMutex;
    int mLen;
    int mCurrPos;
public:
    RingBuffer(int len):
        mLen(len),
        mCurrPos(0)
    {
        pthread_mutex_init(&mMutex, 0);
        mBuffer = new SampleType[len];
    }

    virtual ~RingBuffer(){
        delete[] mBuffer;
    }

    void feed(SampleType val){
        pthread_mutex_lock(&mMutex);
        mBuffer[mCurrPos] = val;
        mCurrPos++;
        mCurrPos %= mLen;
        assert(mCurrPos < mLen);
        pthread_mutex_unlock(&mMutex);
    }
    void readLast(SampleType *buf, int len){
        pthread_mutex_lock(&mMutex);
        int tailLen, headLen;
        if (len <= mCurrPos){
            tailLen = len;
            //headLen = 0;
        } else {
            tailLen = mCurrPos;
            //headLen = len - mCurrPos;
        }
        headLen = len - tailLen;
        {
            int srcStart = mCurrPos - tailLen;
            assert(srcStart >= 0);
            assert(headLen + tailLen <= len);
            assert(srcStart + tailLen <= mLen);
            memcpy(buf + headLen, mBuffer + (mCurrPos - tailLen), tailLen * sizeof(SampleType));
        }
        if (headLen){
            int srcStart = mLen - headLen;
            assert(srcStart >= 0);
            assert(headLen <= len);
            assert(srcStart + headLen <= mLen);
            memcpy(buf, mBuffer + (mLen - headLen), headLen * sizeof(SampleType));
        }

        pthread_mutex_unlock(&mMutex);

    }

};

#endif
