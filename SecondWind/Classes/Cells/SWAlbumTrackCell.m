//
//  SWAlbumTrackCell.m
//  SecondWind
//
//  Created by Momus on 18.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWAlbumTrackCell.h"


@implementation SWAlbumTrackCell

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
    NSNumber *songLength = [track valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    self.trackName.text = songTitle;
    self.trackDuration.text = [[SWGlobalDataSingleton globalDataManager] stringFromTimeInterval:[songLength integerValue]];
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
    self.trackImage.image = qualityImage;
}

@end
