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

- (void)moveDown
{
    self.currentIndex = [self moveDownIndex];
}

- (void)moveUp
{
    self.currentIndex = [self moveUpIndex];
}

- (id)moveDownItem
{
    NSInteger nextIndex = [self moveDownIndex];
    id menuItem = self.arrayOfMenuItems[nextIndex];
    return menuItem;
}

- (id)moveUpItem
{
    NSInteger nextIndex = [self moveUpIndex];
    id menuItem = self.arrayOfMenuItems[nextIndex];
    return menuItem;
}


#pragma mark - Utils

- (NSInteger)moveDownIndex
{
    NSInteger nextIndex = self.currentIndex--;
    nextIndex = [self normilizeIndex:nextIndex];
    return nextIndex;
}

- (NSInteger)moveUpIndex
{
    NSInteger nextIndex = self.currentIndex++;
    nextIndex = [self normilizeIndex:nextIndex];
    return nextIndex;
}

- (NSInteger)normilizeIndex:(NSInteger)unnormedIndex
{
    NSInteger newIndex = unnormedIndex;
    newIndex = MIN(newIndex, self.arrayOfMenuItems.count - 1);
    newIndex = MAX(newIndex, 0);
    return newIndex;
}

@end
