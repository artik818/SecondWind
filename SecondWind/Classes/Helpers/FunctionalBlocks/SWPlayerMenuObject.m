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

- (SWPlayerMenuItem *)moveDownItem
{
    SWPlayerMenuItem *menuItem = [super moveDownItem];
    return menuItem;
}

- (SWPlayerMenuItem *)moveUpItem
{
    SWPlayerMenuItem *menuItem = [super moveUpItem];
    return menuItem;
}

@end
