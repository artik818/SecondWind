//
//  SWPlayerView.m
//  SecondWind
//
//  Created by Arakelyan on 4/30/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlayerView.h"



@interface SWPlayerView()

@property (nonatomic, strong) NSMutableArray *viewsArray;

@end



@implementation SWPlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviewsWithFrame:frame];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame
{
    self.viewsArray = [NSMutableArray new];
    
    
}

@end
