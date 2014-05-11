cmake_minimum_required(VERSION 2.8)
project(singasteinn)

set(SS_LINK_TYPE, "SHARED")

if (IOS)
    set(SS_LINK_TYPE, "STATIC")
endif()

add_library(soundtouch ${SS_LINK_TYPE}
			jni/lib/soundtouch/AAFilter.cpp
            jni/lib/soundtouch/BPMDetect.cpp
            jni/lib/soundtouch/FIFOSampleBuffer.cpp
            jni/lib/soundtouch/FIRFilter.cpp
            jni/lib/soundtouch/PeakFinder.cpp
            jni/lib/soundtouch/RateTransposer.cpp
            jni/lib/soundtouch/SoundTouch.cpp
            jni/lib/soundtouch/TDStretch.cpp
            jni/lib/soundtouch/mmx_optimized.cpp
)


include_directories(jni/lib/soundtouch)
include_directories(jni/lib/mpg123-1.14.4/src/libmpg123)
include_directories(jni/lib/mpg123-1.14.4/src)
include_directories(jni/lib/log4cplus-1.1.1/include)
include_directories(${CMAKE_BINARY_DIR}/jni/lib/log4cplus-1.1.1/include)
include_directories(jni/singasteinn)

if (IOS)
set(LOG4CPLUS_HAVE_ERRNO_H yes BOOL)
set (LOG4CPLUS_HAVE_C99_VARIADIC_MACROS yes BOOL)
set (LOG4CPLUS_HAVE_SYS_TYPES_H yes BOOL)
set (LOG4CPLUS_HAVE_SYS_FILE_H yes BOOL)
set (LOG4CPLUS_HAVE_SYS_SOCKET_H yes BOOL)
set (LOG4CPLUS_HAVE_NETINET_IN_H yes BOOL)
set (LOG4CPLUS_HAVE_NETINET_TCP_H yes BOOL)
set (LOG4CPLUS_HAVE_ARPA_INET_H yes BOOL)
set (LOG4CPLUS_HAVE_NETDB_H yes BOOL)
set (LOG4CPLUS_HAVE_FCNTL_H yes BOOL)
set (LOG4CPLUS_HAVE_POLL_H yes BOOL)
set (LOG4CPLUS_HAVE_PIPE yes BOOL)
set (LOG4CPLUS_HAVE_FTIME yes BOOL)
set (LOG4CPLUS_HAVE_SYS_TIMEB_H yes BOOL)
set (LOG4CPLUS_HAVE_POLL_H yes BOOL)
set (LOG4CPLUS_HAVE_POLL_H yes BOOL)
set (LOG4CPLUS_HAVE_POLL_H yes BOOL)
set (LOG4CPLUS_HAVE_SYS_LOCKING_H yes BOOL)
set (LOG4CPLUS_HAVE_UNISTD_H yes BOOL)
set (LOG4CPLUS_HAVE_NANOSLEEP yes BOOL)
set (LOG4CPLUS_HAVE_SYS_STAT_H yes BOOL)
set (LOG4CPLUS_HAVE_FLOCK yes BOOL)
endif(IOS)

add_subdirectory(jni/lib/log4cplus-1.1.1)
add_subdirectory(jni/lib/mpg123-1.14.4/src/libmpg123)

if (ANDROID)
    set(EXTRA_SRC
        jni/singasteinn/output/SlesStreamPlayer.cpp
        jni/singasteinn/AndroidSensorSource.cpp
        jni/singasteinn/LogcatAppender.cpp
        jni/singasteinn/jni/jni_wrapper.cpp
        jni/singasteinn/MpegDecoder.cpp
        jni/NativeScaler.cpp
    )
    set(PLATFORM_LIBS OpenSLES android log mpg123)
else()
    find_package(OpenAl)
    set(EXTRA_SRC
        jni/singasteinn/MpegDecoder.cpp
        jni/singasteinn/output/OpenALStreamPlayer.cpp
        jni/singasteinn/output/WAvStreamWriter.cpp
#        jni/singasteinn/PySongAnalyzer.cpp
        jni/singasteinn/AppleDecoderImpl.m
        jni/singasteinn/AppleDecoder.mm

        # TODO exclude from macos build
        #jni/singasteinn/AppleAccelerometer.mm
        #jni/singasteinn/AppleAccelerometerImpl.mm
    )
    set(ANDROID_LIBRARY "")

    #exec_program(python3.2-config ARGS --includes OUTPUT_VARIABLE PYTHON_INC)
    #string(REPLACE "-I" "" PYTHON_INC ${PYTHON_INC})
    #exec_program(python3.2-config ARGS --ldflags OUTPUT_VARIABLE PYTHON_LDFLAGS)

    find_library(AV_LIBS AVFoundation)
    find_library(CM_LIBS CoreMedia)
    if(IOS)
        find_library(CMo_LIBS CoreMotion)
    else()
        set(CMo_LIBS, "")
    endif()
    find_library(F_LIBS Foundation)
    set(PLATFORM_LIBS 
        ${OPENAL_LIBRARY} 
        ${AV_LIBS} 
        ${CM_LIBS} 
        ${F_LIBS}
        ${CMo_LIBS}
    )
    #set(CMAKE_SHARED_LINKER_FLAGS ${PYTHON_LDFLAGS})
endif()


add_library(singasteinn ${SS_LINK_TYPE} 
    jni/singasteinn/interface/PlaybackControllerImpl.cpp
    jni/singasteinn/interface/FittingControllerImpl.cpp
    jni/singasteinn/threading/ScopedLock.cpp
    jni/singasteinn/threading/WorkerTask.cpp
    jni/singasteinn/threading/WorkerThread.cpp
    jni/singasteinn/ConfigParser.cpp
    jni/singasteinn/DummyUi.cpp
    jni/singasteinn/analysis/SongAnalyzer.cpp
    jni/singasteinn/analysis/SongAnalysisService.cpp
    jni/singasteinn/TempoScaler.cpp
    jni/singasteinn/SensorHandler.cpp
    jni/singasteinn/SimpleMixer.cpp
    jni/singasteinn/FakeSensorSource.cpp
    jni/singasteinn/SingasteinnEngine.cpp
    jni/singasteinn/Song.cpp
    jni/singasteinn/Thread.cpp
    jni/singasteinn/SongStream.cpp
    jni/singasteinn/SensorLogger.cpp
    jni/singasteinn/SimpleTempoStorage.cpp
    jni/singasteinn/fft/kiss_fft.c
    ${EXTRA_SRC}
)



add_executable(singasteinn-bin
    jni/singasteinn/main.cpp
    )

add_executable(ssn-test-playlistiter
    jni/singasteinn/tests/SimplePlaylistIterator.cpp
    jni/singasteinn/tests/main-playlistiter.cpp
)

add_definitions(-ggdb)
target_link_libraries( singasteinn 
    mpg123
    ${PLATFORM_LIBS} 
    ${ANDROID_LIBRARY} 
    log4cplus 
    soundtouch 
    )
target_link_libraries( singasteinn-bin
    singasteinn
    )
target_link_libraries( ssn-test-playlistiter
    singasteinn
    )
