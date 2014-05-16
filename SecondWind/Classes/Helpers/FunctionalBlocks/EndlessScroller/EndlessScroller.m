//
//  EndlessScroller.m
//  MUIControls
//
//  Created by Kozharin on 18.06.12.
//  Copyright (c) 2012 iCupid. All rights reserved.
//

#import "EndlessScroller.h"
@interface EndlessScroller()
@property (nonatomic, strong) NSMutableSet*reusableElements;
@property (nonatomic, assign) int firstElementPositionInDataSource;
@property (nonatomic, strong) NSMutableArray*matrix;
@property (assign) CGPoint acceleration;
@property (assign) CGPoint velocity;
@property (strong) NSTimer* timer;
@property (assign) CGPoint touchStart;
@end


@implementation EndlessScroller

@synthesize touchStart = _touchStart;
@synthesize timer = _timer;
@synthesize velocity = _velocity;
@synthesize acceleration = _acceleration;
@synthesize firstElementPositionInDataSource = _firstElementPositionInDataSource;
@synthesize matrix = _matrix;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize elementSize = _elementSize;
@synthesize reusableElements = _reusableElements;

-(void)setfirstElementPositionInDataSource:(int)firstElementPositionInDataSource
{
    _firstElementPositionInDataSource = firstElementPositionInDataSource;
}
-(UIView*)getElementFromDataSourceForRow:(int)rowPos column:(int)columnPos
{
    int index = [self getDataSourceIndexForItemAtRow:rowPos column:columnPos];
    UIView* ret = [self.dataSource scroller:self elementAtIndex:index];
    ret.frame = CGRectMake(0, 0, self.elementSize.width, self.elementSize.height);
    return ret;
}
-(NSMutableArray*)matrix
{
    if (!_matrix) _matrix = [[NSMutableArray alloc] init];
    return _matrix;
}
-(NSMutableSet*)reusableElements
{
    if (!_reusableElements) _reusableElements = [[NSMutableSet alloc] init];
    return _reusableElements;
}
-(void)cleanup
{
    self.firstElementPositionInDataSource = 0;
    while (self.subviews.count > 0) {
        [self removeSubview:self.subviews.lastObject];
    }
    [self.matrix removeAllObjects];
}
-(void)reloadDataForceCleanup:(BOOL)cleanup
{
    if (cleanup) {
        [self cleanup];
    }
    [self reloadDataChangeDimensions];
}
-(void)matrixMoveDown:(int)Yoffset right:(int)Xoffset
{
    self.firstElementPositionInDataSource = [self getDataSourceIndexForItemAtRow:Yoffset column:Xoffset];
}
-(int)rowWidth
{
    int rowWidth = self.bounds.size.width/self.elementSize.width;
    if (rowWidth<1) {
        rowWidth = 1;
    }
    rowWidth += 3;
    return rowWidth;
}
-(int)rowHeight
{
    int rowHeight = self.bounds.size.height/self.elementSize.height;
    if (rowHeight<1) {
        rowHeight = 1;
    }
    rowHeight += 3;
    return rowHeight;
}
-(int)getDataSourceIndexForItemAtRow:(int)row column:(int)column
{
    int result = self.firstElementPositionInDataSource + column + ([self rowWidth])*2*row;
        
    if (result >= (int)[self.dataSource elementsCount]) { 
        result = result%[self.dataSource elementsCount];
    }
    
    while (result < 0) {
        result += [self.dataSource elementsCount];
    }
    return result;
}
-(void)reloadDataChangeDimensions
{
    if (self.elementSize.width == 0 || self.elementSize.height == 0 || self.frame.size.width == 0 || self.frame.size.height == 0 || self.dataSource == nil || [self.dataSource elementsCount] == 0) {
        [self cleanup];
        return;
    }
    [self moveMatrix];
    return;
}
#define TAIL_MULTIPLIER 10
-(void)cleanupTail
{
    NSMutableArray*topRow = nil;
    NSMutableArray*botRow = nil;
    if (self.matrix.count>0) {
        topRow = [self.matrix objectAtIndex:0];
        botRow = [self.matrix lastObject];
    }
    
    UIView*topLeft = [topRow objectAtIndex:0];
    while (CGRectGetMaxY(topLeft.frame) < 0 - self.elementSize.height) {
        [self matrixMoveDown:1 right:0];
        for (UIView*vw in topRow) {
            [self removeSubview:vw];
        }
        [topRow removeAllObjects];
        [self.matrix removeObject:topRow];
        topRow = [self.matrix objectAtIndex:0];
        topLeft = [topRow objectAtIndex:0];
    }
    UIView*botLeft = [botRow objectAtIndex:0];
    while (CGRectGetMinY(botLeft.frame) > self.bounds.size.height + self.elementSize.height) {
        for (UIView*vw in botRow) {
            [self removeSubview:vw];
        }
        [botRow removeAllObjects];
        [self.matrix removeObject:botRow];
        botRow = [self.matrix lastObject];
        botLeft = [botRow objectAtIndex:0];
    }
    
    topRow = [self.matrix objectAtIndex:0];
    topLeft = [topRow objectAtIndex:0];
    
    for (NSMutableArray*row in self.matrix) {
        UIView*left = [row objectAtIndex:0];
        while (CGRectGetMaxX(left.frame) < 0 - self.elementSize.width*TAIL_MULTIPLIER) {
            if (row == topRow) {
                [self matrixMoveDown:0 right:1];
            }
            [self removeSubview:left];
            [row removeObject:left];
            left = [row objectAtIndex:0];
        }
    }
    
    for (NSMutableArray*row in self.matrix) {
        UIView*right = [row lastObject];
        while (CGRectGetMinX(right.frame) > self.bounds.size.width+self.elementSize.width*TAIL_MULTIPLIER) {
            [self removeSubview:right];
            [row removeObject:right];
            right = [row lastObject];
        }
    }
    
}
-(void)moveMatrix
{
    NSMutableArray*topRow = nil;
    NSMutableArray*botRow = nil;
    if (self.matrix.count>0) {
        topRow = [self.matrix objectAtIndex:0];
        botRow = [self.matrix lastObject];
    }
    
    UIView*topLeft = [topRow objectAtIndex:0];
    while (CGRectGetMaxY(topLeft.frame) < 0 - self.elementSize.height*TAIL_MULTIPLIER) {
        [self matrixMoveDown:1 right:0];
        for (UIView*vw in topRow) {
            [self removeSubview:vw];
        }
        [topRow removeAllObjects];
        [self.matrix removeObject:topRow];
        topRow = [self.matrix objectAtIndex:0];
        topLeft = [topRow objectAtIndex:0];
    }
    UIView*botLeft = [botRow objectAtIndex:0];
    while (CGRectGetMinY(botLeft.frame) > self.bounds.size.height + self.elementSize.height*TAIL_MULTIPLIER) {
        for (UIView*vw in botRow) {
            [self removeSubview:vw];
        }
        [botRow removeAllObjects];
        [self.matrix removeObject:botRow];
        botRow = [self.matrix lastObject];
        botLeft = [botRow objectAtIndex:0];
    }
    int anchorMatrixPosX = 2;
    int anchorMatrixPosY = 2;
    
    if (topLeft) {
        anchorMatrixPosX = 0;
        anchorMatrixPosY = 1;
    }
    while (CGRectGetMinY(topLeft.frame) > 0 - self.elementSize.height) {
        NSMutableArray*newTopRow = [[NSMutableArray alloc] initWithCapacity:[self rowWidth]];
        [self matrixMoveDown:-1 right:0];
        for (int i = 0; i<[self rowWidth]; i++) {
            UIView*item = [self getElementFromDataSourceForRow:0 column:i];
            [self addSubview:item atMatrixRow:0 atMatrixCol:i withAnchor:topLeft.frame.origin onPosR:anchorMatrixPosY onPosC:anchorMatrixPosX];
            if (!topLeft) {
                topLeft = item;
                anchorMatrixPosX = 0;
                anchorMatrixPosY = 0;
            }
            [newTopRow addObject:item];
        }
        [self.matrix insertObject:newTopRow atIndex:0];
        topLeft = [newTopRow objectAtIndex:0];
        anchorMatrixPosX = 0;
        anchorMatrixPosY = 1;
    }
    if (self.matrix.count>0) {
        topRow = [self.matrix objectAtIndex:0];
        botRow = [self.matrix lastObject];
        botLeft = [botRow objectAtIndex:0];
    }
    while (CGRectGetMaxY(botLeft.frame) < self.bounds.size.height + self.elementSize.height) {
        NSMutableArray*newBotRow = [[NSMutableArray alloc] initWithCapacity:[self rowWidth]];
        for (int i = 0; i<[self rowWidth]; i++) {
            UIView*item = [self getElementFromDataSourceForRow:self.matrix.count column:i];
            [self addSubview:item atMatrixRow:self.matrix.count atMatrixCol:i withAnchor:topLeft.frame.origin onPosR:0 onPosC:0];
            [newBotRow addObject:item];
        }
        [self.matrix addObject:newBotRow];
        botLeft = [newBotRow objectAtIndex:0];
    }
    topRow = [self.matrix objectAtIndex:0];
    topLeft = [topRow objectAtIndex:0];
    
    for (NSMutableArray*row in self.matrix) {
        UIView*left = [row objectAtIndex:0];
        while (CGRectGetMaxX(left.frame) < 0 - self.elementSize.width*TAIL_MULTIPLIER) {
            if (row == topRow) {
                [self matrixMoveDown:0 right:1];
            }
            [self removeSubview:left];
            [row removeObject:left];
            left = [row objectAtIndex:0];
        }
    }
    
    for (NSMutableArray*row in self.matrix) {
        UIView*right = [row lastObject];
        while (CGRectGetMinX(right.frame) > self.bounds.size.width+self.elementSize.width*TAIL_MULTIPLIER) {
            [self removeSubview:right];
            [row removeObject:right];
            right = [row lastObject];
        }
    }
    
    for (int r = 0; r < self.matrix.count; r++) {
        NSMutableArray*row = [self.matrix objectAtIndex:r];
        UIView*left = [row objectAtIndex:0];
        while (CGRectGetMinX(left.frame) > 0 - self.elementSize.width) 
        {
            if (row == topRow) {
                [self matrixMoveDown:0 right:-1];
            }
            UIView*item = [self getElementFromDataSourceForRow:r column:0];
            [self addSubview:item atMatrixRow:r atMatrixCol:0 withAnchor:left.frame.origin onPosR:r onPosC:1];
            [row insertObject:item atIndex:0];
            left = item;
        }
    }
    for (int r = 0; r < self.matrix.count; r++) {
        NSMutableArray*row = [self.matrix objectAtIndex:r];
        UIView*right = [row lastObject];
        while (CGRectGetMaxX(right.frame) < self.bounds.size.width + self.elementSize.width) 
        {
            UIView*item = [self getElementFromDataSourceForRow:r column:row.count];
            [self addSubview:item atMatrixRow:r atMatrixCol:row.count withAnchor:right.frame.origin onPosR:r onPosC:row.count - 1];
            [row addObject:item];
            right = item;
        }
    }
}
-(void)addSubview:(UIView*)vw atMatrixRow:(int)posY atMatrixCol:(int)posX withAnchor:(CGPoint)a onPosR:(int)aposY onPosC:(int)aposX
{
    CGPoint origin = CGPointZero;
    origin.x = a.x + (posX - aposX)*self.elementSize.width;
    origin.y = a.y + (posY - aposY)*self.elementSize.height;
    vw.frame = CGRectMake(origin.x, origin.y, self.elementSize.width, self.elementSize.height);
    [self addSubview:vw];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self reloadDataChangeDimensions];
}
-(void)setElementSize:(CGSize)elementSize
{
    _elementSize = elementSize;
    [self reloadDataChangeDimensions];
}
-(void)setDataSource:(id<EndlessScrollerDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadDataForceCleanup:YES];
}
-(void)removeSubview:(UIView*)sub
{
    [sub removeFromSuperview];
    [self.reusableElements addObject:sub];
}
-(UIView*)getReusedElement
{
    UIView*element = self.reusableElements.anyObject;
    if (element) {
        [self.reusableElements removeObject:element];
    }
    return element;
}
-(void)moveElementsTo:(CGPoint)offset touchPosition:(CGPoint)touch
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scroller:shouldMoveTo:touchPosition:)]) {
        offset = [self.delegate scroller:self shouldMoveTo:offset touchPosition:touch];
    }
    for (UIView*element in self.subviews) {
        element.frame = CGRectOffset(element.frame, offset.x, offset.y);
    }
    [self moveMatrix];
}
-(void)performAutoScroll:(NSTimer*)t
{
    CGPoint offset = CGPointMake(self.velocity.x*t.timeInterval, self.velocity.y*t.timeInterval);
    [self moveElementsTo:offset touchPosition:self.touchStart];
    CGFloat newXVelocity = self.velocity.x + self.acceleration.x*t.timeInterval;
    if (newXVelocity*self.velocity.x<=0) {
        newXVelocity = 0;
    }
    CGFloat newYVelocity = self.velocity.y + self.acceleration.y*t.timeInterval;
    if (newYVelocity*self.velocity.y<=0) {
        newYVelocity = 0;
    }
        self.velocity = CGPointMake(newXVelocity, newYVelocity);
    if (CGPointEqualToPoint(self.velocity, CGPointZero)) {
        [self cleanupTail];
        [self.timer invalidate];
        self.timer = nil;
        if ([self.delegate respondsToSelector:@selector(scrollerDidStop:)]) {
            [self.delegate scrollerDidStop:self];
        }
    }
}
-(void)pan:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.timer invalidate];
        self.timer = nil;
        self.touchStart = [recognizer locationInView:self];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded || 
        recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint offset = [recognizer translationInView:self];
        [self moveElementsTo:offset touchPosition:self.touchStart];
        [recognizer setTranslation:CGPointZero inView:self];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.velocity = CGPointZero;
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(scroller:shouldContinueMovingWithVelocity:)]) {
                self.velocity = [self.delegate scroller:self shouldContinueMovingWithVelocity:[recognizer velocityInView:self]];
            }
        }
        if (!CGPointEqualToPoint(self.velocity, CGPointZero)) {
            if ([self.delegate respondsToSelector:@selector(scroller:accelerationForVelocity:)]) {
                self.acceleration = [self.delegate scroller:self accelerationForVelocity:self.velocity];
            }
            else {
                self.acceleration = CGPointMake(-self.velocity.x, -self.velocity.y);
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(performAutoScroll:) userInfo:nil repeats:YES];
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(scrollerDidStop:)]) {
                [self.delegate scrollerDidStop:self];
            }
        }
    }
}
-(void)tap:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.timer invalidate];
        self.timer = nil;
        if ([self.delegate respondsToSelector:@selector(scrollerDidStop:)]) {
            [self.delegate scrollerDidStop:self];
        }
        if ([self.delegate respondsToSelector:@selector(scroller:didSelectItem:atIndex:)]) {
            CGPoint point = [recognizer locationInView:self];
            for (int r = 0; r < self.matrix.count; r++) {
                NSArray*row = [self.matrix objectAtIndex:r];
                for (int c = 0; c < row.count; c++) {
                    EndlessScroller*item = [row objectAtIndex:c];
                    if (CGRectContainsPoint(item.frame, point)) {
                        int index = [self getDataSourceIndexForItemAtRow:r column:c];
                        [self.delegate scroller:self didSelectItem:item atIndex:index];
                        return;
                    }
                    else {
                        if (CGRectGetMinY(item.frame) > point.y ||
                            CGRectGetMaxY(item.frame) < point.y) {
                            break;
                        }
                    }
                }
            }
        }
    }
}
-(void)setup
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
}
- (void)awakeFromNib
{
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)makeItemsPerformSelector:(SEL)selector
{
    [self.subviews makeObjectsPerformSelector:selector];
}
-(void)stopAutoScroll
{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    self.delegate = nil;
    self.dataSource = nil;
}
@end
