//
//  AppleAccelerometer.h
//  singasteinn
//
//  Created by Во on 23.11.2013.
//
//

#ifndef __singasteinn__AppleAccelerometer__
#define __singasteinn__AppleAccelerometer__
#include "ISensorSource.h"

extern void * appleAccelCreate(void *cli);
extern void appleAccelDestroy(void * ptr);


class AppleAccelerometer: public ISensorSource{
    void * mImpl;
public:
    AppleAccelerometer(ISensorClient*cli){
        mImpl = appleAccelCreate(cli);
    }
    virtual ~AppleAccelerometer(){
        appleAccelDestroy(mImpl);
    }
};

#endif /* defined(__singasteinn__AppleAccelerometer__) */
