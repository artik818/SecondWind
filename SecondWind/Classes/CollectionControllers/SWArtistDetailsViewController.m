//
//  SWArtistDetailsViewController.m
//  SecondWind
//
//  Created by Momus on 18.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWArtistDetailsViewController.h"

#import "SWAlbumTrackCell.h"
#import "SWArtistDetailHeader.h"

@interface SWArtistDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SWArtistDetailHeaderDelegate>

@property (nonatomic, strong) NSArray *artistTracksArray;

@end

@implementation SWArtistDetailsViewController

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
    
    NSString *artistName = [[self.currentArtist representativeItem] valueForProperty:MPMediaItemPropertyArtist];
    self.artistTracksArray = [[SWMediaLibraryProvider sharedMediaManager] getAllMediaWithArtist:artistName];
    self.labelArtistName.text = artistName;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.artistTracksArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    MPMediaItemCollection *album = self.artistTracksArray[section];
    
    NSInteger cnt = [[album items] count];
    
    return cnt;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SWAlbumTrackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArtistDetailCellReuseIdentifier" forIndexPath:indexPath];
    
    MPMediaItemCollection *album = self.artistTracksArray[indexPath.section];
    MPMediaItem *track = [album items][indexPath.row];
    
    [cell setTrack:track];
    [cell setTrackQuality:TrackQualityNone];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SWArtistDetailHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SWArtistDetailHeaderReuseIdentifier" forIndexPath:indexPath];

        MPMediaItemCollection *album = self.artistTracksArray[indexPath.section];
        [headerView setAlbum:album];
        
        headerView.delegate = self;
        
        reusableview = headerView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
    }
    
    return reusableview;
}

#pragma mark - SWArtistDetailHeaderDelegate methods

- (void)shuffleButtonAction:(UIButton *)sender {
    
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
