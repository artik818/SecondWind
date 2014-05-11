#ifndef SONGSTREAM_H
#define SONGSTREAM_H

#include "ISoundStream.h"
#include "TempoScaler.h"
#include "ISensorSource.h"
#include "Song.h"

namespace singasteinn{

class SongStream: public ISoundSource{
    ISoundSource * mSource;
    TempoScaler mScaler;
    Song::Ptr mSong;

    void updateTempo();
public:
    SongStream(Song::Ptr song);
    virtual int getSampleRate();
    virtual int read(SampleType *buf, int len);
    virtual bool isEOF();
};
}




#endif
