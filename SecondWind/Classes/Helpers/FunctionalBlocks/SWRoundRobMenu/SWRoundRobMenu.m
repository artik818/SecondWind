//
//  SWRoundRobMenu.m
//  SecondWind
//
//  Created by Artem on 5/7/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWRoundRobMenu.h"
#import "SWRoundRob.h"



@interface SWRoundRobMenu()

@property (nonatomic, strong) NSArray *viewsArray;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) SWRoundRob *helperRoundRob;

@end



@implementation SWRoundRobMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        _helperRoundRob = [SWRoundRob new];
    }
    return self;
}

- (void)setupWithViews:(NSArray *)viewsArray
{
    _viewsArray = viewsArray;
    [_helperRoundRob setupWithItems:viewsArray];
    [self setNeedsDisplay];
}


#pragma mark - setters / getters

- (void)setDistanceBetweenCenters:(CGFloat)distanceBetweenCenters
{
    _distanceBetweenCenters = distanceBetweenCenters;
    [self setNeedsDisplay];
//    [self layoutIfNeeded];
}


#pragma mark -

- (void)layoutSubviews
{
    [self resetupComponents];
}



#pragma mark -

- (void)resetupComponents
{
    CGPoint centerPoint = self.center;
    
    UIView *someView = nil;
    
    BOOL flAftrCenter = YES;
    for (NSInteger i = 0; i < self.helperRoundRob.itemsCount ; ++i) {
        if (!CGPointEqualToPoint(centerPoint, CGPointZero)) {
            someView = [self.helperRoundRob moveUpItemFor:i];
            [self removeFromSuperSomeView:someView andPutItOnView:self atCenterPoint:centerPoint];
        }
        
        if (flAftrCenter) {
            
        }
        
        centerPoint.y += self.distanceBetweenCenters;
    }
    
    
    
}

- (void)removeFromSuperSomeView:(UIView *)someView andPutItOnView:(UIView *)destView atCenterPoint:(CGPoint)centerPoint
{
    if (someView.superview) {
        [someView removeFromSuperview];
    }
    someView.center = centerPoint;
    
    if (CGRectIntersectsRect(someView.frame, destView.frame)) {
        [destView addSubview:someView];
    }
    
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
