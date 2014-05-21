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
        
        NSString *dir = [self cachesDir];
        //    singasteinn::SingasteinnEngine eng("cache");
        //    singasteinn::SongAnalysisService sa;
        //    eng.getFittingController()->setFittingMode(singasteinn::IFittingController::FM_ConstTempoFit);
        //    eng.getFittingController()->setConstBeatInterval(0.4);
        const char *url = [dir cStringUsingEncoding:NSUTF8StringEncoding];
        engine = new SingasteinnEngine(url);
        engine->initializeLogging();
        
//        [self processMediaLibrary];
    }
    return self;
}

- (NSString *)cachesDir {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bmtPath = [cachesPath stringByAppendingPathComponent:@"BMTSystemCache"];
    BOOL isDir = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:bmtPath isDirectory:&isDir];
    if (exists && !isDir){
        [[NSFileManager defaultManager] removeItemAtPath:bmtPath error:nil];
        exists = NO;
    }
    if (!exists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:bmtPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return bmtPath;
}

- (void)processMediaLibrary {
    __block SongAnalysisService sa;
    NSArray *asserts = [[SWMediaLibraryProvider sharedMediaManager] getAllMedia];
    
    dispatch_queue_t processQueue = dispatch_queue_create("Process Queue",NULL);
    
    for (MPMediaItem *sng in asserts) {
        dispatch_async(processQueue, ^{

            NSURL *assetURL = [sng valueForProperty:MPMediaItemPropertyAssetURL];
            NSLog (@"%@", [assetURL absoluteString]);
            NSString *urls = [assetURL absoluteString];
            const char *url = [urls cStringUsingEncoding:NSASCIIStringEncoding];
            Song::Ptr song(new Song(url));
            
            sa.processSongSync(song);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
            });
            
        }); 
    }
//    IPlaybackController * mController = engine ->getPlaybackController();
//        mController->switchToSong(song);
//        mController->setPlaybackState(singasteinn::IPlaybackController::PS_Playing);
//        eng.getFittingController()->setFittingMode(singasteinn::IFittingController::FM_ConstTempoFit);
//    eng.getFittingController()->setConstBeatInterval(0.4);
}




@end
