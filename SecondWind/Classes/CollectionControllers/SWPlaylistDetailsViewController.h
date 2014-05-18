//
//  SWPlaylistDetailsViewController.h
//  SecondWind
//
//  Created by Momus on 18.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

@interface SWPlaylistDetailsViewController : UIViewController

@property (nonatomic, strong) MPMediaPlaylist *playList;

@property (weak, nonatomic) IBOutlet UILabel *labelPlaylistName;
@property (weak, nonatomic) IBOutlet UICollectionView *tracksCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barItemEdit;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barItemShuffle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barItemAdd;

- (IBAction)barItemEditAction:(UIBarButtonItem *)sender;
- (IBAction)abrItemShuffleAction:(UIBarButtonItem *)sender;
- (IBAction)barItemAddAction:(UIBarButtonItem *)sender;
@end
