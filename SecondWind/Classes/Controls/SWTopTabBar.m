//
//  SWTopTabBar.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#define WHITE_LINE_WIDTH    64.0f
#define WHITE_LINE_HEIGHT   4.0f

#import "SWTopTabBar.h"
#import "SWGlobalDataSingleton.h"

#import <CoreGraphics/CoreGraphics.h>

@interface SWTopTabBar()

@property (nonatomic, strong) UIView *whiteLine;
@end

@implementation SWTopTabBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGFloat itemX = WHITE_LINE_WIDTH * [SWGlobalDataSingleton globalDataManager].selectedTab;
        _whiteLine = [[UIView alloc] initWithFrame:(CGRect){itemX, CGRectGetHeight(self.frame) - WHITE_LINE_HEIGHT, WHITE_LINE_WIDTH, WHITE_LINE_HEIGHT}];
        _whiteLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:_whiteLine];
    }
    return self;
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex animated:(BOOL)animated {
    if (selectedItemIndex < self.items.count) {
        UITabBarItem *item = self.items[selectedItemIndex];
        self.selectedItem = item;
    }
    CGRect whiteLineFrame = self.whiteLine.frame;
    whiteLineFrame.origin.x = WHITE_LINE_WIDTH * [SWGlobalDataSingleton globalDataManager].selectedTab;
    self.whiteLine.frame = whiteLineFrame;
    if (animated) {
        CGFloat newX = WHITE_LINE_WIDTH * selectedItemIndex;
        [UIView animateWithDuration:1.0f
                         animations:^{
                             CGRect whiteLineFrame = self.whiteLine.frame;
                             whiteLineFrame.origin.x = newX;
                             self.whiteLine.frame = whiteLineFrame;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    [SWGlobalDataSingleton globalDataManager].selectedTab = [self.items indexOfObject:self.selectedItem];
}


@end
