//
//  AppleAccelerometerImpl.m
//  singasteinn
//
//  Created by Во on 23.11.2013.
//
//

#import "AppleAccelerometerImpl.h"
#include "ISensorSource.h"

@implementation AppleAccelerometerImpl

-(id) initWithSampleRate:(int)samplesIntervalMs andListener:(void *)listener{
    mListener = listener;
    mMotionManager = [[CMMotionManager alloc]init];
    mOperationQueue = [[NSOperationQueue alloc]init];
    [mMotionManager setAccelerometerUpdateInterval:((float)samplesIntervalMs)/1000];
    [mMotionManager startAccelerometerUpdatesToQueue:mOperationQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self accelerometerCallback:accelerometerData];
        assert(error == nil);
    }];
    return self;
}

-(void) accelerometerCallback:(CMAccelerometerData *)data{
    CMAcceleration acc = data.acceleration;
    float dat[3];
    dat[0] = data.acceleration.x;
    dat[1] = data.acceleration.y;
    dat[2] = data.acceleration.z;
    int64_t time = data.timestamp * 1e6;
    ((ISensorClient *) mListener)->handleSensorData(time, 3, dat);
}

@end
