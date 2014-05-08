//
//  SWRoundRobMenu.h
//  SecondWind
//
//  Created by Artem on 4/30/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWRoundRob : NSObject

- (void)setupWithItems:(NSArray *)menuItems;
- (void)moveDownFor:(NSInteger)steps;
- (void)moveUpFor:(NSInteger)steps;
- (NSInteger)itemsCount;

- (id)currentItem;
- (id)itemForIndex:(NSInteger)itemIndex;
- (void)setupCurrentIndex:(NSInteger)newIndex;
- (id)moveDownItemFor:(NSInteger)steps;
- (id)moveUpItemFor:(NSInteger)steps;
- (NSInteger)moveDownIndexFor:(NSInteger)steps;
- (NSInteger)moveUpIndexFor:(NSInteger)steps;

@end
