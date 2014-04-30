//
//  SWPlayerMenuObject.h
//  SecondWind
//
//  Created by Artem on 4/29/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWPlayerMenuItem.h"
#import "SWRoundRobMenu.h"


@interface SWPlayerMenuObject : SWRoundRobMenu

- (SWPlayerMenuItem *)moveDownItemFor:(NSInteger)steps;
- (SWPlayerMenuItem *)moveUpItemFor:(NSInteger)steps;

@end
