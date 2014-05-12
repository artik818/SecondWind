//
//  SWPlaylistsViewController.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlaylistsViewController.h"

#import "SWMediaLibraryProvider.h"
#import "SWPlaylistCell.h"

@interface SWPlaylistsViewController () <UITabBarDelegate, UICollectionViewDataSource, UICollisionBehaviorDelegate>

@property (nonatomic, strong) NSArray *playlistsArray;

@end

@implementation SWPlaylistsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.opaque = NO;
//    self.navigationController.navigationBar.alpha = 0.0f;
    
    self.playlistsArray = [[SWMediaLibraryProvider sharedMediaManager] getPlaylists];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    UITabBarItem *item = [self.topTabBar.items firstObject];
    [self.topTabBar setSelectedItemIndex:kTabBarIndex_Playlists animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [collectionView.collectionViewLayout invalidateLayout];
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SWBaseCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [self.playlistsCollectionView dequeueReusableCellWithReuseIdentifier:@"HintCellReuseIdentifier" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor redColor];
    } else {
        MPMediaItemCollection *song = self.playlistsArray[indexPath.row - 1];
        cell = [self.playlistsCollectionView dequeueReusableCellWithReuseIdentifier:@"PlaylistCellReuseIdentifier" forIndexPath:indexPath];
        [(SWPlaylistCell *)cell setPlaylist:song];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.playlistsArray.count + 1;
}


#pragma mark - UICollectionViewDelegate

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger selIndex = [tabBar.items indexOfObject:item];
    [self.tabBarController setSelectedIndex:selIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
