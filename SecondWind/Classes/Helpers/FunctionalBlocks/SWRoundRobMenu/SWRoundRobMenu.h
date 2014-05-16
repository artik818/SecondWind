//
//  SWRoundRobMenu.h
//  SecondWind
//
//  Created by Artem on 5/7/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>



@class SWRoundRobMenu;

@protocol SWRoundRobMenuDatasource <NSObject>

- (NSInteger)roundRobMenuNumberOfItems:(SWRoundRobMenu *)roundRobMenu;
- (UIView *)roundRobMenu:(SWRoundRobMenu *)roundRobMenu viewForItemWithIndex:(NSInteger)itemIndex;

@end



@interface SWRoundRobMenu : UIView

@property (nonatomic, weak) id<SWRoundRobMenuDatasource> datasource;

- (void)setupWithStartIndex:(NSInteger)startViewIndex distanceBetweenCenters:(CGFloat)distanceBetweenCenters;

@end
