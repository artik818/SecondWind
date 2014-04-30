//
//  SWRoundRobMenu.m
//  SecondWind
//
//  Created by Artem on 4/30/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWRoundRobMenu.h"



@interface SWRoundRobMenu()

@property (nonatomic, strong) NSArray *arrayOfMenuItems;
@property (nonatomic) NSInteger currentIndex;

@end



@implementation SWRoundRobMenu

- (void)setupWithItems:(NSArray *)menuItems
{
    self.arrayOfMenuItems = menuItems;
    _currentIndex = 0;
}

- (id)currentItem
{
    return self.arrayOfMenuItems[self.currentIndex];
}

- (void)moveDownFor:(NSInteger)steps
{
    self.currentIndex = [self moveDownIndexFor:steps];
}

- (void)moveUpFor:(NSInteger)steps
{
    self.currentIndex = [self moveUpIndexFor:steps];
}

- (id)moveDownItemFor:(NSInteger)steps
{
    NSInteger nextIndex = [self moveDownIndexFor:steps];
    id menuItem = self.arrayOfMenuItems[nextIndex];
    return menuItem;
}

- (id)moveUpItemFor:(NSInteger)steps
{
    NSInteger nextIndex = [self moveUpIndexFor:steps];
    id menuItem = self.arrayOfMenuItems[nextIndex];
    return menuItem;
}


#pragma mark - Utils

- (NSInteger)moveDownIndexFor:(NSInteger)steps
{
    NSInteger nextIndex = self.currentIndex - steps;
    nextIndex = [self normilizeIndex:nextIndex];
    return nextIndex;
}

- (NSInteger)moveUpIndexFor:(NSInteger)steps
{
    NSInteger nextIndex = self.currentIndex + steps;
    nextIndex = [self normilizeIndex:nextIndex];
    return nextIndex;
}

- (NSInteger)normilizeIndex:(NSInteger)unnormedIndex
{
    NSInteger newIndex = unnormedIndex % self.arrayOfMenuItems.count;
    
    if (unnormedIndex < 0) {
        newIndex = self.arrayOfMenuItems.count - newIndex;
    }
    return newIndex;
}

@end
