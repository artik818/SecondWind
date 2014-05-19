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
    [super setTrack:track];
    
//    NSURL *assetURL = [track valueForProperty:MPMediaItemPropertyAssetURL];
    NSString *songTitle = [track valueForProperty:MPMediaItemPropertyTitle];
    NSString *songArtist = [track valueForProperty:MPMediaItemPropertyArtist];
    NSNumber *songLength = [track valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    self.labelName.text = songTitle;
    self.labelArtist.text = songArtist;
    self.labelLength.text = [[SWGlobalDataSingleton globalDataManager] stringFromTimeInterval:[songLength integerValue]];
    
}

- (void)setTrackQuality:(TrackQuality)trackQuality {
    [super setTrackQuality:trackQuality];
    
    NSString *imageName = @"track_new";
    
    switch (trackQuality) {
        case TrackQualityNone:
            break;
        case TrackQualityBad:
            imageName = @"track_bad";
            break;
        case TrackQualitySlow:
            imageName = @"track_slow";
            break;
        case TrackQualityMiddle:
            imageName = @"track_mid";
            break;
        case TrackQualityFast:
            imageName = @"track_fast";
            break;
        case TrackQualityMax:
            imageName = @"track_max";
            break;
        default:
            break;
    }
    UIImage *qualityImage = [UIImage imageNamed:imageName];
    self.imageTrackType.image = qualityImage;
    
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
