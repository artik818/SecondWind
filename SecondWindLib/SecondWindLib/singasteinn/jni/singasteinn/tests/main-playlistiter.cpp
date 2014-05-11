#include "SingasteinnEngine.h"
#include "SimplePlaylistIterator.h"
#include "interface/IFittingController.h"
#include <unistd.h>
int main(int argc, char ** argv){
    singasteinn::SingasteinnEngine::initializeLogging();
    singasteinn::SingasteinnEngine eng("cache");
    SimplePlaylistIterator plIt(&eng);
    plIt.loadDirectory(argv[1]);
    eng.getPlaybackController()->setCallback(&plIt);
    eng.getFittingController()->setFittingMode(singasteinn::IFittingController::FM_ConstTempoFit);
    eng.getFittingController()->setConstBeatInterval(0.4);
    sleep(1000);

}
