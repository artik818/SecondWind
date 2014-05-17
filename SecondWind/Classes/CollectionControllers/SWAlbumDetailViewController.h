//
//  SWAlbumDetailViewController.h
//  SecondWind
//
//  Created by Momus on 17.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWAlbumDetailViewController : UIViewController

@property (nonatomic, strong) MPMediaItem *album;
@property (weak, nonatomic) IBOutlet UICollectionView *albumTracksCollectionView;

@end
