#ifndef DUMMYUI_H
#define DUMMYUI_H
#include "IUI.h"
#include "SingasteinnEngine.h"
#include "analysis/SongAnalysisService.h"

class DummyUI: public IUI{
    singasteinn::SingasteinnEngine mEngine;
public:
    DummyUI();
    virtual ~DummyUI();

    void main();
    void loadAnalysisQueue();
    void onCurrentTrackChanged();
    void onPlaybackStateChanged();
    virtual void onSongAnalysisFinished(singasteinn::Song::Ptr mSong);
};

#endif
