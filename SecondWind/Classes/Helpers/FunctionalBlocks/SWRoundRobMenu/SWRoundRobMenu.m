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

@property (nonatomic) CGFloat stepDuration;
@property (nonatomic) CGFloat stepFullDelta;
@property (nonatomic) CGFloat stepCurrentDeltaSumm;
@property (nonatomic) CGFloat stepOneDelta;

@property (nonatomic, strong) NSMutableArray *backgroundViewsArray;

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
    
    [self setupBackgroundsArray];
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

- (void)setupBackgroundsArray
{
    NSInteger itemsCount = [self.datasource roundRobMenuNumberOfItems:self];
    
    self.backgroundViewsArray = [NSMutableArray new];
    
    for (NSInteger i = 0; i < itemsCount; i++) {
        UIImage *bkImage = [self.datasource roundRobMenu:self backroundImageForItemWithIndex:i];
        UIImageView *bkImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bkImageView.image = bkImage;
        [self.backgroundViewsArray addObject:bkImageView];
        bkImageView.alpha = 0;
//        bkImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [self addSubview:bkImageView];
    }
    
    [self setupBackgroundsAlphaIfNearestViewIndex:self.centerItemIndex delta:0];
}

- (void)getAlphaPercentForNearestView:(CGFloat *)percentNearestView smezhniyView:(CGFloat *)percentSmezhniyView IfNearestViewIndex:(NSInteger)viewIndex delta:(CGFloat)delta
{
    CGFloat distanceFromMainView = ABS(delta);
    CGFloat distanceFromSmezhniyView = self.distanceBetweenCenters - distanceFromMainView;
    
    CGFloat porogInPercent = 20;
    CGFloat porogInPoints = self.distanceBetweenCenters * porogInPercent / 100;
    CGFloat workDistance = self.distanceBetweenCenters - (porogInPoints * 2);
    
    CGFloat alphaMainView = 0;
    CGFloat alphaSmezhniyView = 0;
    
    if (distanceFromMainView < porogInPoints) {
        alphaMainView = 1;
    }
    else if (distanceFromMainView > (self.distanceBetweenCenters - porogInPoints)) {
        alphaMainView = 0;
    }
    else {
        alphaMainView = 1 - ((distanceFromMainView - porogInPoints) / workDistance);
    }
    
    // ---------------------
    if (distanceFromSmezhniyView < porogInPoints) {
        alphaSmezhniyView = 1;
    }
    else if (distanceFromSmezhniyView > (self.distanceBetweenCenters - porogInPoints)) {
        alphaSmezhniyView = 0;
    }
    else {
        alphaSmezhniyView = 1 - ((distanceFromSmezhniyView - porogInPoints) / workDistance);
    }
    
    *percentNearestView = alphaMainView;
    *percentSmezhniyView = alphaSmezhniyView;
}

- (void)setupBackgroundsAlphaIfNearestViewIndex:(NSInteger)viewIndex delta:(CGFloat)delta
{
    NSInteger smezhniyIndex = (delta > 0) ? (viewIndex + 1) : (viewIndex - 1);
    NSInteger itemsCount = [self.datasource roundRobMenuNumberOfItems:self];
    smezhniyIndex = [self normilizeIndex:smezhniyIndex ifCount:itemsCount];
    
    CGFloat alphaMainView = 0;
    CGFloat alphaSmezhniyView = 0;
    UIImageView *bkGroundImageView;
    
    [self getAlphaPercentForNearestView:&alphaMainView smezhniyView:&alphaSmezhniyView IfNearestViewIndex:viewIndex delta:delta];
    
    bkGroundImageView = self.backgroundViewsArray[viewIndex];
    bkGroundImageView.alpha = alphaMainView;
    
    bkGroundImageView = self.backgroundViewsArray[smezhniyIndex];
    bkGroundImageView.alpha = alphaSmezhniyView;
}

- (void)moveViewsFromViewsArrayToDelta:(CGFloat)yDelta
{
//    CGFloat formCenterYDisrance = self.currentCenterY - self.centerPos.y;
    
    CGFloat realDelta = 0;
    NSInteger realObjectIndex = 0;
    NSInteger viewIndex = 0;
    
    ViewObject *viewObject = [self findNearestViewObjectAndGetDelta:&realDelta realObjectIndex:&realObjectIndex];
    
    viewIndex = viewObject.viewIndex;
    
//    NSLog(@"realDelta == %7.3f, realObjectIndex == %d, viewIndex == %d", realDelta, realObjectIndex, viewIndex);

    [self setupBackgroundsAlphaIfNearestViewIndex:viewIndex delta:realDelta];
    
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

- (ViewObject *)findNearestViewObjectAndGetDelta:(CGFloat *)pDelta realObjectIndex:(NSInteger *)pRealObjectIndex
{
    __block CGFloat minAbsDelta = self.distanceBetweenCenters;
    __block CGFloat realDelta = 0;
    __block NSInteger realViewIndex = 0;
    
    [self.viewObjectsArray enumerateObjectsUsingBlock:^(ViewObject *viewObject, NSUInteger idx, BOOL *stop) {
        UIView *view = viewObject.view;
        CGFloat currentDelta = self.centerPos.y - view.center.y;
        if (ABS(currentDelta) < minAbsDelta) {
            minAbsDelta = ABS(currentDelta);
            realDelta = currentDelta;
            realViewIndex = idx;
        }
    }];
    
    *pDelta = realDelta;
    *pRealObjectIndex = realViewIndex;
    ViewObject *viewObject = self.viewObjectsArray[realViewIndex];
    
    return viewObject;
}

- (void)moveViewsToNearest
{
    CGFloat realDelta = 0;
    NSInteger realViewIndex = 0;
    ViewObject *viewObject = [self findNearestViewObjectAndGetDelta:&realDelta realObjectIndex:&realViewIndex];
    
    if (realDelta) {
        CGFloat duration = ABS(0.5 * (realDelta / self.distanceBetweenCenters));
        
        self.centerViewIndexInViewsArray = realViewIndex;
        self.centerItemIndex = viewObject.viewIndex;
        
        [self startSteppingWithDelta:realDelta duration:duration];
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
        [self moveViewsToNearest];
    }
}

- (void)swipeGestureDetected:(UISwipeGestureRecognizer *)recognizer
{
    UISwipeGestureRecognizerDirection direction = recognizer.direction;
    if (UISwipeGestureRecognizerDirectionUp == direction) {
        [self startSteppingWithDelta:-self.distanceBetweenCenters duration:0.5];
    }
    if (UISwipeGestureRecognizerDirectionDown == direction) {
        [self startSteppingWithDelta:self.distanceBetweenCenters duration:0.5];
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
    
    self.currentCenterY = self.centerPos.y;
}

- (void)step
{
    CGFloat currentDelta = self.stepOneDelta;
    CGFloat nextSumm = self.stepCurrentDeltaSumm + currentDelta;
    
    BOOL flSopStepping = NO;
    
    if (ABS(nextSumm) >= ABS(self.stepFullDelta)) {
        currentDelta = self.stepFullDelta - self.stepCurrentDeltaSumm;
        flSopStepping = YES;
    }
    
    self.stepCurrentDeltaSumm += currentDelta;
    
    self.currentCenterY += currentDelta;
    
    if (flSopStepping) {
        [self stopAnimation];
    }
    
    [self moveViewsFromViewsArrayToDelta:currentDelta];
}

- (void)startSteppingWithDelta:(CGFloat)delta duration:(CGFloat)duration
{
    self.stepFullDelta = delta;
    self.stepOneDelta = delta / duration / 60;
    self.stepDuration = duration;
    self.stepCurrentDeltaSumm = 0;
    [self startAnimation];
}

@end
