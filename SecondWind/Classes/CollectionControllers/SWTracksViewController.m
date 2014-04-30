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

@interface SWTracksViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *tracksArray;

@end

@implementation SWTracksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tracksArray = [NSArray new];
    
    [SWMediaLibraryProvider sharedMediaManager];
    
    [self.tracksCollectionView registerClass:[SWTrackCell class] forCellWithReuseIdentifier:@"TrackCellReuseIdentifier"];
    [self.tracksCollectionView registerClass:[SWHintCell class] forCellWithReuseIdentifier:@"HintCellReuseIdentifier"];
    
//    [SWPlayerViewController new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGSize cellSize = CGSizeZero;
//    
//    
//    return cellSize;
//}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SWBaseCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HintCellReuseIdentifier" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TrackCellReuseIdentifier" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor greenColor];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tracksArray.count + 10;
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
