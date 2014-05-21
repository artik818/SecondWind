//
//  SWGlobalDataSingleton.h
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWGlobalConsts.h"


@interface SWGlobalDataSingleton : NSObject

@property (nonatomic) NSUInteger selectedTab;
@property (nonatomic) PlayerMenuItemType playerMode;

+ (SWGlobalDataSingleton *)globalDataManager;

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;

@end
