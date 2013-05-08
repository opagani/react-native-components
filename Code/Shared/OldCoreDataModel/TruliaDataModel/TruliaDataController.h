//
//  TruliaDataController.h
//  Trulia
//
//  Created by Bill Kunz on 5/29/10.
//  Copyright 2010 Trulia, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

__unused static NSString *TRULIA_DATA_STORE_FILE_NAME = @"TruliaDatastore.sqlite";

@interface TruliaDataController : NSObject {
    NSManagedObjectContext *mainContext;   
    NSManagedObjectContext *searchContext;   
    NSManagedObjectContext *syncContext;   
    
    NSManagedObjectModel *managedObjectModel; 
    NSPersistentStoreCoordinator *persistentStoreCoordinator;	
    
}

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *searchContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *syncContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark -
#pragma mark Lightweight singleton support

// Designated "initializer" - don't go instantiating these.
+ (TruliaDataController *)sharedController;
+ (void)cleanup;
+ (BOOL)persistentStoreExists;
+ (NSURL *)storeUrl;

- (void)migrateLegacyDataIfNeeded;

- (void)saveMainContext;
- (void)saveContext:(NSManagedObjectContext *)aContext;
- (NSManagedObjectContext *)newContext;

- (void)closeStore;
- (void)reduceMemoryUsage;

@end
