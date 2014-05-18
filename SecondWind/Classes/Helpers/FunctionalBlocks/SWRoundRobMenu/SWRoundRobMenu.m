//
//  SWRoundRobMenu.m
//  SecondWind
//
//  Created by Artem on 5/7/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWRoundRobMenu.h"
#import "SWRoundRob.h"
#import "EndlessScroller.h"



#define SWRectSetPos(r, x, y) CGRectMake(x, y, r.size.width, r.size.height)
#define SWRectSetCenterPos(r, x, y) CGRectMake(x - (r.size.width / 2), y - (r.size.height / 2), r.size.width, r.size.height)


#define MAX_BAD_VIEWS       2


@interface ViewObject : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic) NSInteger viewIndex;

- (void)setupVithView:(UIView *)view viewIndex:(NSInteger)viewIndex;

@end


@implementation ViewObject

- (void)setupVithView:(UIView *)view viewIndex:(NSInteger)viewIndex
{
    self.view = view;
    self.viewIndex = viewIndex;
}

@end



@interface SWRoundRobMenu() //<EndlessScrollerDataSource>

@property (nonatomic) NSInteger centerItemIndex;
@property (nonatomic) CGFloat distanceBetweenCenters;

@property (nonatomic, readonly) CGPoint centerPos;
@property (nonatomic) CGFloat currentCenterY;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *viewObjectsArray;
@property (nonatomic) NSInteger centerViewIndexInViewsArray;

@property (nonatomic, strong) EndlessScroller *scroller;

@end



@implementation SWRoundRobMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _centerItemIndex = 0;
        _centerPos = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        _currentCenterY = _centerPos.y;
        _viewObjectsArray = [NSMutableArray new];
        [self setupGestures];
    }
    return self;
}


#pragma mark - Interface funcs

- (void)setupWithStartIndex:(NSInteger)startViewIndex distanceBetweenCenters:(CGFloat)distanceBetweenCenters
{
    self.centerItemIndex = startViewIndex;
    _distanceBetweenCenters = distanceBetweenCenters;
    
    [self setupComponents];
    [self addNewViewsIfNeeded];
}



#pragma mark - Utils

- (void)setupComponents
{
    NSInteger numberOfItems = [self.datasource roundRobMenuNumberOfItems:self];
    if (self.centerItemIndex >= numberOfItems) {
        self.centerItemIndex = 0;
    }
    
    NSInteger currentItemIndex = self.centerItemIndex;
    
    NSInteger i = 0;
    
    do {
        if (currentItemIndex >= numberOfItems) {
            currentItemIndex = 0;
        }
        
        UIView *currentView = [self.datasource roundRobMenu:self viewForItemWithIndex:currentItemIndex];
        
        currentView.frame = SWRectSetCenterPos(currentView.frame, self.centerPos.x, self.currentCenterY + (i * self.distanceBetweenCenters));
        if (CGRectIntersectsRect(currentView.frame, self.bounds)) {
            [self addSubview:currentView];
            ViewObject *viewObject = [ViewObject new];
            [viewObject setupVithView:currentView viewIndex:currentItemIndex];
            [self.viewObjectsArray addObject:viewObject];
        }
        else {
            break;
        }
        
        currentItemIndex++;
        i++;
    } while (YES);
    
    
    i = -1;
    currentItemIndex = self.centerItemIndex - 1;
    do {
        if (currentItemIndex < 0) {
            currentItemIndex = numberOfItems - 1;
        }
        
        UIView *currentView = [self.datasource roundRobMenu:self viewForItemWithIndex:currentItemIndex];
        
        currentView.frame = SWRectSetCenterPos(currentView.frame, self.centerPos.x, self.currentCenterY + (i * self.distanceBetweenCenters));
        if (CGRectIntersectsRect(currentView.frame, self.bounds)) {
            [self addSubview:currentView];
            ViewObject *viewObject = [ViewObject new];
            [viewObject setupVithView:currentView viewIndex:currentItemIndex];
            [self.viewObjectsArray insertObject:viewObject atIndex:0];
            self.centerViewIndexInViewsArray++;
        }
        else {
            break;
        }
        
        currentItemIndex--;
        i--;
    } while (YES);
    
}

- (void)moveViewsFromViewsArrayToDelta:(CGFloat)yDelta
{
    CGFloat formCenterYDisrance = self.currentCenterY - self.centerPos.y;
    
    for (NSInteger viewIndex = 0; viewIndex < self.viewObjectsArray.count; viewIndex++) {
        ViewObject *viewObject = self.viewObjectsArray[viewIndex];
        UIView *currentView = viewObject.view;
        currentView.frame = CGRectOffset(currentView.frame, 0, yDelta);
    }
    
    [self addNewViewsIfNeeded];
    [self removeBadViewsIfNeeded];
}

- (void)removeBadViewsIfNeeded
{
    ViewObject *viewObject;
    NSInteger currentItemIndex;
    UIView *currentView;
    
    NSInteger badViewsCount = 0;
    for (NSInteger i = 0; i < MAX_BAD_VIEWS; i++) {
        viewObject = self.viewObjectsArray[i];
        
        currentItemIndex = viewObject.viewIndex;
        currentView = viewObject.view;
        
        if (!CGRectIntersectsRect(currentView.frame, self.bounds)) {
            badViewsCount++;
        }
    }
    
    if (badViewsCount >= MAX_BAD_VIEWS) {
        viewObject = self.viewObjectsArray.firstObject;
        currentView = viewObject.view;
        [currentView removeFromSuperview];
        [self.viewObjectsArray removeObjectAtIndex:0];
        self.centerViewIndexInViewsArray--;
    }
    
    // ------------------------
    
    badViewsCount = 0;
    for (NSInteger i = self.viewObjectsArray.count - 1; i >= self.viewObjectsArray.count - MAX_BAD_VIEWS; i--) {
        viewObject = self.viewObjectsArray[i];
        
        currentItemIndex = viewObject.viewIndex;
        currentView = viewObject.view;
        
        if (!CGRectIntersectsRect(currentView.frame, self.bounds)) {
            badViewsCount++;
        }
    }
    
    if (badViewsCount >= MAX_BAD_VIEWS) {
        viewObject = self.viewObjectsArray.lastObject;
        currentView = viewObject.view;
        [currentView removeFromSuperview];
        [self.viewObjectsArray removeObjectAtIndex:self.viewObjectsArray.count - 1];
        self.centerViewIndexInViewsArray--;
    }

}

- (void)addNewViewsIfNeeded
{
    ViewObject *viewObject;
    NSInteger currentItemIndex;
    UIView *currentView;
    
    NSInteger numberOfItems = [self.datasource roundRobMenuNumberOfItems:self];
    
    viewObject = self.viewObjectsArray.lastObject;
    
    currentItemIndex = viewObject.viewIndex;
    currentView = viewObject.view;
    
    if (CGRectIntersectsRect(currentView.frame, self.bounds)) {
        [self addNewViewAtEnd];
    }
    
    //--------
    
    viewObject = self.viewObjectsArray.firstObject;
    
    currentItemIndex = viewObject.viewIndex;
    currentView = viewObject.view;
    
    if (CGRectIntersectsRect(currentView.frame, self.bounds)) {
        [self addNewViewAtBegin];
    }
}

- (void)addNewViewAtEnd
{
    ViewObject *viewObject;
    NSInteger currentItemIndex;
    UIView *currentView;
    
    NSInteger numberOfItems = [self.datasource roundRobMenuNumberOfItems:self];
    
    viewObject = self.viewObjectsArray.lastObject;
    
    currentItemIndex = viewObject.viewIndex;
    currentView = viewObject.view;
    
    // add new view
    currentItemIndex++;
    currentItemIndex = [self normilizeIndex:currentItemIndex ifCount:numberOfItems];
    UIView *newView = [self.datasource roundRobMenu:self viewForItemWithIndex:currentItemIndex];
    newView.frame = CGRectOffset(currentView.frame, 0, self.distanceBetweenCenters);
    [self addSubview:newView];
    ViewObject *newViewObject = [ViewObject new];
    [newViewObject setupVithView:newView viewIndex:currentItemIndex];
    [self.viewObjectsArray addObject:newViewObject];
}

- (void)addNewViewAtBegin
{
    ViewObject *viewObject;
    NSInteger currentItemIndex;
    UIView *currentView;
    
    NSInteger numberOfItems = [self.datasource roundRobMenuNumberOfItems:self];
    
    viewObject = self.viewObjectsArray.firstObject;
    
    currentItemIndex = viewObject.viewIndex;
    currentView = viewObject.view;
    
    if (CGRectIntersectsRect(currentView.frame, self.bounds)) {
        // add new view
        currentItemIndex--;
        currentItemIndex = [self normilizeIndex:currentItemIndex ifCount:numberOfItems];
        UIView *newView = [self.datasource roundRobMenu:self viewForItemWithIndex:currentItemIndex];
        newView.frame = CGRectOffset(currentView.frame, 0, -self.distanceBetweenCenters);
        [self addSubview:newView];
        ViewObject *newViewObject = [ViewObject new];
        [newViewObject setupVithView:newView viewIndex:currentItemIndex];
        [self.viewObjectsArray insertObject:newViewObject atIndex:0];
        self.centerViewIndexInViewsArray++;
    }
}

- (NSInteger)normilizeIndex:(NSInteger)unnormedIndex ifCount:(NSInteger)count
{
    if (unnormedIndex < 0) {
        unnormedIndex -= 1;
    }
    NSInteger newIndex = ABS(unnormedIndex % count);
    return newIndex;
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
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
        self.currentCenterY += translation.y;
        [self moveViewsFromViewsArrayToDelta:translation.y];
    }
    
    if (state == UIGestureRecognizerStateEnded)
    {
//        [self moveNearestViewOnPoint:self.center];
    }
}

- (void)swipeGestureDetected:(UISwipeGestureRecognizer *)recognizer
{
    UISwipeGestureRecognizerDirection direction = recognizer.direction;
    if (UISwipeGestureRecognizerDirectionUp == direction) {
        self.currentCenterY -= 250;
//        [self resetupComponents];
    }
    if (UISwipeGestureRecognizerDirectionDown == direction) {
        self.currentCenterY += 250;
//        [self resetupComponents];
    }
}



#pragma mark - Animation

- (void)startAnimation
{
    if (!_timer) {
        self.timer = [NSTimer timerWithTimeInterval:1.0/60.0 target:self selector:@selector(step) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//#ifdef ICAROUSEL_IOS
//        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
//#endif
    }
}

- (void)stopAnimation
{
    [_timer invalidate];
    _timer = nil;
}

- (void)step
{
    
}

@end
