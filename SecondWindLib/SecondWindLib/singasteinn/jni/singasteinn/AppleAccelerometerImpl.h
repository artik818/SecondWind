//
//  AppleAccelerometerImpl.h
//  singasteinn
//
//  Created by Во on 23.11.2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface AppleAccelerometerImpl : NSObject{
    CMMotionManager * mMotionManager;
    NSOperationQueue * mOperationQueue;
    void * mListener;
}

-(id)initWithSampleRate: (int)samplesIntervalMs andListener:(void*) listener;
-(void)accelerometerCallback: (CMAccelerometerData*) data;



@end
