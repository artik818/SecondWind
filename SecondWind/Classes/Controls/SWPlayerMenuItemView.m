//
//  SWPlayerMenuItemView.m
//  SecondWind
//
//  Created by Arakelyan on 4/30/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlayerMenuItemView.h"



@interface SWPlayerMenuItemView()

@property (nonatomic, strong) SWPlayerMenuItem *menuItem;

@end



@implementation SWPlayerMenuItemView

- (id)initWithFrame:(CGRect)frame menuItem:(SWPlayerMenuItem *)menuItem
{
    self = [super initWithFrame:frame];
    if (self) {
        _menuItem = menuItem;
    }
    return self;
}


@end
