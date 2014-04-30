//
//  SWRoundRobMenu.h
//  SecondWind
//
//  Created by Artem on 4/30/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWRoundRobMenu : NSObject

- (void)setupWithItems:(NSArray *)menuItems;
- (void)moveDownFor:(NSInteger)steps;
- (void)moveUpFor:(NSInteger)steps;
- (NSInteger)itemsCount;

- (id)currentItem;
- (id)moveDownItemFor:(NSInteger)steps;
- (id)moveUpItemFor:(NSInteger)steps;

@end
