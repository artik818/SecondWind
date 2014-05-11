//
//  AppleDecoder.m
//  singasteinn
//
//  Created by Во on 12.11.2013.
//
//
#import <Foundation/Foundation.h>
#import "AppleDecoderImpl.h"
#include "AppleDecoder.h"

void * _afdecoderCreate(const char * s_url){
    NSString * s = [NSString stringWithCString:s_url];
    NSURL * url = [NSURL URLWithString:s];
    assert(url);
    return [[AppleDecoderImpl alloc] initWithUrl:url ];
}

int afdecoderRead(void *self, short* buffer, int len){
    AppleDecoderImpl * s = (AppleDecoderImpl*) self;
    return [s readToBuffer:buffer bufferLen:len];
}
int afdecoderIsEOF(void * self){
    return [(AppleDecoderImpl*)self isEOF];
    
}
int afdecoderGetSampleRate(void * self){
    return [(AppleDecoderImpl *)self getSampleRate];
}
void  afdecoderDestroy(void * self){
    // in GC we trust...
}

void AppleDecoder::open(std::string url){
    fprintf(stderr, "AppleDecoder: opening %s\n", url.c_str());
    NSString * s = [NSString stringWithCString:url.c_str()];
    obj = [[AppleDecoderImpl alloc] initWithUrl:[[NSURL alloc] initWithString:s] ];
}

