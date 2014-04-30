//
//  CoreDataManager.m
//  localsgowild
//
//  Created by Boroday on 22.04.13.
//  Copyright (c) 2013 massinteractiveserviceslimited. All rights reserved.
//

#import "SWCoreDataManager.h"

#define LocalDBFileName @"Model.sqlite"

@interface SWCoreDataManager ()
{
    NSPersistentStoreCoordinator*	_persistentStoreCoordinator;
    NSManagedObjectModel*			_managedObjectModel;
    NSManagedObjectContext*			_managedObjectContext;
    NSManagedObjectContext*			_privateContext;
}

@property NSInteger counter;

@end


@implementation SWCoreDataManager


+ (SWCoreDataManager *)coreDataManager
{
    static SWCoreDataManager *sharedCoreDataManager = nil;
    static dispatch_once_t onceToken;
	
    dispatch_once(&onceToken,
                  ^{
                      sharedCoreDataManager = [[SWCoreDataManager alloc] init];
                      [sharedCoreDataManager initializeCoreDataStack];
                  });
    
    return sharedCoreDataManager;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - New CoreData stack

- (void)initializeCoreDataStack
{
    // Managed Object Model
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
	NSAssert(modelURL, @"Failed to find model URL");
	
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	NSAssert(_managedObjectModel, @"Failed to initialize model");
	
	// Persistent Store Coordinator
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
	NSAssert(_persistentStoreCoordinator, @"Failed to initialize persistent store coordinator");
	
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:LocalDBFileName];
    
    [self initializePersistentStore:storeURL];
    [self initializeManagedContexts];
}

- (void)initializePersistentStore:(NSURL*)storeURL
{
	NSError* error = nil;
    NSPersistentStore* store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options: @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error];
    
    if(!store)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        
        NSString *databaseFile = [documentsDirectoryPath stringByAppendingPathComponent:LocalDBFileName];
        
        [fileManager removeItemAtPath:databaseFile error:&error];
        
        _persistentStoreCoordinator = nil;
        _managedObjectContext = nil;
        _privateContext = nil;
        
        [self initializeCoreDataStack];
    }
}

- (void)initializeManagedContexts
{
    
	_privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	NSAssert(_privateContext, @"Failed to initialize primary private context");
	[_privateContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
	
	_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	NSAssert(_managedObjectContext, @"Failed to initialize primary main queue context");
	[_managedObjectContext setParentContext:_privateContext];
}

- (void)removeObjectFromCoreData:(id)object
{
    [_managedObjectContext deleteObject:object];
}

#pragma mark - Common methods

- (void) resetPersistentStorage
{
    
	NSError* error = nil;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:LocalDBFileName];
	NSPersistentStore* p = [_persistentStoreCoordinator persistentStoreForURL:storeURL];
	if ([_persistentStoreCoordinator removePersistentStore:p error:&error]) {
		if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
			[[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
			if (error) {
				return;
			}
		}
	}
	
    if (error) {
        return;
    }
	
    _persistentStoreCoordinator = nil;
    _managedObjectContext = nil;
	_privateContext = nil;
	
    //
    // Rebuild the application's managed object context
    //
	[self initializeCoreDataStack];
}

- (void)saveChangesAndWait:(BOOL)wait
{
	if (!_managedObjectContext) return;
	
	if ([_managedObjectContext hasChanges])
	{
		[_managedObjectContext performBlockAndWait:^{
			NSError *error = nil;
            [_managedObjectContext save:&error];
			NSAssert(error==nil, @"Error saving MOC: %@\n%@",
                     [error localizedDescription], [error userInfo]);
		}];
	}
    __weak SWCoreDataManager *weakSelf = self;
	void (^savePrivate) (void) = ^{
		NSError *error = nil;
        [_privateContext save:&error];
		NSAssert(error==nil, @"Error saving private MOC: %@\n%@",
                 [error localizedDescription], [error userInfo]);
        weakSelf.counter--;
	};
	
	if ([_privateContext hasChanges])
	{
        self.counter++;
		if (wait) {
			[_privateContext performBlockAndWait:savePrivate];
		} else {
			[_privateContext performBlock:savePrivate];
		}
	}
}

- (NSManagedObject *)getObjectInMainContextWithObject:(NSManagedObject *)objectInTemporaryContext
{
    NSManagedObject* mainContextObject = [_managedObjectContext objectWithID:[objectInTemporaryContext objectID]];
    return mainContextObject;
}


#pragma mark - FetchRequests 


- (UserData *)findOrCreateUserData {

    UserData* userData;
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserData"];
    request.includesPendingChanges = YES;
    
	NSError *error = NULL;
	NSArray *userDataArray = [_managedObjectContext executeFetchRequest:request error:&error];
	if (!error) {
		if (userDataArray.count == 1) {
			userData = [userDataArray firstObject];
		}
        else {
            if (userDataArray.count > 1) {
                [userDataArray enumerateObjectsUsingBlock:^(UserData *curUserData, NSUInteger idx, BOOL *stop) {
                    [[SWCoreDataManager coreDataManager] removeObjectFromCoreData:curUserData];
                }];
            }
			userData = [self createUserData];
		}
	}
	return userData;
}

- (UserData *)createUserData {
    UserData* userData = (UserData *)[NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:_managedObjectContext];

    return userData;
}

@end
