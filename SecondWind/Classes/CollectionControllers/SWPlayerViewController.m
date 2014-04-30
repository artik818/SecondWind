//
//  SWPlayerViewController.m
//  SecondWind
//
//  Created by Artem on 4/30/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlayerViewController.h"
#import "SWPlayerMenuObject.h"
#import "SWPlayerMenuItem.h"



@interface SWPlayerViewController ()

@property (nonatomic, strong) SWPlayerMenuObject *playerMenuObject;

@end



@implementation SWPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Designated
        [self viewDidLoad];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.playerMenuObject = [SWPlayerMenuObject new];
    NSMutableArray *menuArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    SWPlayerMenuItem *menuItem;
    
    menuItem = [SWPlayerMenuItem new];
    menuItem.type = PlayerMenuItemTypeNoEffect;
    [menuArray addObject:menuItem];
    
    menuItem = [SWPlayerMenuItem new];
    menuItem.type = PlayerMenuItemTypeAuto;
    [menuArray addObject:menuItem];
    
    menuItem = [SWPlayerMenuItem new];
    menuItem.type = PlayerMenuItemTypeFixed;
    [menuArray addObject:menuItem];
    
    menuItem = [SWPlayerMenuItem new];
    menuItem.type = PlayerMenuItemTypeFixed;
    [menuArray addObject:menuItem];
    
    menuItem = [SWPlayerMenuItem new];
    menuItem.type = PlayerMenuItemTypeFixed;
    [menuArray addObject:menuItem];
    
    [self.playerMenuObject setupWithItems:menuArray];
    
    [self.playerMenuObject moveUpItemFor:11];
}


@end
