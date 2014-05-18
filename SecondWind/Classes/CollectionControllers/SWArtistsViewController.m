//
//  SWArtistsViewController.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWArtistsViewController.h"
#import "SWArtistDetailsViewController.h"

#import "SWArtistCell.h"
#import "SWSearchHeader.h"

#import "SWMediaLibraryProvider.h"

@interface SWArtistsViewController () <UITabBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *artistsArray;

@end

@implementation SWArtistsViewController

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
    
    self.artistsArray = [[SWMediaLibraryProvider sharedMediaManager] getArtists];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.topTabBar setSelectedItemIndex:kTabBarIndex_Artists animated:YES];
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
    NSDictionary *artist = self.artistsArray[indexPath.row];
    SWArtistCell *cell = [self.artistsCollectionView dequeueReusableCellWithReuseIdentifier:@"ArtistCellReuseIdentifier" forIndexPath:indexPath];
    [cell setArtist:artist];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.artistsArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        SWSearchHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TracksCollectionViewHeaderReuseIdentifier" forIndexPath:indexPath];
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
    }
    
    return reusableview;
}

#pragma mark - UICollectionViewDelegate


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger selIndex = [tabBar.items indexOfObject:item];
    [self.tabBarController setSelectedIndex:selIndex];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SWArtistDetailsSegue"]) {
        SWArtistDetailsViewController *vc = (SWArtistDetailsViewController *)segue.destinationViewController;
        SWArtistCell *cell = (SWArtistCell *)sender;
        
        vc.currentArtist = cell.currentArtist;
    }
}


@end
