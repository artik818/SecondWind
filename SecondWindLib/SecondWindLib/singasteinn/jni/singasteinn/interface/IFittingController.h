#ifndef IFITTINGCONTROLLER
#define IFITTINGCONTROLLER

namespace singasteinn{

/**
 * @brief Interface to control fitting algorythm
 * Both steps beat intervals are measured in seconds
 *
 */
class IFittingController{

public:

    /**
     * @brief The FittingMode enum
     * Fitting modes are TBD, for now there only three of them:
     * Const - speedup/slowdown the song so BPM is constant
     * Simple - try to synchronize song beat with steps interval
     * None - just play without altering the song tempo
     */
    enum FittingMode{
        FM_ConstTempoFit,
        FM_Simple,
        FM_ConstSpeedup,
        FM_None
    };

    /**
     * Sets beat interval for Constant Beat mode
     * @param sec
     *  the interval
     */
    virtual void setConstBeatInterval(float sec) = 0;

    /**
     * @return current steps interval or -1 in case of error
     */
    virtual float getCurrentStepInterval() = 0;

    /**
     * @return current beat interval if available or -1 in case of song is not playing or no beat detected
     */
    virtual float getCurrentBeatInterval() = 0;

    virtual void setFittingMode(FittingMode m) = 0;
    virtual FittingMode getFittingMode() = 0;

};

}



#endif
