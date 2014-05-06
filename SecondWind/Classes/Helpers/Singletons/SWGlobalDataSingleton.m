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
        _selectedTab = kTabBarIndex_Tracks;
    }
    return self;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];

    } else if (minutes > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];

    } else {
        return [NSString stringWithFormat:@"%02ld", (long)seconds];
    }
}


@end
