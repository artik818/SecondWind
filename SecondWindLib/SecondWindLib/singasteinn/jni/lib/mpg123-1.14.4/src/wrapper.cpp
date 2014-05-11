#include "su_eqx_singasteinn_MpegDecoder.h"
#include "mpg123.h"
#include "stdio.h"

static bool isInitialized = false;

#define PTR ((mpg123_handle*)ptr)

JNIEXPORT jlong JNICALL Java_su_eqx_singasteinn_MpegDecoder__1init
  (JNIEnv *, jclass){
    if (!isInitialized)
        mpg123_init();
    mpg123_handle * h = mpg123_new(0,0);
    mpg123_param(h, MPG123_FLAGS, MPG123_MONO_MIX, 0);
    mpg123_format(h, 44100, MPG123_MONO, MPG123_ENC_SIGNED_16);
    return (jlong)h;

}

JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_MpegDecoder__1getformat
  (JNIEnv *, jclass, jlong, jintArray){

}

JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_MpegDecoder__1delete
  (JNIEnv *, jclass, jlong ptr){
    mpg123_delete(PTR);
}

JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_MpegDecoder__1tell
  (JNIEnv *, jclass, jlong ptr){
    return mpg123_tell(PTR);
}

JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_MpegDecoder__1length
  (JNIEnv *, jclass, jlong ptr){
    return mpg123_length(PTR);
}

JNIEXPORT jstring JNICALL Java_su_eqx_singasteinn_MpegDecoder__1strerror
  (JNIEnv * env, jclass, jlong ptr){
    const char* txt = mpg123_strerror(PTR);
    jstring ret = env -> NewStringUTF(txt);
    return ret;
}

JNIEXPORT jstring JNICALL Java_su_eqx_singasteinn_MpegDecoder__1plain_1strerror
  (JNIEnv * env, jclass, jint err){
    const char* txt = mpg123_plain_strerror(err);
    jstring ret = env -> NewStringUTF(txt);
    return ret;
}

JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_MpegDecoder__1seek
  (JNIEnv *, jclass, jlong ptr, jint sample){
    return mpg123_seek(PTR, sample, SEEK_SET);
}


JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_MpegDecoder__1open
  (JNIEnv * env, jclass, jlong ptr, jstring fn){
    const char * str = env->GetStringUTFChars(fn, 0);
    int ret = mpg123_open((mpg123_handle *)ptr, str);
    env -> ReleaseStringUTFChars(fn, str);
    // TODO
    return ret;

}

JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_MpegDecoder__1close
  (JNIEnv *, jclass, jlong ptr){
    mpg123_delete((mpg123_handle*)ptr);
}

JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_MpegDecoder__1read
  (JNIEnv * env, jclass, jlong ptr, jintArray jbuf, jintArray jdone){

    int len = env->GetArrayLength(jbuf);
    short buf [len];
    int ibuf [len];

    size_t done;
    int adone[1];

    int res = mpg123_read(PTR, (unsigned char*)buf, len*2, &done);
    adone[0] = done;
    for (int i=0;i<len;i++){ibuf[i] = buf[i];}
    env->SetIntArrayRegion(jbuf, 0, len, ibuf);
    env->SetIntArrayRegion(jdone, 0, 1, adone);

    return res;
}


