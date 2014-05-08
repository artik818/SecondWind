//
//  SWAlbumsViewController.h
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

@import UIKit;
#import "SWTopTabBar.h"

@interface SWAlbumsViewController : UIViewController

@property (weak, nonatomic) IBOutlet SWTopTabBar *topTabBar;
@property (weak, nonatomic) IBOutlet UICollectionView *albumsCollectionView;

@end
