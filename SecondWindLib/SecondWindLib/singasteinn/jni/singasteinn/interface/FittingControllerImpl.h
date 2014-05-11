#ifndef FITTINGCONTROLLERIMPL_H
#define FITTINGCONTROLLERIMPL_H

#include "IFittingController.h"
#include "SmartPtr.h"
#include "SongStream.h"

namespace singasteinn{
class SingasteinnEngine;
class FittingControllerImpl: public IFittingController{
    SingasteinnEngine * mEngine;
    float mConstStepsInterval;
    FittingMode mFittingMode;
public:
    FittingControllerImpl(SingasteinnEngine * engine);

    virtual void setConstBeatInterval(float sec);
    virtual float getCurrentStepInterval();
    virtual float getCurrentBeatInterval();
    virtual void setFittingMode(FittingMode m);
    virtual FittingMode getFittingMode();

    void apply(shared_ptr<SongStream> stream);

};

}



#endif
