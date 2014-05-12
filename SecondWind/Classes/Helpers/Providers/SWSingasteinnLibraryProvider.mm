//
//  SWSingasteinnLibraryProvider.m
//  SecondWind
//
//  Created by Momus on 13.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWSingasteinnLibraryProvider.h"

#import "SWMediaLibraryProvider.h"

#include "SingasteinnEngine.h"
#include "interface/IFittingController.h"

using namespace singasteinn;

static SWSingasteinnLibraryProvider *sharedSingaManager = nil;
static SingasteinnEngine *engine = nil;

@interface SWSingasteinnLibraryProvider ()


@end


@implementation SWSingasteinnLibraryProvider

+ (SWSingasteinnLibraryProvider *)sharedSingaManager
{
	if (!sharedSingaManager) {
		sharedSingaManager = [SWSingasteinnLibraryProvider new];
	}
	
    return sharedSingaManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        engine = new SingasteinnEngine("");
        engine->initializeLogging();
        
        [self processMediaLibrary];
    }
    return self;
}

- (void)processMediaLibrary {
    SongAnalysisService sa;
    NSArray *asserts = [[SWMediaLibraryProvider sharedMediaManager] getAllMedia];
    for (MPMediaItem *sng in asserts) {
        NSURL *assetURL = [sng valueForProperty:MPMediaItemPropertyAssetURL];
        NSLog (@"%@", [assetURL absoluteString]);
        Song::Ptr song(new Song([[assetURL absoluteString] cStringUsingEncoding:NSUnicodeStringEncoding]));
        sa.processSongSync(song);
    }
    //        IPlaybackController * mController = engine ->getPlaybackController()
    //        mController->switchToSong(song);
    //        mController->setPlaybackState(singasteinn::IPlaybackController::PS_Playing);
    //        eng.getFittingController()->setFittingMode(singasteinn::IFittingController::FM_ConstTempoFit);
    //    eng.getFittingController()->setConstBeatInterval(0.4);
}




@end
