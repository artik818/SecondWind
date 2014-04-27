//
//  SWMediaLibraryProvider.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWMediaLibraryProvider.h"

static SWMediaLibraryProvider *globalMediaManager = nil;

@implementation SWMediaLibraryProvider


+ (SWMediaLibraryProvider *)globalDataManager
{
	if (!globalMediaManager) {
		globalMediaManager = [SWMediaLibraryProvider new];
	}
	
    return globalMediaManager;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


@end
