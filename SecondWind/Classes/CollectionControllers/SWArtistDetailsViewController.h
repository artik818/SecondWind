//
//  SWArtistDetailsViewController.h
//  SecondWind
//
//  Created by Momus on 18.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWArtistDetailsViewController : UIViewController

@property (nonatomic, strong) MPMediaItemCollection *currentArtist;

@property (weak, nonatomic) IBOutlet UILabel *labelArtistName;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UICollectionView *tracksCollectionView;
@end
