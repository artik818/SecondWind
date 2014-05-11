#include "SimplePlaylistIterator.h"
#include "logging.h"
#include <stdio.h>
#include <dirent.h>
#include "analysis/SongAnalysisService.h"

LOGGER("SimplePlaylistIterator");

SimplePlaylistIterator::SimplePlaylistIterator(singasteinn::SingasteinnEngine *eng):
    mEng(eng),
    mController(eng->getPlaybackController())
{

}


void SimplePlaylistIterator::loadDirectory(std::string path){
    mCurrentTrackIndex = 0;
    DIR * dir = opendir(path.c_str());
    assert(dir);
    struct dirent * entry;
    singasteinn::SongAnalysisService sa;
    while ((entry = readdir(dir))){
        std::string fn = std::string(entry->d_name, entry->d_namlen);
        if (entry->d_namlen > 4 && fn.substr(entry->d_namlen - 4) == ".mp3"){
            LOGIF("Adding song %s", fn.c_str());
            Song::Ptr song(new Song("file://" + path + "/" + fn));
            mPlaylist.push_back(song);
            sa.processSongSync(song);

        } else {
            LOGIF("Skipping entry '%s'", fn.c_str());
        }
    }
    assert(mPlaylist.size());
    mController->switchToSong(mPlaylist[0]);
    mController->setPlaybackState(singasteinn::IPlaybackController::PS_Playing);
}

void SimplePlaylistIterator::onPlaybackStateChanged(singasteinn::IPlaybackController::PlaybackState st){
    LOGIF("Playback state changed to %d", st);
}

void SimplePlaylistIterator::onTrackEnd(){
    assert(mPlaylist.size());
    mCurrentTrackIndex = (mCurrentTrackIndex + 1) % mPlaylist.size();
    mEng->getPlaybackController()->switchToSong(mPlaylist[mCurrentTrackIndex]);
}
