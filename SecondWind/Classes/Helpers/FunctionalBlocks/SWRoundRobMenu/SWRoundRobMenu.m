//
//  SWRoundRobMenu.m
//  SecondWind
//
//  Created by Artem on 5/7/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWRoundRobMenu.h"
#import "SWRoundRob.h"


#define SWRectSetPos(r, x, y) CGRectMake(x, y, r.size.width, r.size.height)
#define SWRectSetCenterPos(r, x, y) CGRectMake(x - (r.size.width / 2), y - (r.size.height / 2), r.size.width, r.size.height)


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
        [self setupGestures];
    }
    return self;
}

- (void)setupWithViews:(NSArray *)viewsArray
{
    _viewsArray = viewsArray;
    [_helperRoundRob setupWithItems:viewsArray];
    [_helperRoundRob setupCurrentIndex:4];
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



#pragma mark - Utils

- (void)resetupComponents
{
    CGPoint centerPoint = self.center;
    [self positionElementsIfCenterPointIs:centerPoint];
}

// здесь centerPoint - всегда позиция основного элемента
- (void)positionElementsIfCenterPointIs:(CGPoint)centerPoint
{
    UIView *someView = nil;
    
    for (NSInteger i = 0; i < self.helperRoundRob.itemsCount ; ++i) {
        someView = [self.helperRoundRob moveUpItemFor:i];
        
        BOOL isIntersects;
        CGPoint newPoint = [self pointOfViewWithIndex:i ifStartCenterPoint:centerPoint isIntersects:&isIntersects]; //!!!!! NOT Right
        
        if (isIntersects) {
            [self repositionAndAddIfNeededView:someView onSuperView:self atCenterPoint:newPoint];
        }
        else {
            [self removeFromSuperIfNeededView:someView];
        }
    }
}

- (void)moveViewsForYDelta:(CGFloat)yDelta
{
    UIView *currentView = [self.helperRoundRob currentItem];
    CGPoint centerPoint = currentView.center;
    centerPoint.y += yDelta;
    [self positionElementsIfCenterPointIs:centerPoint];
}

- (void)moveNearestViewOnPoint:(CGPoint)somePoint
{
    NSInteger nearestIndex = [self indexOfNearestElementToPoint:somePoint];
    UIView *newCenterView = [self.helperRoundRob itemForIndex:nearestIndex];
    CGFloat yDelta = self.center.y - newCenterView.center.y;
    [self.helperRoundRob setupCurrentIndex:nearestIndex];
    [UIView animateWithDuration:0.5 animations:^{
        [self moveViewsForYDelta:yDelta];
    }];
}

- (CGPoint)pointOfViewWithIndex:(NSInteger)viewIndex ifStartCenterPoint:(CGPoint)startCenterPoint isIntersects:(BOOL *)isIntersects
{
    *isIntersects = YES;
    CGPoint retVal = CGPointMake(startCenterPoint.x, startCenterPoint.y + (viewIndex * self.distanceBetweenCenters));
    
    UIView *currentView = self.viewsArray[viewIndex];
    CGRect viewFrame = currentView.frame;
    viewFrame = SWRectSetCenterPos(viewFrame, retVal.x, retVal.y);
    
    // если не пересекает, пробуем разместить сверху
    if (!CGRectIntersectsRect(viewFrame, self.bounds)) {
        retVal = CGPointMake(startCenterPoint.x, startCenterPoint.y - ((self.viewsArray.count - viewIndex) * self.distanceBetweenCenters));
        viewFrame = SWRectSetCenterPos(viewFrame, retVal.x, retVal.y);
        if (!CGRectIntersectsRect(viewFrame, self.bounds)) {
            isIntersects = NO;
        }
    }
    
    return retVal;
}

- (void)removeFromSuperIfNeededView:(UIView *)someView
{
    if (someView.superview) {
        [someView removeFromSuperview];
    }
}

- (void)repositionAndAddIfNeededView:(UIView *)someView onSuperView:(UIView *)destView atCenterPoint:(CGPoint)centerPoint
{
    someView.center = centerPoint;
    if (!someView.superview) {
        [destView addSubview:someView];
    }
}

- (NSInteger)indexOfNearestElementToPoint:(CGPoint)somePoint
{
    NSInteger retVal = 0;
    
    CGFloat minYDelta = self.bounds.size.height;
    
    for (NSInteger i = 0; i < self.helperRoundRob.itemsCount ; ++i) {
        UIView *someView = [self.helperRoundRob moveUpItemFor:i];
        CGFloat currentDelta = ABS(someView.center.y - somePoint.y);
        if (currentDelta < minYDelta) {
            minYDelta = currentDelta;
            retVal = [self.helperRoundRob moveUpIndexFor:i];
        }
    }
    
    return retVal;
}


#pragma mark - Gestures

- (void)setupGestures
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer;
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureDetected:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeGestureRecognizer];
    
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureDetected:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeGestureRecognizer];
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        [self moveViewsForYDelta:translation.y];
        NSLog(@"%@", NSStringFromCGPoint(translation));
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
    if (state == UIGestureRecognizerStateEnded)
    {
        [self moveNearestViewOnPoint:self.center];
    }
}

- (void)swipeGestureDetected:(UISwipeGestureRecognizer *)recognizer
{
    UISwipeGestureRecognizerDirection direction = recognizer.direction;
    if (UISwipeGestureRecognizerDirectionUp == direction) {
        [self moveViewsForYDelta:-250];
    }
    if (UISwipeGestureRecognizerDirectionDown == direction) {
        [self moveViewsForYDelta:250];
    }
}


@end
