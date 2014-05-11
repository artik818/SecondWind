//
//  SWAlbumCell.h
//  SecondWind
//
//  Created by Momotov Vladimir on 08.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWBaseCell.h"

@interface SWAlbumCell : SWBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *imageArtWork;
@property (weak, nonatomic) IBOutlet UILabel *labelAlbumName;
@property (weak, nonatomic) IBOutlet UILabel *labelAlbumArtist;
@property (weak, nonatomic) IBOutlet UILabel *labelDuration;

@property (weak, nonatomic) IBOutlet UIButton *buttonShuffle;

- (void)setAlbum:(NSDictionary *)albumDict;

@end
