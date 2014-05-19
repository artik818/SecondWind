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

- (NSArray *)getAllMediaWithAlbum:(NSString *)albumName;
- (NSArray *)getAllMediaWithPlayList:(NSString *)playlistName;
- (NSArray *)getAllMediaWithArtist:(NSString *)artistName;

- (UIImage *)getArtworkForMediaitem:(MPMediaItem *)mediaItem withSize:(CGSize)imageSize;
- (NSNumber *)getAlbumDurationTimeInterval:(MPMediaItemCollection *)album;

@end
