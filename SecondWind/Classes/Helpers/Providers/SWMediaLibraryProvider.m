//
//  SWMediaLibraryProvider.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWMediaLibraryProvider.h"
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

- (NSArray *)getAlbums {
    NSMutableArray *resArray = [NSMutableArray array];
    
    MPMediaQuery *query = [MPMediaQuery albumsQuery];
    NSArray *albums = [query collections];
    
    for (MPMediaItemCollection *album in albums) {
//        MPMediaItem *representativeItem = [album representativeItem];
//        NSString *artistName = [representativeItem valueForProperty: MPMediaItemPropertyArtist];
//        NSString *albumName = [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];

        NSArray *songs = [album items];
        NSNumber *addLength = nil;
        NSNumber *addLengthNew = nil;
        for (MPMediaItem *song in songs) {
            if (!addLength) {
                addLength = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
            } else {
                addLengthNew = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
                addLength = [NSNumber numberWithFloat:([addLength floatValue] + [addLengthNew floatValue])];
            }
        }
        NSMutableDictionary *albumsDictionary = [NSMutableDictionary dictionary];
        
        [albumsDictionary setValue:album forKey:ALBUMITEM_KEY];
        [albumsDictionary setValue:addLength forKey:ALBUM_DURATION_KEY];
        [resArray addObject:albumsDictionary];
    }
    return resArray;
}

- (NSArray *)getPlaylists {
    MPMediaQuery *query = [MPMediaQuery playlistsQuery];
    
    NSArray *playlists = [query collections];
    for (MPMediaItemCollection *album in playlists) {
        MPMediaItem *representativeItem = [album representativeItem];
        NSString *artistName = [representativeItem valueForProperty: MPMediaItemPropertyArtist];
        NSString *albumName = [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
        NSLog (@"%@ by %@", albumName, artistName);
        
        NSArray *songs = [album items];
        for (MPMediaItem *song in songs) {
            NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
            NSLog (@"\t\t%@", songTitle);
        }
    }
    
    return playlists;
}

- (NSArray *)getArtists {
    NSMutableArray *resArray = [NSMutableArray array];;
    
    MPMediaQuery *artistQuery = [MPMediaQuery artistsQuery];
    NSArray *songsByArtist = [artistQuery collections];
    NSMutableSet *tempSet = [NSMutableSet set];
    
    [songsByArtist enumerateObjectsUsingBlock:^(MPMediaItemCollection *artistCollection, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *artistDictionary = [NSMutableDictionary dictionary];
        __block MPMediaItemArtwork *artwork = nil;
        [[artistCollection items] enumerateObjectsUsingBlock:^(MPMediaItem *songItem, NSUInteger idx, BOOL *stop) {
            NSString *albumName = [songItem valueForProperty:MPMediaItemPropertyAlbumTitle];
            if (!artwork) {
                artwork = [songItem valueForProperty:MPMediaItemPropertyArtwork];
                BOOL hasArtwork = (artwork.bounds.size.width > 0 && artwork.bounds.size.height > 0);
                if (!hasArtwork) {
                    artwork = nil;
                }
            }
            [tempSet addObject:albumName];
        }];
        [artistDictionary setValue:[NSNumber numberWithUnsignedInteger:[tempSet count]] forKey:ARTIST_ALBUMS_COUNT_KEY];
        [artistDictionary setValue:artistCollection forKey:ARTISTITEM_KEY];
        [artistDictionary setValue:artwork forKey:ARTIST_ARTWORK_KEY];
        [resArray addObject:artistDictionary];
        [tempSet removeAllObjects];
    }];
    return resArray;
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

- (UIImage *)getArtworkForMediaitem:(MPMediaItem *)mediaItem withSie:(CGSize)imageSize {
    MPMediaItemArtwork *artwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize:imageSize];
    
    return artworkImage;
}

@end
