//
//  SWPlayerMenuObject.m
//  SecondWind
//
//  Created by Artem on 4/29/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlayerMenuObject.h"

@interface SWPlayerMenuObject()

@end


@implementation SWPlayerMenuObject

- (SWPlayerMenuItem *)currentItem
{
    return [super currentItem];
}

- (SWPlayerMenuItem *)moveDownItemFor:(NSInteger)steps;
{
    SWPlayerMenuItem *menuItem = [super moveDownItemFor:steps];
    return menuItem;
}

- (SWPlayerMenuItem *)moveUpItemFor:(NSInteger)steps;
{
    SWPlayerMenuItem *menuItem = [super moveUpItemFor:steps];
    return menuItem;
}

@end
