//
//  SWTrackCell.m
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWTrackCell.h"

@implementation SWTrackCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTrack:(MPMediaItem *)track {
    
    _mediaItem = track;
    
//    NSURL *assetURL = [track valueForProperty:MPMediaItemPropertyAssetURL];
    NSString *songTitle = [track valueForProperty:MPMediaItemPropertyTitle];
    NSString *songArtist = [track valueForProperty:MPMediaItemPropertyArtist];
    NSNumber *songLength = [track valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    self.labelName.text = songTitle;
    self.labelArtist.text = songArtist;
    self.labelLength.text = [NSString stringWithFormat:@"%@", songLength];
    
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
