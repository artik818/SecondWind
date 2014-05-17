//
//  SWAlbumDetailViewController.h
//  SecondWind
//
//  Created by Momus on 17.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

@interface SWAlbumDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *album;
@property (weak, nonatomic) IBOutlet UICollectionView *albumTracksCollectionView;

@end
