//
//  EndlessScroller.h
//  MUIControls
//
//  Created by Kozharin on 18.06.12.
//  Copyright (c) 2012 iCupid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EndlessScroller;
@protocol EndlessScrollerDataSource <NSObject>
@required
-(NSUInteger)elementsCount;
-(UIView*)scroller:(EndlessScroller*)sender elementAtIndex:(int)index;
@end

@protocol EndlessScrollerDelegate <NSObject>
@optional
-(CGPoint)scroller:(EndlessScroller*)sender shouldMoveTo:(CGPoint)point touchPosition:(CGPoint)touch;
-(CGPoint)scroller:(EndlessScroller*)sender shouldContinueMovingWithVelocity:(CGPoint)velocity;
-(CGPoint)scroller:(EndlessScroller*)sender accelerationForVelocity:(CGPoint)velocity;
-(void)scroller:(EndlessScroller*)sender didSelectItem:(UIView*)item atIndex:(int)indexInDataSource;
-(void)scrollerDidStop:(EndlessScroller*)sender;
@end

@interface EndlessScroller : UIView

@property (assign, nonatomic) IBOutlet id<EndlessScrollerDataSource> dataSource;
@property (assign, nonatomic) IBOutlet id<EndlessScrollerDelegate> delegate;
@property (assign, nonatomic) CGSize elementSize;

-(UIView*)getReusedElement;
-(void)reloadDataForceCleanup:(BOOL)cleanup;
-(void)stopAutoScroll;
-(void)makeItemsPerformSelector:(SEL)selector;
@end
