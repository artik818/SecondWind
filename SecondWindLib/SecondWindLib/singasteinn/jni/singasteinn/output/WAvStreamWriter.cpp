#include "WAvStreamWriter.h"
#include <stdio.h>
#include <sys/types.h>
#include "../logging.h"
#include <log4cplus/loglevel.h>
#include <log4cplus/loggingmacros.h>

using namespace singasteinn;

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.Engine");

static const int MSG_OPEN_FILE = 1;
static const int MSG_WRITE_CHUNK = 2;

WavStreamWriter::WavStreamWriter():
    f(0),
    mSoundSource(0),
    mWorker(this)
{
    mBufferLen = 102400;
//    LOG4CPLUS_INFO_FMT(logger, "opening file '%s'", path.c_str());
    mBuffer = new ISoundSource::SampleType[mBufferLen];
    mWorker.start();
}

struct Fmt{
    int32_t subchunk_size;
    int16_t audio_format;
    int16_t num_channels;
    int32_t sample_rate;
    int32_t byte_rate;
    int16_t block_align;
    int16_t bits_per_sample;
};

void WavStreamWriter::setOutput(std::string path){
    mOutFileName = path;
    mWorker.postMessage(MSG_OPEN_FILE);
}

void WavStreamWriter::closeOutput(){
    assert(f);
    fclose(f);
}

void WavStreamWriter::writeHeader(){
    assert(f);
    fwrite("RIFF", 1, 4, f);
    fwrite("\xff\xff\xff\xff", 1, 4, f);
    fwrite("WAVE", 1, 4, f);
    // header chunk

    fwrite("fmt ", 1, 4, f);
//    fwrite("\x10\x00\x00\x00", 1, 4, f);

    Fmt fmt;
    fmt.subchunk_size = 16;
    fmt.audio_format = 1;
    fmt.num_channels = 1;
    fmt.sample_rate = 44100;
    fmt.byte_rate = fmt.sample_rate * sizeof(ISoundSource::SampleType);
    fmt.block_align = 4;
    fmt.bits_per_sample = 16;

    fwrite(&fmt, sizeof(Fmt), 1, f);
    // data

    fwrite("data", 4, 1, f);
    fwrite("\xff\xff\xff\xff", 1, 4, f);

}

void WavStreamWriter::handleMessage(int code, WorkerThread::MessagePtr arg){
    switch(code){
    case MSG_OPEN_FILE:
        if (f)
            closeOutput();
        f = fopen(mOutFileName.c_str(), "w");
        writeHeader();
        break;
    case MSG_WRITE_CHUNK:
        assert(f);
        int cnt = 0;
        cnt = mSoundSource->read(mBuffer, mBufferLen);
        if (!cnt && mSoundSource->isEOF()){
            LOGW("source EOF, closing output");
            closeOutput();
            return;
        }
        fwrite(mBuffer, cnt * sizeof(ISoundSource::SampleType), 1, f);
        mWorker.postMessage(MSG_WRITE_CHUNK);
    }
}

void WavStreamWriter::setSource(ISoundSource *src){
    mSoundSource = src;
    mWorker.postMessage(MSG_WRITE_CHUNK);

}
