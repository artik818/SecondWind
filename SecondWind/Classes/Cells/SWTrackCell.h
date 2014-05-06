//
//  SWTrackCell.h
//  SecondWind
//
//  Created by Momus on 27.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//


#import "SWBaseCell.h"

#import <MediaPlayer/MediaPlayer.h>

@interface SWTrackCell : SWBaseCell

@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelArtist;
@property (weak, nonatomic) IBOutlet UILabel *labelLength;

@property (weak, nonatomic) IBOutlet UIImageView *imageTrackType;
@property (weak, nonatomic) IBOutlet UIImageView *imageEdit;

@property (strong, nonatomic, readonly) MPMediaItem *mediaItem;

- (void)setTrack:(MPMediaItem *)track;

@end
