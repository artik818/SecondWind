#ifndef SIMPLE_PLAYLIST_ITERATOR_H
#define SIMPLE_PLAYLIST_ITERATOR_H
#include "interface/IPlaybackController.h"
#include "SingasteinnEngine.h"

using singasteinn::Song;

class SimplePlaylistIterator: public singasteinn::IPlaybackCallback{
    singasteinn::SingasteinnEngine * mEng;
    singasteinn::IPlaybackController * mController;
    std::vector<Song::Ptr> mPlaylist;
    int mCurrentTrackIndex;
public:
    SimplePlaylistIterator(singasteinn::SingasteinnEngine * eng);

    void loadDirectory(std::string path);

    virtual void onTrackEnd();
    virtual void onPlaybackStateChanged(singasteinn::IPlaybackController::PlaybackState);



};


#endif //SIMPLE_PLAYLIST_ITERATOR_H
