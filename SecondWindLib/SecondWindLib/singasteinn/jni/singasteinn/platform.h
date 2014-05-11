#ifdef ANDROID
#include "AndroidSensorSource.h"
#include "output/SlesStreamPlayer.h"
#include "MpegDecoder.h"
typedef AndroidSensorSource PlatformSensorSource;
typedef SlesStreamPlayer PlatformStreamPlayer;
typedef MpegDecoder PlatformUrlDecoder;
#else // ANDROID
#include "output/OpenALStreamPlayer.h"
#include "FakeSensorSource.h"
#include "AppleDecoder.h"
#include "output/WAvStreamWriter.h"
#include "MpegDecoder.h"
typedef FakeSensorSource PlatformSensorSource;
typedef OpenALStreamPlayer PlatformStreamPlayer;
//typedef WavStreamWriter PlatformStreamPlayer;
typedef MpegDecoder PlatformUrlDecoder;
//typedef AppleDecoder PlatformUrlDecoder;

#endif // ANDROID
