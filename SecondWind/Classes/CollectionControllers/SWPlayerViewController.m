//
//  SWPlayerViewController.m
//  SecondWind
//
//  Created by Artem on 4/30/14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlayerViewController.h"
//#import "SWRoundRob.h"
//#import "SWPlayerMenuItem.h"
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
    SWPlayerRoundedView *view = [[SWPlayerRoundedView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = [NSString stringWithFormat:@"%lu", (unsigned long)itemIndex];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:50];
    [view addSubview:label];
    return view;
}


/*
#pragma mark -

- (void)setupCarousel
{
    self.carousel = [[iCarousel alloc] initWithFrame:self.playerView.frame];
    [self.playerView addSubview:self.carousel];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    
    //configure carousel
    self.carousel.type = iCarouselTypeRotary;
    self.carousel.vertical = YES;
//    self.carousel.offsetMultiplier = 3;
    
//    @property (nonatomic, assign) BOOL stopAtItemBoundary;
//    @property (nonatomic, assign) BOOL scrollToItemBoundary;
//    @property (nonatomic, assign) BOOL ignorePerpendicularSwipes;
//    @property (nonatomic, assign) BOOL centerItemWhenSelected;

    //scroll to fixed offset
    [self.carousel scrollToItemAtIndex:5 animated:NO];
}





#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create a numbered view
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:50];
    [view addSubview:label];
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            return 1.8;
        }
        default:
        {
            return value;
        }
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
	NSLog(@"Carousel will begin dragging");
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
	NSLog(@"Carousel did end dragging and %@ decelerate", decelerate? @"will": @"won't");
}

- (void)carouselWillBeginDecelerating:(iCarousel *)carousel
{
	NSLog(@"Carousel will begin decelerating");
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
	NSLog(@"Carousel did end decelerating");
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
	NSLog(@"Carousel will begin scrolling");
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
	NSLog(@"Carousel did end scrolling");
}
*/



/*
- (void)setupMechanisms
{
    self.playerMenuObject = [SWRoundRobMenu new];
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
    
    [self.playerMenuObject setupWithItems:menuArray];
    
//    [self.playerMenuObject moveUpItemFor:12];
//    menuItem = [self.playerMenuObject currentItem];
}

- (void)setupSubViews
{
    self.playerMenuViewObject = [SWRoundRobMenu new];
    NSMutableArray *menuViewsArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    SWPlayerMenuItem *menuItem;
    SWPlayerMenuItemView *menuItemView;
    CGRect fr;
    
    menuItem = [self.playerMenuObject moveUpItemFor:0];
    fr = CGRectMake(10, 200, 100, 100);
    menuItemView = [[SWPlayerMenuItemView alloc] initWithFrame:fr menuItem:menuItem];
    menuItemView.backgroundColor = [UIColor greenColor];
    [self.playerView addSubview:menuItemView];
    [menuViewsArray addObject:menuItemView];
    
    menuItem = [self.playerMenuObject moveUpItemFor:1];
    fr = CGRectMake(10, 400, 100, 100);
    menuItemView = [[SWPlayerMenuItemView alloc] initWithFrame:fr menuItem:menuItem];
    menuItemView.backgroundColor = [UIColor greenColor];
    [self.playerView addSubview:menuItemView];
    [menuViewsArray addObject:menuItemView];
    
    menuItem = [self.playerMenuObject moveUpItemFor:2];
    fr = CGRectMake(10, 0, 100, 100);
    menuItemView = [[SWPlayerMenuItemView alloc] initWithFrame:fr menuItem:menuItem];
    menuItemView.backgroundColor = [UIColor greenColor];
    [self.playerView addSubview:menuItemView];
    [menuViewsArray addObject:menuItemView];
    
    [self.playerMenuViewObject setupWithItems:menuViewsArray];
}

- (void)setupGestures
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [self.playerView addGestureRecognizer:panGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer;
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureDetected:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.playerView addGestureRecognizer:swipeGestureRecognizer];

    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureDetected:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.playerView addGestureRecognizer:swipeGestureRecognizer];
}


#pragma mark - Utils
- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        [self moveViewsForYDelta:translation.y];
        NSLog(@"%@", NSStringFromCGPoint(translation));
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
}

- (void)swipeGestureDetected:(UISwipeGestureRecognizer *)recognizer
{
    UISwipeGestureRecognizerDirection direction = recognizer.direction;
    if (UISwipeGestureRecognizerDirectionUp == direction) {
        [self moveViewsForYDelta:-250];
    }
    if (UISwipeGestureRecognizerDirectionDown == direction) {
        [self moveViewsForYDelta:250];
    }
}

- (void)moveViewsForYDelta:(CGFloat)yDelta
{
    for (NSInteger i=0; i<[self.playerMenuViewObject itemsCount]; i++) {
        SWPlayerMenuItemView *menuItemView = [self.playerMenuViewObject moveUpItemFor:i];
        menuItemView.frame = CGRectOffset(menuItemView.frame, 0, yDelta);
    }
}
*/

@end
