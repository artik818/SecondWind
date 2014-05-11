//
//  SWGlobalConsts.h
//  SecondWind
//
//  Created by Momotov Vladimir on 05.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#ifndef SecondWind_SWGlobalConsts_h
#define SecondWind_SWGlobalConsts_h

#define kTabBarIndex_Tracks     0
#define kTabBarIndex_Playlists	1
#define kTabBarIndex_Hints      2
#define kTabBarIndex_Albums		3
#define kTabBarIndex_Artists	4

typedef NS_ENUM(NSUInteger, TrackQuality)
{
    TrackQualityNone,
    TrackQualityBad,
    TrackQualitySlow,
    TrackQualityMiddle,
    TrackQualityFast,
    TrackQualityMax,
};


#pragma mark - KVO

#define ARTIST_ALBUMS_COUNT_KEY @"albumsCount"
#define ARTISTITEM_KEY          @"artistItem"
#define ARTIST_ARTWORK_KEY      @"artistArtwork"

#define ALBUMITEM_KEY           @"albumItem"
#define ALBUM_DURATION_KEY      @"albumDuration"

#endif