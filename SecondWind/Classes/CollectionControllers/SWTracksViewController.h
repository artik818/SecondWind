//
//  SWTracksViewController.h
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWTopTabBar.h"

@interface SWTracksViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *tracksCollectionView;
@property (weak, nonatomic) IBOutlet SWTopTabBar *topTabBar;

@end
