//
//  SWPlayerViewController.m
//  SecondWind
//
//  Created by Artem on 4/30/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlayerViewController.h"
#import "SWPlayerView.h"
#import "SWPlayerMenuItemView.h"
#import "SWRoundRobMenu.h"
#import "SWPlayerRoundedView.h"


@interface SWPlayerViewController () <SWRoundRobMenuDatasource>

@property (weak, nonatomic) IBOutlet SWPlayerView *playerView;
@property (nonatomic, weak) SWRoundRobMenu *roundRobMenu;

@end



@implementation SWPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Designated
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRoundRobMenu];
}



- (void)setupRoundRobMenu
{
    SWRoundRobMenu *roundRobMenu = [[SWRoundRobMenu alloc] initWithFrame:self.playerView.frame];
    roundRobMenu.backgroundColor = [UIColor lightGrayColor];
    self.roundRobMenu = roundRobMenu;
    [self.playerView addSubview:roundRobMenu];
    
    self.roundRobMenu.datasource = self;
    [self.roundRobMenu setupWithStartIndex:0 distanceBetweenCenters:290];
}


#pragma mark - SWRoundRobMenuDatasource

- (NSInteger)roundRobMenuNumberOfItems:(SWRoundRobMenu *)roundRobMenu
{
    return 3;
}

- (UIView *)roundRobMenu:(SWRoundRobMenu *)roundRobMenu viewForItemWithIndex:(NSInteger)itemIndex
{
    SWPlayerRoundedView *view = [[SWPlayerRoundedView alloc] initWithFrame:CGRectMake(0, 0, 270.0f, 270.0f)];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = [NSString stringWithFormat:@"%lu", (unsigned long)itemIndex];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:50];
    [view addSubview:label];
    return view;
}

- (UIImage *)roundRobMenu:(SWRoundRobMenu *)roundRobMenu backroundImageForItemWithIndex:(NSInteger)itemIndex
{
    UIImage *retVal = nil;
    switch (itemIndex) {
        case 0:
            retVal = [UIImage imageNamed:@"bg_player_auto"];
            break;
            
        case 1:
            retVal = [UIImage imageNamed:@"bg_player_fix"];
            break;
            
        case 2:
            retVal = [UIImage imageNamed:@"bg_player_no"];
            break;
            
        default:
            break;
    }
    
    return retVal;
}

@end
