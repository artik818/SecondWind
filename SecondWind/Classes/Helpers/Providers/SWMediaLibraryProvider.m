//
//  SWMediaLibraryProvider.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWMediaLibraryProvider.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "SWCoreDataManager.h"

static SWMediaLibraryProvider *sharedMediaManager = nil;

@implementation SWMediaLibraryProvider


+ (SWMediaLibraryProvider *)sharedMediaManager
{
	if (!sharedMediaManager) {
		sharedMediaManager = [SWMediaLibraryProvider new];
	}
	
    return sharedMediaManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        UserData *user = [[SWCoreDataManager coreDataManager] findOrCreateUserData];
        
        NSDate *lastDate = user.lastMediaModifiedDate;
        NSDate *mlLastDate = [MPMediaLibrary defaultMediaLibrary].lastModifiedDate;
        
        if (lastDate < mlLastDate) {
            // TODO: update our cache and lib with new media items
            NSArray *am = [self getAllMedia];
        }
        
    }
    return self;
}

- (NSArray *)getAllMedia {
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
//    for (MPMediaItem *song in itemsFromGenericQuery) {
//        NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
//        NSLog (@"%@", [assetURL absoluteString]);
//        AVPlayerItem *avItem = [[AVPlayerItem alloc] initWithURL:assetURL];
//        NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
//        NSLog (@"%@", songTitle);
//    }
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
