//
//  AppleAccelerometer.cpp
//  singasteinn
//
//  Created by Во on 23.11.2013.
//
//

#include "AppleAccelerometer.h"
#import "AppleAccelerometerImpl.h"

void * appleAccelCreate(void *cli){
    return (void*) [[AppleAccelerometerImpl alloc]initWithSampleRate:20 andListener:cli];
}

void appleAccelDestroy(void * ptr){
    // ARC?
}

