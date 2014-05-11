//
//  SWPlaylistCell.h
//  SecondWind
//
//  Created by Momus on 08.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWBaseCell.h"

@interface SWPlaylistCell : SWBaseCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTracksCount;

@property (weak, nonatomic) IBOutlet UIImageView *imagePlay;

- (void)setPlaylist:(MPMediaItemCollection *)playlist;
@end
