//
//  TruliaDataController.m
//  Trulia
//
//  Created by Bill Kunz on 5/29/10.
//  Copyright 2010 Trulia, Inc. All rights reserved.
//

#import "TruliaDataController.h"

#import "TruliaSearchParameters.h"
#import "TruliaBaseProperty.h"
#import "GRStorageManager.h"

@interface TruliaSearchParameters (PrivateCriteriaString)
// Normally any use of criteriaString should just be internal to the TruliaSearchParameters object, but we have to break that rule here while migrating from the pre-v3.5 SQLite database to the post-v3.5 Core Data store.
- (void)setSearchAttributesFromString:(NSString *)aCriteriaString;
@end


@interface TruliaDataController (Private)

- (void)releaseIvars;
+ (NSString *)applicationLibraryDirectory;

+ (NSString *)storeFileName;

- (void)migrateLegacySearches;
- (void)migrateLegacyProperties;

- (NSDictionary *)optionsForAutomaticLightweightMigration;
- (void)addStoreToCoordinatorWithoutMigrationChecks:(NSPersistentStoreCoordinator *)coordinator withOptions:(NSDictionary *)options;

@end

@implementation TruliaDataController

@synthesize mainContext, searchContext, syncContext;
@synthesize managedObjectModel, persistentStoreCoordinator;

static BOOL isInitialized = NO;
static TruliaDataController *sharedController = nil;

// We want to clear these both on dealloc and whenever the store is closed.
- (void)releaseIvars; {
	
    //Delete the persitence store when done.
    NSPersistentStore *persistentStore = [[[TruliaDataController sharedController] persistentStoreCoordinator] persistentStoreForURL:(NSURL *)[TruliaDataController storeUrl]];
    NSError *error = nil;
    
    [[[TruliaDataController sharedController] persistentStoreCoordinator] removePersistentStore:persistentStore error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:[TruliaDataController storeUrl].path error:&error];
    
    
    mainContext = nil;
    searchContext = nil;
    syncContext = nil;
	managedObjectModel = nil;
	persistentStoreCoordinator = nil;
    
}

- (void)dealloc; {
    [self closeStore];
    [self releaseIvars];
}

// This is a singleton, don't call this directly.
- (id)init {
	if (!isInitialized) {
		if ((self = [super init])) {
            mainContext = nil;
            searchContext = nil;
            syncContext = nil;
            isInitialized = YES;
		}
	}
    return self;
}

#pragma mark -
#pragma mark Lightweight singleton support

+ (TruliaDataController *)sharedController; {
    
    if (!sharedController) {
        sharedController = [[TruliaDataController alloc] init];
    }
    
    return sharedController;
}

+ (void)cleanup; {
    if (sharedController) {
        sharedController = nil;
    }
}

#pragma mark -
#pragma mark Migrating legacy data to the new datastore

- (void)migrateLegacyDataIfNeeded; {
    
    if ([GRStorageManager sqliteDatabaseExists]) {
        
        // Copy out old searches, raw, and save to CD as new searches
        [self migrateLegacySearches];
        
        // Copy out old properties, raw, and save to CD as new properties
        [self migrateLegacyProperties];
        
        [self saveMainContext];
        
        // Delete the old database
        [[GRStorageManager sharedInstance] closeDatabase];
        [GRStorageManager deleteDatabase];
        
    }
    
}

// Constants for working with the legacy SQLite database.
// Copied from GRStorageManager so we can delete that class later.
__unused static NSString *TRULIA_DATABASE_TABLE_PROPERTY							= @"property";
__unused static NSString *TRULIA_DATABASE_TABLE_SEARCH							= @"History";
__unused static NSString *TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP					= @"syncTimestamp";
__unused static NSString *TRULIA_DATABASE_COLUMN_IS_FAVORITE						= @"isFavorite";
__unused static NSString *TRULIA_DATABASE_COLUMN_IS_HISTORY						= @"isHistory";
__unused static NSString *TRULIA_DATABASE_COLUMN_TO_BE_UNFAVORITED				= @"toBeUnfavorited";
__unused static NSString *TRULIA_DATABASE_COLUMN_SAVED_TO_FAVORITES_TIMESTAMP	= @"savedToFavoritesTime";
__unused static NSString *TRULIA_DATABASE_COLUMN_UNSUPPORTED_PARAMETER_STRING	= @"unsupportedParameters";
__unused static NSString *TRULIA_DATABASE_COLUMN_SEARCH_HASH						= @"hashsrch";

- (void)migrateLegacySearches; {
    
    sqlite3 *database = [[GRStorageManager sharedInstance] _database];
    
    if (!database) {
        return;
    }
           
    sqlite3_stmt *fetchLegacySearchesStatement = nil;

    NSString *sql = [NSString stringWithFormat:@"SELECT criteria, historyId, timestamp, %@, %@, %@, %@, %@ FROM %@ ORDER BY timestamp;", TRULIA_DATABASE_COLUMN_UNSUPPORTED_PARAMETER_STRING, TRULIA_DATABASE_COLUMN_IS_FAVORITE, TRULIA_DATABASE_COLUMN_IS_HISTORY, TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP, TRULIA_DATABASE_COLUMN_SAVED_TO_FAVORITES_TIMESTAMP, TRULIA_DATABASE_TABLE_SEARCH];

    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &fetchLegacySearchesStatement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
	
	while (sqlite3_step(fetchLegacySearchesStatement) == SQLITE_ROW) {
        
        char *criteriaStr = (char *)sqlite3_column_text(fetchLegacySearchesStatement, 0);
        NSString *searchCriteriaString = (criteriaStr) ? [NSString stringWithUTF8String:criteriaStr] : nil;
        
        TruliaSearchParameters *newSearch = [[TruliaSearchParameters alloc] init]; /*= [TruliaSearchParameters insertedSearch]; */
        [newSearch setSearchAttributesFromString:searchCriteriaString];
        
        newSearch.searchId = [NSNumber numberWithInt:sqlite3_column_int(fetchLegacySearchesStatement, 1)];
        newSearch.searchDate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(fetchLegacySearchesStatement, 2)];
        // Dupe logged date as a separate object
        newSearch.loggedToHistoryDate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(fetchLegacySearchesStatement, 2)];
        
        char *unsupportedParamsStr = (char *)sqlite3_column_text(fetchLegacySearchesStatement, 3);
        if (unsupportedParamsStr) {
            newSearch.unsupportedParameters = [NSString stringWithUTF8String:unsupportedParamsStr];    
        }        
        
        newSearch.isFavorite = [NSNumber numberWithInt:(int)sqlite3_column_int(fetchLegacySearchesStatement, 4)];
        newSearch.isHistory = [NSNumber numberWithInt:(int)sqlite3_column_int(fetchLegacySearchesStatement, 5)];
//        [newSearch setIsForSale:YES];
        
        NSTimeInterval syncTimestamp = (NSTimeInterval)sqlite3_column_double(fetchLegacySearchesStatement, 6);
        
        if (syncTimestamp > 0.0f) {
            newSearch.syncDate = [NSDate dateWithTimeIntervalSince1970:syncTimestamp];
        }
        
        NSTimeInterval savedToFavoritesTimestamp = sqlite3_column_double(fetchLegacySearchesStatement, 7);
        
        if (savedToFavoritesTimestamp > 0.0f) {
            newSearch.savedToFavoritesDate = newSearch.isFavorite ? [NSDate dateWithTimeIntervalSince1970:savedToFavoritesTimestamp] : nil;
        }
                    
	}
	
	sqlite3_finalize(fetchLegacySearchesStatement);
    
}

- (void)migrateLegacyProperties; {
        
    sqlite3 *database = [[GRStorageManager sharedInstance] _database];
    
    if (!database) {
        return;
    }
    
    sqlite3_stmt *fetchLegacyPropertiesStatement = nil;

    NSString *sql = [NSString stringWithFormat:@"SELECT propertyId, address, picturePath, propertyType, latitude, longitude, numberOfBathrooms, numberOfBedrooms, squareFeet, price, %@, %@, %@, %@ FROM %@ ORDER BY timestamp DESC;", TRULIA_DATABASE_COLUMN_IS_FAVORITE, TRULIA_DATABASE_COLUMN_IS_HISTORY, TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP, TRULIA_DATABASE_COLUMN_SAVED_TO_FAVORITES_TIMESTAMP, TRULIA_DATABASE_TABLE_PROPERTY];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &fetchLegacyPropertiesStatement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }

	
	while (sqlite3_step(fetchLegacyPropertiesStatement) == SQLITE_ROW) {
                
        char *str;
		TruliaBaseProperty *newProperty = [[TruliaBaseProperty alloc] init]; 
//        = [TruliaBaseProperty propertyWithPropertyId:[NSNumber numberWithLongLong:sqlite3_column_int64(fetchLegacyPropertiesStatement, 0)]];
//        [newProperty setIsForSale:YES];
		
		str = (char *)sqlite3_column_text(fetchLegacyPropertiesStatement, 1);
		newProperty.address = (str) ? [NSString stringWithUTF8String:str] : @"";
        
		str = (char *)sqlite3_column_text(fetchLegacyPropertiesStatement, 2);
		newProperty.thumbnailUrl = (str) ? [NSString stringWithUTF8String:str] : @"";
        
		str = (char *)sqlite3_column_text(fetchLegacyPropertiesStatement, 3);
		newProperty.propertyType = (str) ? [NSString stringWithUTF8String:str] : @"";
		        
        
		str = (char *)sqlite3_column_text(fetchLegacyPropertiesStatement, 4);
		newProperty.latitude = (str) ? [NSDecimalNumber decimalNumberWithString:[NSString stringWithUTF8String:str]] : nil;

		
		str = (char *)sqlite3_column_text(fetchLegacyPropertiesStatement, 5);
        newProperty.longitude = (str) ? [NSDecimalNumber decimalNumberWithString:[NSString stringWithUTF8String:str]] : nil;
        
		str = (char *)sqlite3_column_text(fetchLegacyPropertiesStatement, 6);
		newProperty.bathrooms = (str) ? [NSDecimalNumber decimalNumberWithString:[NSString stringWithUTF8String:str]] : nil;
        
		newProperty.bedrooms = [NSNumber numberWithInt:sqlite3_column_int(fetchLegacyPropertiesStatement, 7) ];
		newProperty.squareFeet = [NSNumber numberWithInt:sqlite3_column_int(fetchLegacyPropertiesStatement, 8) ];
		
		str = (char *)sqlite3_column_text(fetchLegacyPropertiesStatement, 9);
        newProperty.price = (str) ? [NSDecimalNumber decimalNumberWithString:[NSString stringWithUTF8String:str]] : nil;

        newProperty.isFavorite = [NSNumber numberWithInt:sqlite3_column_int(fetchLegacyPropertiesStatement, 10)];
        newProperty.isHistory = [NSNumber numberWithInt:sqlite3_column_int(fetchLegacyPropertiesStatement, 11)];  
        
        NSTimeInterval syncTimestamp = sqlite3_column_double(fetchLegacyPropertiesStatement, 12);
        
        if (syncTimestamp > 0.0f) {
            newProperty.syncDate = [NSDate dateWithTimeIntervalSince1970:syncTimestamp];
        }        

        NSTimeInterval savedToFavoritesTimestamp = sqlite3_column_double(fetchLegacyPropertiesStatement, 13);
        
        if (savedToFavoritesTimestamp > 0.0f) {
            newProperty.savedToFavoritesDate = newProperty.isFavorite ? [NSDate dateWithTimeIntervalSince1970:savedToFavoritesTimestamp] : nil;
        }        
        
//        [newProperty setIsForSale:YES];        
        
	}
	
	sqlite3_finalize(fetchLegacyPropertiesStatement);
     
}





#pragma mark -
#pragma mark Store management

- (void)saveMainContext; {
    @try {        
        [self saveContext:[self mainContext]];
        GRLog5(@"*** mainContext saved ***");
    }
    @catch (NSException * e) {
        GRLog5(@"*** There was an exception while saving the datastore: %@ %@", [e name], [e reason]);
    }

}

- (void)saveContext:(NSManagedObjectContext *)aContext; {
    NSError *error;
    if ([aContext hasChanges] && ![aContext save:&error]) {
		NSLog(@"There was an error saving the datastore: %@\nReason: %@\nSuggestion: %@\nuserInfo: %@", error, [error localizedFailureReason], [error localizedRecoverySuggestion], [error userInfo]);
    }
}

- (void)reduceMemoryUsage; {
    
    GRLog5(@"*****");
    GRLog5(@"Trulia is reducing memory usage.");
    GRLog5(@"*****");
    [self saveMainContext];
    
    // [self.mainContext reset];
    
    [self.searchContext reset];
    [self.syncContext reset];

}

- (void)closeStore; {
	GRLog5(@"***");
	GRLog5(@"Closing the datastore");
	GRLog5(@"***");
	
	[self saveMainContext];
	[self releaseIvars];

}

#pragma mark -
#pragma mark ManagedObjectContexts

- (NSManagedObjectContext *)newContext; {
 
    NSManagedObjectContext *newContext = nil;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        newContext = [[NSManagedObjectContext alloc] init];
        [newContext setUndoManager:nil];
        [newContext setPersistentStoreCoordinator:coordinator];
    }
        
    return newContext;
    
}

// Returns the MOC used througout most of the application. When in doubt, this is what you want.
- (NSManagedObjectContext *)mainContext; {
	
    if (mainContext != nil) {
        return mainContext;
    }
	
    mainContext = [self newContext];
    return mainContext;
}

// Returns a MOC used solely for search. Its contents are generally thrown away.
- (NSManagedObjectContext *)searchContext; {
	
    if (searchContext != nil) {
        return searchContext;
    }
	
    searchContext = [self newContext];
    return searchContext;
}

// Returns a MOC used for syncing in the background.
- (NSManagedObjectContext *)syncContext; {
	
    if (syncContext != nil) {
        return syncContext;
    }
	
    syncContext = [self newContext];
    return syncContext;
}

#pragma mark -
#pragma mark Core Data fundamentals

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
    return managedObjectModel;
}

- (NSDictionary *)optionsForAutomaticLightweightMigration; {
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];      
}

- (void)addStoreToCoordinatorWithoutMigrationChecks:(NSPersistentStoreCoordinator *)coordinator withOptions:(NSDictionary *)options; {
    
    NSError *error = nil;   
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil  URL:[TruliaDataController storeUrl] options:options error:&error]) {
        GRLog(@"There was an error adding a persistent store to the persistent store coordinator: %@ %@", error, [error userInfo]);
    }    
    
}


- (void)addStoreToCoordinator:(NSPersistentStoreCoordinator *)coordinator; {
 
    
    if (YES) {
    
        /*
         *  This is the quick migration approach that should work fine, though I'm not sure it will be sufficient if we have more than one mapping model.
         */

        [self addStoreToCoordinatorWithoutMigrationChecks:coordinator withOptions:[self optionsForAutomaticLightweightMigration]];

    } else {
        
        /*
         *  The more robust / verbose migration. This can be extended to do multiple migrations in series. We don't need this quite yet, but it's working fine and I'll leave it in.
         *  Even if we just go with the fast migration above, this code will probably come in handy when custom migrations inevitably become a requirement.
         */
        
        if (![TruliaDataController persistentStoreExists]) {
            // There's no file. Don't need to deal with migration shenanigans.
            [self addStoreToCoordinatorWithoutMigrationChecks:coordinator withOptions:nil];
            return;
        }
        
        NSError *error = nil;
        NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:[TruliaDataController storeUrl] error:&error];
        
        if (sourceMetadata == nil) {
            // There was no store to get metadata from. Create it.
            [self addStoreToCoordinatorWithoutMigrationChecks:coordinator withOptions:nil];
            return;
        }
        
        NSManagedObjectModel *destinationModel = [coordinator managedObjectModel];
        BOOL pscCompatibile = [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
        
        if (pscCompatibile) {
            // Compatible. Good to go.
            [self addStoreToCoordinatorWithoutMigrationChecks:coordinator withOptions:nil];
            return;
        }
        
        NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
        
        if (sourceModel == nil) {
            
            // If we have source metadata, but no model can be found, my guess is there's a problem with the project.
            // I might be wrong, though, so let's give automatic migration a chance.
            GRLog(@"Failed to create a merged model from the MOMs in the main bundle. Attempting automatic lightweight migration.");
            [self addStoreToCoordinatorWithoutMigrationChecks:coordinator withOptions:[self optionsForAutomaticLightweightMigration]];
            
            return;            
            
        }
        
        
        NSMappingModel *mappingModel = [NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:destinationModel];
        
        if (mappingModel == nil) {
            
            // We have no mapping model. All we can really do is hope that automatic migration can save the day.
            GRLog(@"No mapping model found when attempting to migrate the Core Data database. Attempting automatic lightweight migration.");
            [self addStoreToCoordinatorWithoutMigrationChecks:coordinator withOptions:[self optionsForAutomaticLightweightMigration]];
            
            return;
        }
        
        NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
        
        // OK, we're going to move the old store to a new location, then the migrated contents will be applied to the new location. 
        // If this completes successfully, we'll delete the store at the new location and everything should work out just fine.
        
        NSError *fileMoveError = nil;

        NSString *temporaryFileName = [[TruliaDataController storeFileName] stringByAppendingString:@".original"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager moveItemAtPath:[TruliaDataController storeFileName] toPath:temporaryFileName error:&fileMoveError];
        
        if (fileMoveError) {
            GRLog(@"Error moving the Core Data database. Going with automatic migration. %@: %@", [fileMoveError localizedDescription], [fileMoveError localizedFailureReason]);
            [self addStoreToCoordinatorWithoutMigrationChecks:coordinator withOptions:[self optionsForAutomaticLightweightMigration]];
            return;
        }
                
        NSError *migrationError = nil;
        BOOL ok = [migrationManager migrateStoreFromURL:[NSURL fileURLWithPath:temporaryFileName]
                                                   type:NSSQLiteStoreType
                                                options:nil
                                       withMappingModel:mappingModel
                                       toDestinationURL:[TruliaDataController storeUrl]
                                        destinationType:NSSQLiteStoreType
                                     destinationOptions:nil
                                                  error:&migrationError];
        
        
        if (!ok || migrationError) {
            
            // OK, that didn't work out so well. Delete any file at the regular store path, then restore the old file in its place. Then go automatic.
            GRLog(@"Migration failed. Going with automatic migration. %@, %@", [migrationError localizedDescription], [migrationError localizedFailureReason]); 
            
            [fileManager removeItemAtPath:[TruliaDataController storeFileName] error:NULL];
            [fileManager moveItemAtPath:temporaryFileName toPath:[TruliaDataController storeFileName] error:&fileMoveError];
            [self addStoreToCoordinatorWithoutMigrationChecks:coordinator withOptions:[self optionsForAutomaticLightweightMigration]];
            
            
        } else {
            // Phew! Finally. Should be good to go. Clean up the temporary file first, then don't forget to actually add the store to the coordinator.
            [fileManager removeItemAtPath:temporaryFileName error:NULL];
            [self addStoreToCoordinatorWithoutMigrationChecks:coordinator withOptions:nil];
        }
        
    }
    
    
    
    
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        if ([[persistentStoreCoordinator persistentStores] count] == 0) {
            [self addStoreToCoordinator:persistentStoreCoordinator];
        }
    } else {
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        [self addStoreToCoordinator:persistentStoreCoordinator];
    }
    
    return persistentStoreCoordinator;

}

#pragma mark -
#pragma mark Directories and file locations

+ (NSString *)storeFileName; {
    
    NSLog(@"storeFileName: %@", [[TruliaDataController applicationLibraryDirectory] stringByAppendingPathComponent:TRULIA_DATA_STORE_FILE_NAME]);
    
    return [[TruliaDataController applicationLibraryDirectory] stringByAppendingPathComponent:TRULIA_DATA_STORE_FILE_NAME];
}

+ (BOOL)persistentStoreExists; {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[TruliaDataController storeFileName]];
}

+ (NSString *)applicationLibraryDirectory; {
    
    // TODO: Put this in Library or another location?
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSURL *)storeUrl; {
    return [NSURL fileURLWithPath:[TruliaDataController storeFileName]];
}

@end
