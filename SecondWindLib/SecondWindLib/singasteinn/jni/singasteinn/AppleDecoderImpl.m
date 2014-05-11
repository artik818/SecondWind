//
//  AppleDecoderImpl.m
//  singasteinn
//
//  Created by Во on 10.11.2013.
//
//

#import "AppleDecoderImpl.h"
#import <AVFoundation/AVFoundation.h>


#include <math.h>

static const int SAMPLE_LEN = 2;

@implementation AppleDecoderImpl


-(void) ensureBufferSize: (int) size{
    if (mInputBufferMaxSamples < size){
        if (mInputBuffer)
            free(mInputBuffer);
        mInputBuffer = malloc(size * SAMPLE_LEN);
        mInputBufferMaxSamples = size;
    }
        
}


-(id) initWithUrl:(NSURL *)url{
    assert(url);
    mReaderError = 1;
    
    mInputBufferSamplesRead = 0;
    mInputBuffer = 0;
    mInputBufferMaxSamples = 0;
    mTotalSamplesRead = 0;

    AVURLAsset * ass = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    mReader  = [[AVAssetReader alloc]initWithAsset:ass error:&mReaderError];
    assert(!mReaderError);
    
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    
    mOutput = [[AVAssetReaderAudioMixOutput alloc] initWithAudioTracks:ass.tracks audioSettings:outputSettings];
    
    [mReader addOutput:mOutput];
    
    if ([mReader startReading]){
        NSLog(@"startReading OK");
    }
    return self;
    SInt16 buffer[32168];

    while (mReader.status != AVAssetReaderStatusCompleted) {
        if (mReader.status == AVAssetReaderStatusReading) {
            // Check if the available buffer space is enough to hold at least one cycle of the sample data
            //                if (kTotalBufferSize - playbackState.circularBuffer.fillCount >= 32768) {
            CMSampleBufferRef mInputSampleBuffer = nil;
            CMBlockBufferRef mInputBlockBuffer = nil;
            mInputSampleBuffer = [mOutput copyNextSampleBuffer];
            
            if (mInputSampleBuffer) {
                AudioBufferList abl;
                //CMBlockBufferRef blockBuffer;
                CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(mInputSampleBuffer, NULL, &abl, sizeof(abl), NULL, NULL, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &mInputBlockBuffer);
                int size = CMSampleBufferGetTotalSampleSize(mInputSampleBuffer); // size in bytes
                int samplesCount = size / 2;
                //NSLog(@"Samples are ready, size = %d", (int)size);
                if (CMBlockBufferCopyDataBytes(mInputBlockBuffer, 0, (int)size, buffer) != kCMBlockBufferNoErr){
                    NSLog(@"ERR");
                }
                
                float mean = 0;
                for (int i = 0; i < samplesCount;i++){
                    mean += buffer[i];
                    //fprintf(f, "%d\n", buffer[i]);
                }
                //NSLog(@"mean: %f", mean / samplesCount);
                
                
                CFRelease(mInputSampleBuffer);
                CFRelease(mInputBlockBuffer);
            }
            else {
                break;
            }
            //                }
        }
        else{
            NSLog(@"no data");
        }
    }
    return self;
}

-(void) refillInputBuffer{ // WTF??? infinite loop?
        if (mReader.status == AVAssetReaderStatusReading) {
            // Check if the available buffer space is enough to hold at least one cycle of the sample data
            //                if (kTotalBufferSize - playbackState.circularBuffer.fillCount >= 32768) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            CMSampleBufferRef sampleBuffer = nil;
            CMBlockBufferRef blockBuffer = nil;
            sampleBuffer = [mOutput copyNextSampleBuffer];
            
            if (sampleBuffer) {
                AudioBufferList abl;
                CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, NULL, &abl, sizeof(abl), NULL, NULL, kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &blockBuffer);
                //int inputSamples = CMSampleBufferGetTotalSampleSize(mInputSampleBuffer) / SAMPLE_LEN;
                assert(abl.mNumberBuffers == 1);
                int len = abl.mBuffers[0].mDataByteSize;
                int channels = abl.mBuffers[0].mNumberChannels;
                
                //memcpy(mInputBuffer, abl.mBuffers[0].mData, len);
                [self ensureBufferSize:len / SAMPLE_LEN];
                short * receivedData = (short*)abl.mBuffers[0].mData;
                
                for (int i = 0; i < len / SAMPLE_LEN / channels; i++){
                    mInputBuffer[i] = (receivedData[i * channels] + receivedData[i * channels + 1])/2;
                }

                mInputBufferSamplesCount = len / SAMPLE_LEN / channels;
                mInputBufferSamplesRead = 0;
                
                /*
                if (CMBlockBufferCopyDataBytes(mInputBlockBuffer, 0, inputSamples * SAMPLE_LEN, mInputBuffer) != kCMBlockBufferNoErr){
                    NSLog(@"ERROR!!!!!!");
                    return;
                }*/
                CFRelease(blockBuffer);
                CFRelease(sampleBuffer);
            }
            [pool drain];
        } else {
            NSLog(@"reader is not in 'reading' state");
        }
}

-(int)readToBuffer:(short *)buffer bufferLen:(int)len{
    int read = 0;
    while(read < len){
        if ([self isEOF]){
            return read;
        }
        if (mInputBufferSamplesRead == mInputBufferSamplesCount){
            [self refillInputBuffer];
        }
        else{
            int bytesToRead = (len - read) * SAMPLE_LEN;
            int remainingBytes = (mInputBufferSamplesCount - mInputBufferSamplesRead) * SAMPLE_LEN;
            int readLength = bytesToRead > remainingBytes? remainingBytes: bytesToRead;
            memcpy(buffer + read, mInputBuffer + mInputBufferSamplesRead, readLength);
            read += readLength / SAMPLE_LEN;
            mInputBufferSamplesRead += readLength / SAMPLE_LEN;
            
        }
    }
    mTotalSamplesRead += read;
    return read;
}

-(boolean_t) isEOF{
    return mReader.status != AVAssetReaderStatusReading;
}

-(int)getSampleRate{
    return 44100;
}

-(void)cleanup{
    
}

@end
