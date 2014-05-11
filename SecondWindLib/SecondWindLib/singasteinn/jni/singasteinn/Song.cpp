#include "Song.h"
#include "SensorHandler.h"

#include <log4cplus/loglevel.h>
#include <log4cplus/loggingmacros.h>
#include "platform.h"

static log4cplus::Logger logger = log4cplus::Logger::getInstance("singasteinn.Song");

using namespace singasteinn;

Song::Song(std::string path):
    mUrl(path),
    mTempoData(0)
{

}

Song::~Song(){
    LOG4CPLUS_ERROR(logger, "song destructor");
}

bool Song::readTempoData(ITempoStorage *storage){
    if (!storage){
        LOG4CPLUS_WARN(logger, "Tempo storage unavailable. Unable to read tempo.");
        return false;
    }

    if (mTempoData)
        delete mTempoData;
    mTempoData = storage->read(mUrl);
    return mTempoData;
}

void Song::saveTempoData(ITempoStorage *storage){
    if (!storage){
        LOG4CPLUS_WARN(logger, "Tempo storage unavailable. Unable to save tempo.");
        return;
    }
    if (mTempoData)
        storage->save(mUrl, *mTempoData);
}

void Song::generateTempoData(){
    if (mTempoData)
        return;
    ISoundSource * stream = openStream();
    ISongAnalyzer * sa = new SongAnalyzer(stream);
    if (mTempoData)
        delete mTempoData;
    mTempoData = new SongAnalyzer::Result(sa->analyze());
    delete sa;
    delete stream;
}

ISoundSource * Song::openStream(){
    // TODO platform-dependent decoders
    PlatformUrlDecoder* decoder = new PlatformUrlDecoder();
    decoder->open(mUrl);
    return decoder;
}

Song::Metadata Song::getMetadata(){
    Metadata m;
    m.mArtist = "Unknown";
    m.mTitle = mUrl;
    return m;
}
