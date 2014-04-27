//
//  SWGlobalDataSingleton.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWGlobalDataSingleton.h"

static SWGlobalDataSingleton *globalDataManager = nil;

@implementation SWGlobalDataSingleton


+ (SWGlobalDataSingleton *)globalDataManager
{
	if (!globalDataManager) {
		globalDataManager = [SWGlobalDataSingleton new];
	}
	
    return globalDataManager;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


@end
