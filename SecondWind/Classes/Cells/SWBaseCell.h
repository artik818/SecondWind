//
//  SWBaseCell.h
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface SWBaseCell : UICollectionViewCell

@property (strong, nonatomic, readonly) MPMediaItem *mediaItem;
@property (nonatomic, readonly) TrackQuality trackQuality;

- (void)setTrack:(MPMediaItem *)track;
- (void)setTrackQuality:(TrackQuality)trackQuality;

@end
