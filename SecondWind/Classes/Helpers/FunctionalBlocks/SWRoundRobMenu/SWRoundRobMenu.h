//
//  SWRoundRobMenu.h
//  SecondWind
//
//  Created by Artem on 5/7/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SWRoundRobMenu : UIView

@property (nonatomic) CGFloat distanceBetweenCenters;

- (void)setupWithViews:(NSArray *)viewsArray startIndex:(NSInteger)startViewIndex;

@end
