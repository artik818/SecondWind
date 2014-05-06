//
//  SWTracksViewController.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWTracksViewController.h"
#import "SWTrackCell.h"
#import "SWHintCell.h"
#import "SWPlayerViewController.h"

#import "SWMediaLibraryProvider.h"

#import <MediaPlayer/MediaPlayer.h>

@interface SWTracksViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarDelegate>

@property (nonatomic, strong) NSArray *tracksArray;

@end

@implementation SWTracksViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tracksArray = [[SWMediaLibraryProvider sharedMediaManager] getAllMedia];
    
    [SWMediaLibraryProvider sharedMediaManager];
    
    
//    [SWPlayerViewController new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.topTabBar setSelectedItemIndex:kTabBarIndex_Tracks animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
        cell = [self.tracksCollectionView dequeueReusableCellWithReuseIdentifier:@"HintCellReuseIdentifier" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor redColor];
    } else {
        MPMediaItem *song = self.tracksArray[indexPath.row - 1];
        cell = [self.tracksCollectionView dequeueReusableCellWithReuseIdentifier:@"TrackCellReuseIdentifier" forIndexPath:indexPath];
        [(SWTrackCell *)cell setTrack:song];
        [(SWTrackCell *)cell setTrackQuality:TrackQualityNone];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tracksArray.count + 1;
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
