//
//  CoreDataManager.h
//  localsgowild
//
//  Created by Boroday on 22.04.13.
//  Copyright (c) 2013 massinteractiveserviceslimited. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "UserData.h"

@interface SWCoreDataManager : NSObject

+ (SWCoreDataManager*)coreDataManager;
- (void)saveChangesAndWait:(BOOL)wait;
- (void)removeObjectFromCoreData:(id)object;
- (NSManagedObject *)getObjectInMainContextWithObject:(NSManagedObject *)objectInTemporaryContext;


#pragma mark - FetchRequests 

- (UserData *)findOrCreateUserData;

@end
