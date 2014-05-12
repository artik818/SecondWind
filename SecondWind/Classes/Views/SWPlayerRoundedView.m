//
//  SWPlayerRoundedView.m
//  SecondWind
//
//  Created by Artem on 5/13/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlayerRoundedView.h"

@implementation SWPlayerRoundedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect fr = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self setupSubviewsWithFrame:fr];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame
{
    UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
    image.image = [UIImage imageNamed:@"player_middle"];
    [self addSubview:image];
    
    self.layer.cornerRadius = frame.size.width / 2;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
