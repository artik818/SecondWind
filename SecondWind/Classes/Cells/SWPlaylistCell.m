//
//  SWPlaylistCell.m
//  SecondWind
//
//  Created by Momus on 08.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWPlaylistCell.h"

@implementation SWPlaylistCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPlaylist:(MPMediaPlaylist *)playlist {
    
    _playList = playlist;
    
//    MPMediaItem *representativeItem = [playlist representativeItem];
    NSString *albumName = [playlist valueForProperty:MPMediaPlaylistPropertyName];
    NSArray *songs = [playlist items];
    
    self.labelName.text = albumName;
    if ([songs count] == 1) {
        self.labelTracksCount.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)[songs count], NSLocalizedString(@"trackTitle", nil)];
    } else {
        self.labelTracksCount.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)[songs count], NSLocalizedString(@"tracksTitle", nil)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
