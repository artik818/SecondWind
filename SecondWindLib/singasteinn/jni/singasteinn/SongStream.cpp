#include "SongStream.h"
#include "TempoScaler.h"
#include "SensorHandler.h"

#include "log4cplus/logger.h"
#include "log4cplus/loggingmacros.h"

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.SongStream");
using namespace singasteinn;

SongStream::SongStream(Song::Ptr song):
    mSong(song),
    mSource(song->openStream()),
    mScaler(new TempoScaler(mSource))
{
    mScaler.setTempo(1);
}

int SongStream::getSampleRate(){
    return mScaler.getSampleRate();
}

int SongStream::read(SampleType *buf, int len){
    updateTempo();
    return mScaler.read(buf, len);
}

bool SongStream::isEOF(){
    return mScaler.isEOF();
}

void SongStream::updateTempo(){
    float songTempo = mSong->getTempoData()->get(dynamic_cast<ISeekable *>(mSource)->tellSec());
    float stepsInterval = SensorHandler::getInstance()->computeStepsInterval();
    float tempo = 1;
    if (stepsInterval > 0 && songTempo > 0)
        tempo = songTempo / stepsInterval;

    LOG4CPLUS_DEBUG_FMT(logger, "Beat interval: %.3f, steps interval: %.3f, tempo: %.3f, pos: %.3f", songTempo, stepsInterval, tempo, dynamic_cast<ISeekable *>(mSource)->tellSec());
    mScaler.setTempo(tempo);
}
