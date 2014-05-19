//
//  SWArtistDetailHeader.h
//  SecondWind
//
//  Created by Momus on 19.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SWArtistDetailHeaderDelegate <NSObject>

- (void)shuffleButtonAction:(UIButton *)sender;

@end

@interface SWArtistDetailHeader : UICollectionReusableView

@property (nonatomic, weak) id<SWArtistDetailHeaderDelegate> delegate;
@property (nonatomic, strong, readonly) MPMediaItemCollection *currentAlbum;
@property (weak, nonatomic) IBOutlet UILabel *labelAlbumName;
@property (weak, nonatomic) IBOutlet UILabel *labelDuraton;

- (void)setAlbum:(MPMediaItemCollection *)album;

- (IBAction)shuffleButtonAction:(UIButton *)sender;

@end
