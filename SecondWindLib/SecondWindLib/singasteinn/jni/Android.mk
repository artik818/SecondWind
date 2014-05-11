LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := singasteinn
LOCAL_C_INCLUDES  := $(LOCAL_PATH)/lib/soundtouch
LOCAL_SRC_FILES :=  \
			lib/soundtouch/AAFilter.cpp \
			lib/soundtouch/BPMDetect.cpp \
			lib/soundtouch/FIFOSampleBuffer.cpp \
			lib/soundtouch/FIRFilter.cpp \
			lib/soundtouch/PeakFinder.cpp \
			lib/soundtouch/RateTransposer.cpp \
			lib/soundtouch/SoundTouch.cpp \
			lib/soundtouch/TDStretch.cpp \
                        NativeScaler.cpp

LOCAL_CFLAGS=-I/home/vvs/work/android/android-ndk-r8/sources/cxx-stl/gnu-libstdc++/include  \
    -I lib/soundtouch/ \
    -I jni/lib/soundtouch/include \
    -iquote jni/lib/soundtouch/include \
    -frtti \
    -Wall
LOCAL_LDLIBS := -llog
include $(BUILD_SHARED_LIBRARY)
include $(LOCAL_PATH)/lib/mpg123-1.14.4/src/libmpg123/Android.mk
