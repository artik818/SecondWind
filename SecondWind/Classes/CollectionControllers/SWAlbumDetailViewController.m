//
//  SWAlbumDetailViewController.m
//  SecondWind
//
//  Created by Momus on 17.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWAlbumDetailViewController.h"

#import "SWAlbumTrackCell.h"

@interface SWAlbumDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *tracksArray;
@property (nonatomic, strong) NSString *albumName;

@end

@implementation SWAlbumDetailViewController

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
    
    MPMediaItemCollection *itm = self.album[ALBUMITEM_KEY];
    self.albumName = [[itm representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString *songArtist = [[itm representativeItem] valueForProperty:MPMediaItemPropertyAlbumArtist];
    self.labelArtistName.text = songArtist;
    self.labelAlbumName.text = self.albumName;
    
    NSUInteger tracksCount = [[itm items] count];
    NSTimeInterval durTime = [self.album[ALBUM_DURATION_KEY] doubleValue];
    NSString *duration = [[SWGlobalDataSingleton globalDataManager] stringFromTimeInterval:durTime];
    
    NSString *trackCountString = [NSString stringWithFormat:@"%lu %@", (unsigned long)tracksCount, NSLocalizedString(@"tracksTitle", nil)];
    if (tracksCount == 1) {
        trackCountString = [NSString stringWithFormat:@"%lu %@", (unsigned long)tracksCount, NSLocalizedString(@"trackTitle", nil)];
    }
    self.labelAlbumDuration.text = [NSString stringWithFormat:@"%@, %@", trackCountString, duration];
    
    self.tracksArray = [[SWMediaLibraryProvider sharedMediaManager] getAllMediaWithAlbum:self.albumName];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [collectionView.collectionViewLayout invalidateLayout];
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPMediaItem *track = self.tracksArray[indexPath.row];
    SWAlbumTrackCell *cell = [self.albumTracksCollectionView dequeueReusableCellWithReuseIdentifier:@"AlbumDetailCellReuseIdentifier" forIndexPath:indexPath];
    [cell setTrack:track];
    [cell setTrackQuality:TrackQualityNone];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tracksArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
//
//    if (kind == UICollectionElementKindSectionHeader) {
//        SWSearchHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TracksCollectionViewHeaderReuseIdentifier" forIndexPath:indexPath];
//        reusableview = headerView;
//    }
//    
//    if (kind == UICollectionElementKindSectionFooter) {
//    }
//    
    return reusableview;
}

#pragma mark - UICollectionViewDelegate


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
