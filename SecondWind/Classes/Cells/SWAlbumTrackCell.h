//
//  SWAlbumTrackCell.h
//  SecondWind
//
//  Created by Momus on 18.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWBaseCell.h"

@interface SWAlbumTrackCell : SWBaseCell

@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *trackDuration;

@property (weak, nonatomic) IBOutlet UIImageView *trackImage;


@end
