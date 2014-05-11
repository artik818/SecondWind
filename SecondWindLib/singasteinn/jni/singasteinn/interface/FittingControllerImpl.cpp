#include "FittingControllerImpl.h"
#include "../SingasteinnEngine.h"
#include "../SongStream.h"
#include "../logging.h"
#include "SensorHandler.h"


using namespace singasteinn;

LOGGER("FittingController");

FittingControllerImpl::FittingControllerImpl(SingasteinnEngine *engine):
    mEngine(engine),
    mConstStepsInterval(-1),
    mFittingMode(FM_None)
{

}


void FittingControllerImpl::setConstBeatInterval(float sec){
    LOGW("setConstInterval stub");
    mConstStepsInterval = sec;
}

void FittingControllerImpl::setFittingMode(FittingMode m){
    LOGW("setFittingMode stub");
    switch (m) {
    case FM_ConstTempoFit:
        mEngine->getSensorHandler()->setOverrideStepsInterval(mConstStepsInterval);
        break;
    case FM_Simple:
        mEngine->getSensorHandler()->setOverrideStepsInterval(-1);
        break;
    default:
        LOGEF("Fitting mode %d is not implemented yet", m);
    }
    mFittingMode = m;
}

IFittingController::FittingMode FittingControllerImpl::getFittingMode(){
    return mEngine->getSensorHandler()->getOverrideStepsInterval() > 0?FM_ConstTempoFit:FM_Simple;
}

float FittingControllerImpl::getCurrentStepInterval(){
    return mEngine->getSensorHandler()->computeStepsInterval();
}

float FittingControllerImpl::getCurrentBeatInterval(){
    return -1; // not implemented yet
}

void FittingControllerImpl::apply(shared_ptr<SongStream> stream){
//    s
}
