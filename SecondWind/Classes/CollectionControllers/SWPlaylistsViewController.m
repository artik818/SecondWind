//
//  SWPlaylistsViewController.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlaylistsViewController.h"

#import "SWMediaLibraryProvider.h"

@interface SWPlaylistsViewController () <UITabBarDelegate>

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
