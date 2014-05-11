#ifndef SINGASTEINN_JNI
#define SINGASTEINN_JNI
#include <jni.h>

extern "C"{
JNIEXPORT jlong JNICALL Java_su_eqx_accellogger_NativeLogger_startLog
  (JNIEnv *, jclass cls, jstring path);
JNIEXPORT void JNICALL Java_su_eqx_accellogger_NativeLogger_stopLog
  (JNIEnv *, jclass cls, jlong ptr);

}

#endif
