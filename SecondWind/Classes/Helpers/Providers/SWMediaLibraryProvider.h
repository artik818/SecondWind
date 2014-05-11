//
//  SWMediaLibraryProvider.h
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWMediaLibraryProvider : NSObject

+ (SWMediaLibraryProvider *)sharedMediaManager;

- (NSArray *)getAllMedia;
- (NSArray *)getAlbums;
- (NSArray *)getPlaylists;
- (NSArray *)getArtists;

- (UIImage *)getArtworkForMediaitem:(MPMediaItem *)mediaItem withSie:(CGSize)imageSize;

@end
