//
//  SWMediaLibraryProvider.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWMediaLibraryProvider.h"
#import <MediaPlayer/MediaPlayer.h>

static SWMediaLibraryProvider *globalMediaManager = nil;

@implementation SWMediaLibraryProvider


+ (SWMediaLibraryProvider *)globalDataManager
{
	if (!globalMediaManager) {
		globalMediaManager = [SWMediaLibraryProvider new];
	}
	
    return globalMediaManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (NSArray *)getAllMedia {
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    for (MPMediaItem *song in itemsFromGenericQuery) {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSLog (@"%@", songTitle);
    }
    
    return itemsFromGenericQuery;
}

- (NSArray *)getAllMediaWithArtist:(NSString *)artistName {
    MPMediaPropertyPredicate *artistNamePredicate = [MPMediaPropertyPredicate predicateWithValue:artistName
                                                                                     forProperty:MPMediaItemPropertyArtist];
    
    MPMediaQuery *myArtistQuery = [[MPMediaQuery alloc] init];
    [myArtistQuery addFilterPredicate:artistNamePredicate];
    
    NSArray *itemsFromArtistQuery = [myArtistQuery items];
    
    return itemsFromArtistQuery;
}

- (void)getComplex {
    
    MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: @"Sad the Joker"
                                     forProperty: MPMediaItemPropertyArtist];
    
    MPMediaPropertyPredicate *albumNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: @"Stair Tumbling"
                                     forProperty: MPMediaItemPropertyAlbumTitle];
    
    NSSet *predicates = [NSSet setWithObjects:artistNamePredicate, albumNamePredicate, nil];
    
    MPMediaQuery *specificQuery = [[MPMediaQuery alloc] initWithFilterPredicates:predicates];
    NSArray *itemsFromArtistQuery = [specificQuery items];
}

- (void)getArtworkForMediaitem:(MPMediaItem *)mediaItem withSie:(CGSize)imageSize {
    MPMediaItemArtwork *artwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize:imageSize];
}

@end
