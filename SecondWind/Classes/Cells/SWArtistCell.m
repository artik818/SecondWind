//
//  SWArtistCell.m
//  SecondWind
//
//  Created by Momotov Vladimir on 08.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWArtistCell.h"
#import "SWMediaLibraryProvider.h"

@implementation SWArtistCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setArtist:(NSDictionary *)artist {
    NSInteger albumsCount = [artist[ARTIST_ALBUMS_COUNT_KEY] integerValue];
    MPMediaItemCollection *artistItem = artist[ARTISTITEM_KEY];
    
    MPMediaItem *representativeItem = [artistItem representativeItem];
    NSString *artistName = [representativeItem valueForProperty:MPMediaItemPropertyArtist];
    NSArray *songs = [artistItem items];
    
    self.labelArtistName.text = artistName;
    self.labelSongsCount.text = [NSString stringWithFormat:@"%@ %lu", NSLocalizedString(@"songsTitle", nil), (unsigned long)[songs count]];
    self.labelAlbumsCount.text = [NSString stringWithFormat:@"%@ %li", NSLocalizedString(@"albumsTitle", nil), (long)albumsCount];

    MPMediaItemArtwork *artwork = artist[ARTIST_ARTWORK_KEY];
    UIImage *artworkImage = [artwork imageWithSize:self.imageArtWork.frame.size];

    if (artworkImage) {
        self.imageArtWork.image = artworkImage;
    } else {
        self.imageArtWork.image = [UIImage imageNamed:@"artist_overlay"];
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
