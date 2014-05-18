//
//  SWAlbumsViewController.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWAlbumsViewController.h"
#import "SWAlbumDetailViewController.h"
#import "SWMediaLibraryProvider.h"

#import "SWAlbumCell.h"

#import "SWSearchHeader.h"

@interface SWAlbumsViewController () <UITabBarDelegate>

@property (nonatomic, strong) NSArray *albumsArray;

@end

@implementation SWAlbumsViewController

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
    
    self.albumsArray = [[SWMediaLibraryProvider sharedMediaManager] getAlbums];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    UITabBarItem *item = [self.topTabBar.items firstObject];
    [self.topTabBar setSelectedItemIndex:kTabBarIndex_Albums animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger selIndex = [tabBar.items indexOfObject:item];
    [self.tabBarController setSelectedIndex:selIndex];
}


#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [collectionView.collectionViewLayout invalidateLayout];
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *album = self.albumsArray[indexPath.row];
    SWAlbumCell *cell = [self.albumsCollectionView dequeueReusableCellWithReuseIdentifier:@"AlbumsCellReuseIdentifier" forIndexPath:indexPath];
    [cell setAlbum:album];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumsArray.count;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AlbumDetailsSeageway"]) {
        SWAlbumCell *cell = (SWAlbumCell *)sender;
        SWAlbumDetailViewController *vc = segue.destinationViewController;
        vc.album = cell.albumDict;
    }
}


@end
