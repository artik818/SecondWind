include $(CLEAR_VARS)
LOCAL_MODULE    := libmpg123
LOCAL_ARM_MODE  := arm
LOCAL_CFLAGS    := -O2 -Wall -DOPT_ARM -DREAL_IS_FIXED \
	-DHAVE_CONFIG_H -I. -I../../src -I../../src -DPIC \
	-funroll-all-loops -finline-functions -ffast-math
LOCAL_LDLIBS := -llog

LOCAL_SRC_FILES = \
   lib/mpg123-1.14.4/src/libmpg123/libmpg123.c \
   lib/mpg123-1.14.4/src/libmpg123/compat.c \
   lib/mpg123-1.14.4/src/libmpg123/dct64.c \
   lib/mpg123-1.14.4/src/libmpg123/equalizer.c \
   lib/mpg123-1.14.4/src/libmpg123/feature.c \
   lib/mpg123-1.14.4/src/libmpg123/format.c \
   lib/mpg123-1.14.4/src/libmpg123/frame.c \
   lib/mpg123-1.14.4/src/libmpg123/icy.c \
   lib/mpg123-1.14.4/src/libmpg123/icy2utf8.c \
   lib/mpg123-1.14.4/src/libmpg123/id3.c \
   lib/mpg123-1.14.4/src/libmpg123/index.c \
   lib/mpg123-1.14.4/src/libmpg123/layer1.c \
   lib/mpg123-1.14.4/src/libmpg123/layer2.c \
   lib/mpg123-1.14.4/src/libmpg123/layer3.c \
   lib/mpg123-1.14.4/src/libmpg123/lfs_alias.c \
   lib/mpg123-1.14.4/src/libmpg123/ntom.c \
   lib/mpg123-1.14.4/src/libmpg123/optimize.c \
   lib/mpg123-1.14.4/src/libmpg123/parse.c \
   lib/mpg123-1.14.4/src/libmpg123/readers.c \
   lib/mpg123-1.14.4/src/libmpg123/tabinit.c \
   lib/mpg123-1.14.4/src/libmpg123/stringbuf.c \
   lib/mpg123-1.14.4/src/libmpg123/synth.c \
   lib/mpg123-1.14.4/src/libmpg123/wrapper.cpp \
   lib/mpg123-1.14.4/src/libmpg123/synth_8bit.c \
   lib/mpg123-1.14.4/src/libmpg123/synth_arm.S

include $(BUILD_SHARED_LIBRARY)
