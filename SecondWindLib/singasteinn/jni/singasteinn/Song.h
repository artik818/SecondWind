#ifndef SONG_H
#define SONG_H

#include "analysis/SongAnalyzer.h"
#include "TempoScaler.h"
#include <string>
#include "SmartPtr.h"
#include "ITempoStorage.h"

namespace singasteinn{
class Song{
    SongAnalyzer::Result * mTempoData;
    std::string mUrl;

public:
    typedef shared_ptr<Song> Ptr;
    struct Metadata{
        std::string mTitle, mArtist;
        int mTrackNo;
    };

    Song(std::string url);
    virtual ~Song();

    bool readTempoData(ITempoStorage * storage);
    void saveTempoData(ITempoStorage * storage);
    void generateTempoData();


    ISoundSource * openStream();
    virtual Metadata getMetadata();

    const std::string &getUrl() const {return mUrl;}
    const SongAnalyzer::Result * getTempoData() const{
        return mTempoData;
    }


};
}


#endif
