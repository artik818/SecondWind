//
//  SWPlayerMenuItem.h
//  SecondWind
//
//  Created by Artem on 4/29/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PlayerMenuItemType)
{
    PlayerMenuItemTypeNone,
    PlayerMenuItemTypeNoEffect,
    PlayerMenuItemTypeAuto,
    PlayerMenuItemTypeFixed,
};

@interface SWPlayerMenuItem : NSObject

@property (nonatomic) PlayerMenuItemType type;
@property (nonatomic) NSInteger rate;

@end
