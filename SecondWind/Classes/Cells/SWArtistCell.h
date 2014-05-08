//
//  SWArtistCell.h
//  SecondWind
//
//  Created by Momotov Vladimir on 08.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWBaseCell.h"

@interface SWArtistCell : SWBaseCell

@property (weak, nonatomic) IBOutlet UILabel *labelAlbumsCount;
@property (weak, nonatomic) IBOutlet UILabel *labelArtistName;
@property (weak, nonatomic) IBOutlet UILabel *labelSongsCount;

@property (weak, nonatomic) IBOutlet UIImageView *imageArtWork;

- (void)setArtist:(NSDictionary *)artist;

@end
