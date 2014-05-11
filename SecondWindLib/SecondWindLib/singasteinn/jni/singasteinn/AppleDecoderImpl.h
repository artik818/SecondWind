//
//  AppleDecoderImpl.h
//  singasteinn
//
//  Created by Во on 10.11.2013.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface AppleDecoderImpl : NSObject{

NSURL * mUrl;
AVAssetReader * mReader;
AVAssetReaderAudioMixOutput * mOutput;
NSError * mReaderError;


unsigned int mInputBufferSamplesCount;
unsigned int mInputBufferSamplesRead;
short * mInputBuffer;
int mInputBufferMaxSamples;
UInt64 mTotalSamplesRead;
}


-(id) initWithUrl: (NSURL*) c_url;
-(boolean_t) isEOF;
-(int) readToBuffer: (short*)buffer bufferLen:(int) len;
-(int) getSampleRate;
-(void) cleanup;

@end
