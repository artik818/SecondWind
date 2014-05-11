include $(CLEAR_VARS)
LOCAL_MODULE    := libmpg123
LOCAL_ARM_MODE  := arm
LOCAL_CFLAGS    := -O2 -Wall
LOCAL_LDLIBS := -llog

LOCAL_SRC_FILES = \
                 lib/mpg123/equalizer.c \
				 lib/mpg123/index.c \
				 lib/mpg123/layer2.c \
				 lib/mpg123/synth.c \
				 lib/mpg123/dct64.c \
				 lib/mpg123/format.c \
				 lib/mpg123/layer3.c \
				 lib/mpg123/ntom.c \
				 lib/mpg123/parse.c \
				 lib/mpg123/readers.c \
				 lib/mpg123/frame.c \
				 lib/mpg123/layer1.c \
				 lib/mpg123/libmpg123.c \
				 lib/mpg123/optimize.c \
				 lib/mpg123/synth_arm.S \
				 lib/mpg123/tabinit.c \
                                 lib/mpg123/id3.c \
                                 lib/mpg123/wrapper.cpp

include $(BUILD_SHARED_LIBRARY)
