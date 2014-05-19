//
//  SWAlbumCell.m
//  SecondWind
//
//  Created by Momotov Vladimir on 08.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWAlbumCell.h"

@implementation SWAlbumCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setAlbum:(NSDictionary *)albumDict {
    
    _albumDict = albumDict;
    
    MPMediaItemCollection *collIt = albumDict[ALBUMITEM_KEY];
    MPMediaItemArtwork *artwork = [[collIt representativeItem] valueForProperty:MPMediaItemPropertyArtwork];
    NSString *albumName = [[collIt representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString *artistName = [[collIt representativeItem] valueForProperty:MPMediaItemPropertyAlbumArtist];
    NSUInteger tracksCount = [[collIt items] count];

    NSTimeInterval durTime = [albumDict[ALBUM_DURATION_KEY] doubleValue];
    
    NSString *duration = [[SWGlobalDataSingleton globalDataManager] stringFromTimeInterval:durTime];
    
    self.labelAlbumName.text = albumName;
    self.labelAlbumArtist.text = artistName;

    NSString *trackCountString = [NSString stringWithFormat:@"%lu %@", (unsigned long)tracksCount, NSLocalizedString(@"tracksTitle", nil)];
    if (tracksCount == 1) {
        trackCountString = [NSString stringWithFormat:@"%lu %@", (unsigned long)tracksCount, NSLocalizedString(@"trackTitle", nil)];
    }
    
    self.labelDuration.text = [NSString stringWithFormat:@"%@, %@", trackCountString, duration];
    
    if ((artwork.bounds.size.width > 0) && (artwork.bounds.size.height > 0)) {
        self.imageArtWork.image = [artwork imageWithSize:self.imageArtWork.frame.size];
    } else {
        self.imageArtWork.image = [UIImage imageNamed:@"album_overlay"];
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
