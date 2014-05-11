#include "NativeScaler.h"
#include <SoundTouch.h>
#include <jni.h>

using soundtouch::SoundTouch;
// FIXME don't as as singleton!
soundtouch::SAMPLETYPE *buf;



JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_NativeScaler_receiveSamples
  (JNIEnv * env, jobject, jlong ptr, jintArray buffer){
    SoundTouch *stouch = (SoundTouch*)ptr;
  int len = env->GetArrayLength(buffer);
  //soundtouch::SAMPLETYPE * buf = new soundtouch::SAMPLETYPE[len];
  jint * inp = env->GetIntArrayElements(buffer, 0);
  int outCount = stouch -> receiveSamples(buf, len);
  for (int i = 0;i<len;i++){
    inp[i] = buf[i];
  }
  env -> ReleaseIntArrayElements(buffer, inp, 0);
  //delete[] buf;
  return outCount;
  
}

JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_NativeScaler_availableSamples
  (JNIEnv *, jobject, jlong ptr){
    SoundTouch *stouch = (SoundTouch*)ptr;
  return stouch->numSamples();

}


JNIEXPORT jint JNICALL Java_su_eqx_singasteinn_NativeScaler_putSamples
  (JNIEnv *env, jobject, jlong ptr, jintArray buffer){
    SoundTouch *stouch = (SoundTouch*)ptr;
  int len = env->GetArrayLength(buffer);
  soundtouch::SAMPLETYPE * buf = new soundtouch::SAMPLETYPE[len];
  jint * inp = env->GetIntArrayElements(buffer, 0);
  for (int i = 0;i<len;i++){
    buf[i] = inp[i];
  }
  stouch -> putSamples(buf, len);
  env -> ReleaseIntArrayElements(buffer, inp, 0);
  //delete[] buf;
  return 0;
}

JNIEXPORT jlong JNICALL Java_su_eqx_singasteinn_NativeScaler_init
    (JNIEnv *, jobject, jint channels, jint sampleRate){
    SoundTouch *stouch;

    stouch = new soundtouch::SoundTouch();
    stouch->setTempo(1);
    stouch->setChannels(channels);
    stouch->setSampleRate(sampleRate);

    stouch->setSetting(SETTING_USE_QUICKSEEK, 1);
    buf = new soundtouch::SAMPLETYPE[1024*1024];
    return (jlong)stouch;

  
};

JNIEXPORT void JNICALL Java_su_eqx_singasteinn_NativeScaler_setRate
  (JNIEnv *, jobject, jlong ptr, jfloat val){
    SoundTouch *stouch = (SoundTouch*)ptr;
  stouch -> setTempo(val);
}

JNIEXPORT void JNICALL Java_su_eqx_singasteinn_NativeScaler_delete
  (JNIEnv *, jobject, jlong ptr){
    SoundTouch *stouch = (SoundTouch*)ptr;
    delete stouch;
}
