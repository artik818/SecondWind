//
//  SWTopTabBar.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWTopTabBar.h"

@implementation SWTopTabBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex animated:(BOOL)animated {
    if (selectedItemIndex < self.items.count) {
        UITabBarItem *item = self.items[selectedItemIndex];
        self.selectedItem = item;
    }
    
}


@end
