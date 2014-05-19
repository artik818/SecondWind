//
//  SWArtistDetailHeader.m
//  SecondWind
//
//  Created by Momus on 19.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWArtistDetailHeader.h"

@implementation SWArtistDetailHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setAlbum:(MPMediaItemCollection *)album {
    _currentAlbum = album;
    
    NSString *albumName = [[album representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSUInteger tracksCount = [[album items] count];
    
    NSTimeInterval durTime = [[[SWMediaLibraryProvider sharedMediaManager] getAlbumDurationTimeInterval:album] doubleValue];
    
    NSString *duration = [[SWGlobalDataSingleton globalDataManager] stringFromTimeInterval:durTime];
    
    self.labelAlbumName.text = albumName;
    NSString *trackCountString = [NSString stringWithFormat:@"%lu %@", (unsigned long)tracksCount, NSLocalizedString(@"tracksTitle", nil)];
    if (tracksCount == 1) {
        trackCountString = [NSString stringWithFormat:@"%lu %@", (unsigned long)tracksCount, NSLocalizedString(@"trackTitle", nil)];
    }
    self.labelDuraton.text = [NSString stringWithFormat:@"%@, %@", trackCountString, duration];
}

- (IBAction)shuffleButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shuffleButtonAction:)]) {
        [self.delegate shuffleButtonAction:sender];
    }
}


@end
