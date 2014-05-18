//
//  SWPlaylistDetailsViewController.m
//  SecondWind
//
//  Created by Momus on 18.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlaylistDetailsViewController.h"

#import "SWTrackCell.h"

@interface SWPlaylistDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *tracksArray;

@property (nonatomic, strong) NSString *playListName;

@end

@implementation SWPlaylistDetailsViewController

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
    
    self.playListName = [self.playList valueForProperty:MPMediaPlaylistPropertyName];
    self.tracksArray = [[SWMediaLibraryProvider sharedMediaManager] getAllMediaWithPlayList:self.playListName];
    
    self.labelPlaylistName.text = self.playListName;
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
    SWTrackCell *cell = [self.tracksCollectionView dequeueReusableCellWithReuseIdentifier:@"PlaylistDetailCellReuseIdentifier" forIndexPath:indexPath];
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

- (IBAction)barItemEditAction:(UIBarButtonItem *)sender {
}

- (IBAction)abrItemShuffleAction:(UIBarButtonItem *)sender {
}

- (IBAction)barItemAddAction:(UIBarButtonItem *)sender {
}
@end
