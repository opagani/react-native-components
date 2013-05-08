//
//  GRStorageManager.m
//  Trulia
//
//  Created by Michael Coutinho on 11/12/09.
//  Copyright 2009 Trulia. All rights reserved.

#import "GRStorageManager.h"
//#import "TruliaAPIController.h"
#import "TruliaDataController.h"

#define GR_SQLITE_DBFILENAME			@"trulia.db"
#define GR_DBSTORAGE_VERSION			13
#define GR_DBSTORAGE_VERSION_APP_3_0    13
#define GR_DBSTORAGE_VERSION_APP_3_1    14


@interface GRStorageManager (DatabaseManagement)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
- (void)upgradeDatabase;
- (sqlite3_stmt *)cleanSqlite3Statement:(sqlite3_stmt *)statement;
@end

@interface GRStorageManager (PrivateUpdateMethods)
@end

@interface GRStorageManager (PrivateSyncMethods)
- (BOOL)propertyIsToBeUnfavorited:(long long)propertyId;
- (BOOL)isSearchSyncedWithId:(int)searchId;
- (BOOL)isPropertySyncedWithId:(long long)propertyId;
@end

@interface GRStorageManager (DeprecatedUnusedOrRisky)
// - (int)storeOldVersionHistoryWithSearchParameters:(NSArray *)historyList;
- (NSArray *)retrieveFavoritePropertiesSince:(NSDate *)lastSelect;
- (BOOL)deleteSearchWithId:(int)searchId;
- (int)deletePropertyWithId:(long long)propertyId;
@end

static sqlite3_stmt *favorites_select_statement = nil;
static sqlite3_stmt *favorites_selectrange_statement = nil;
static sqlite3_stmt *favorites_recent_select_statement = nil;
static sqlite3_stmt *favorites_delete_statement = nil;
static sqlite3_stmt *favorites_deleteall_statement = nil;
static sqlite3_stmt *favorites_insert_statement = nil;

static sqlite3_stmt *history_insert_statement = nil;
static sqlite3_stmt *history_select_statement = nil;
static sqlite3_stmt *history_selectlast_statement = nil;
static sqlite3_stmt *history_selectrange_statement = nil;
static sqlite3_stmt *history_delete_statement = nil;
static sqlite3_stmt *history_deleteall_statement = nil;

static sqlite3_stmt *search_exists_as_favorite_statement = nil;

static sqlite3_stmt *search_unfavorite_statement = nil;
static sqlite3_stmt *search_unhistory_statement = nil;
static sqlite3_stmt *property_unfavorite_statement = nil;
static sqlite3_stmt *property_unhistory_statement = nil;

static sqlite3_stmt *property_unsynced_statement = nil;
static sqlite3_stmt *property_is_to_be_unfavorited_statement = nil;
static sqlite3_stmt *search_is_to_be_unfavorited_statement = nil;
static sqlite3_stmt *search_is_synced_statement = nil;
static sqlite3_stmt *search_unsynced_statement = nil;

static sqlite3_stmt *set_property_as_synced_statement = nil;
static sqlite3_stmt *set_search_as_synced_statement = nil;

static sqlite3_stmt *fetch_search_hash_string_statement = nil;
static sqlite3_stmt *set_search_hash_string_statement = nil;

static sqlite3_stmt *fetch_property_by_id_statement = nil;

static sqlite3_stmt *property_is_synced_statement = nil;

static sqlite3_stmt *get_search_unsupported_parameters_statement = nil;
static sqlite3_stmt *set_search_unsupported_parameters_statement = nil;

// Database table and column names
static NSString *TRULIA_DATABASE_TABLE_PROPERTY = @"property";
static NSString *TRULIA_DATABASE_TABLE_SEARCH = @"History"; // Probably should be renamed search

static NSString *TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP = @"syncTimestamp";
static NSString *TRULIA_DATABASE_COLUMN_IS_FAVORITE = @"isFavorite";
static NSString *TRULIA_DATABASE_COLUMN_IS_HISTORY = @"isHistory";
static NSString *TRULIA_DATABASE_COLUMN_TO_BE_UNFAVORITED = @"toBeUnfavorited";
static NSString *TRULIA_DATABASE_COLUMN_SAVED_TO_FAVORITES_TIMESTAMP = @"savedToFavoritesTime";
static NSString *TRULIA_DATABASE_COLUMN_UNSUPPORTED_PARAMETER_STRING = @"unsupportedParameters";

static NSString *TRULIA_DATABASE_COLUMN_SEARCH_HASH = @"hashsrch";

static GRStorageManager *sharedGRStorageManagerDelegate = nil;

@implementation GRStorageManager
@synthesize _database; // , lastSearchCriteria;

#pragma mark -
#pragma mark Database Management

+ (BOOL)sqliteDatabaseExists; {
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:GR_SQLITE_DBFILENAME];
    
    return [fileManager fileExistsAtPath:writableDBPath];
}

+ (void)deleteDatabase; {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:GR_SQLITE_DBFILENAME];
    
    NSError *error = nil;
    [fileManager removeItemAtPath:writableDBPath error:&error];
    
    if (error) {
        GRLog(@"Error deleting the existing database: %@. Reason: %@", error, [error localizedFailureReason]);
    }
    
    sharedGRStorageManagerDelegate = nil;
    
}

- (void)initializeDatabase {

    if ([TruliaDataController persistentStoreExists]) {
        return;
    }
    
	[self prepareDatabaseForUse];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:GR_SQLITE_DBFILENAME];
	
	if (sqlite3_open([path UTF8String], &_database) != SQLITE_OK)
		GRLog(@"Failed to open database stream");
	
	GRLog(@"db version: %i",currentDbVersion);
    
	if(currentDbVersion <= GR_DBSTORAGE_VERSION) {
		[self upgradeDatabase];
    }
}

- (sqlite3_stmt *)cleanSqlite3Statement:(sqlite3_stmt *)statement; {

    if (statement) {
        sqlite3_finalize(statement);
        statement = nil;
    }
    
    return statement;

}

- (void)closeDatabase; {
    
    sqlite3_finalize(get_search_unsupported_parameters_statement);
    sqlite3_finalize(set_search_unsupported_parameters_statement);
    sqlite3_finalize(fetch_property_by_id_statement);
    sqlite3_finalize(fetch_search_hash_string_statement);
    sqlite3_finalize(set_search_hash_string_statement);
    sqlite3_finalize(favorites_select_statement);
    sqlite3_finalize(favorites_selectrange_statement);
    sqlite3_finalize(favorites_recent_select_statement);
    sqlite3_finalize(favorites_delete_statement = nil);
    sqlite3_finalize(favorites_deleteall_statement);
    sqlite3_finalize(favorites_insert_statement);
    sqlite3_finalize(history_insert_statement);
    sqlite3_finalize(history_select_statement);
    sqlite3_finalize(history_selectlast_statement);
    sqlite3_finalize(history_selectrange_statement);
    sqlite3_finalize(history_delete_statement);
    sqlite3_finalize(history_deleteall_statement);
    sqlite3_finalize(search_exists_as_favorite_statement);
    sqlite3_finalize(search_unfavorite_statement);
    sqlite3_finalize(search_unhistory_statement);
    sqlite3_finalize(property_unfavorite_statement);
    sqlite3_finalize(property_unhistory_statement);    
    sqlite3_finalize(property_unsynced_statement);
    sqlite3_finalize(property_is_synced_statement);
    sqlite3_finalize(property_is_to_be_unfavorited_statement);
    sqlite3_finalize(search_is_to_be_unfavorited_statement);
    sqlite3_finalize(search_is_synced_statement);
    sqlite3_finalize(search_unsynced_statement);
    
    sqlite3_finalize(set_property_as_synced_statement);
    sqlite3_finalize(set_search_as_synced_statement);
    
    sqlite3_close(_database);
}

- (void)createEditableCopyOfDatabaseIfNeeded {
	currentDbVersion = GR_DBSTORAGE_VERSION;
    
    if ([GRStorageManager sqliteDatabaseExists]) {
		NSNumber *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
		@try {
            if (currentVersion == nil) {
                currentDbVersion = GR_DBSTORAGE_VERSION;
            } else {
                currentDbVersion = [currentVersion intValue];
            }
		}
		@catch (id theException) {
			currentDbVersion = GR_DBSTORAGE_VERSION;
		}
		return;
	}
}

- (void)upgradeDatabase {
	    
	currentDbVersion = GR_DBSTORAGE_VERSION;
    
    NSNumber *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
    @try {
        if (currentVersion == nil) {
            currentDbVersion = GR_DBSTORAGE_VERSION;
        } else {
            currentDbVersion = [currentVersion intValue];
        }
    }
    @catch (id theException) {
        currentDbVersion = GR_DBSTORAGE_VERSION;
    }   
    
    
    if(currentDbVersion >= GR_DBSTORAGE_VERSION_APP_3_1) return;
    
	GRLog(@"GRStorageManager: Upgrading datastore");
	sqlite3_stmt *migration_drop_statement = nil;
	sqlite3_stmt *migration_create_statement = nil;
//	sqlite3_stmt *migration_select_statement = nil;
	NSString *sql;
    
	if(currentDbVersion <= GR_DBSTORAGE_VERSION_APP_3_0) {
		GRLog(@"GRStorageManager: creating history table.");
		sql = @"CREATE TABLE IF NOT EXISTS History ('historyId' INTEGER PRIMARY KEY AUTOINCREMENT, 'type' INTEGER, 'criteria' TEXT, 'version' INTEGER, 'timestamp' REAL);";
		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
		else
			sqlite3_step(migration_create_statement);
		
		GRLog(@"GRStorageManager: dropping old search table");
		sql = @"DROP TABLE IF EXISTS search;";
		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_drop_statement, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
		else
			sqlite3_step(migration_drop_statement);
        
        // Destroy the previous migration statements so everything's clean for later migrations.
        migration_drop_statement = [self cleanSqlite3Statement:migration_drop_statement];
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];
                    
	}
    
    
    /*
     *  Migration for app version 3.1.
     *  The most significant features for this release are to store favorite properties and searches locally, and sync them with the My Trulia feature on trulia.com.
     *  Similarly, a history of recently-viewed properties will be stored as well.
     */
    
    if (currentDbVersion < GR_DBSTORAGE_VERSION_APP_3_1) {
        
        /*
         *  Property table migration
         */
        
        // Add columns to favorites to indicate the sync timestamp, whether it's to be deleted (but that hasn't been executed yet) and if it is a manually-saved item or historical item
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP, TRULIA_DATABASE_TABLE_PROPERTY);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' REAL;", TRULIA_DATABASE_TABLE_PROPERTY, TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP];
        
		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP column to TRULIA_DATABASE_TABLE_PROPERTY table) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }        
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];        
        
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_IS_FAVORITE, TRULIA_DATABASE_TABLE_PROPERTY);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' INTEGER;", TRULIA_DATABASE_TABLE_PROPERTY, TRULIA_DATABASE_COLUMN_IS_FAVORITE];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding TRULIA_DATABASE_COLUMN_IS_FAVORITE column to TRULIA_DATABASE_TABLE_PROPERTY table) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];  
        
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_IS_HISTORY, TRULIA_DATABASE_TABLE_PROPERTY);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' INTEGER;", TRULIA_DATABASE_TABLE_PROPERTY, TRULIA_DATABASE_COLUMN_IS_HISTORY];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding TRULIA_DATABASE_COLUMN_IS_HISTORY column to TRULIA_DATABASE_TABLE_PROPERTY table) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];           
        
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_TO_BE_UNFAVORITED, TRULIA_DATABASE_TABLE_PROPERTY);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' INTEGER;", TRULIA_DATABASE_TABLE_PROPERTY, TRULIA_DATABASE_COLUMN_TO_BE_UNFAVORITED];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding TRULIA_DATABASE_COLUMN_TO_BE_UNFAVORITED column to TRULIA_DATABASE_TABLE_PROPERTY table) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];     
        
        // savedToFavoritesTime
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_SAVED_TO_FAVORITES_TIMESTAMP, TRULIA_DATABASE_TABLE_PROPERTY);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' REAL;", TRULIA_DATABASE_TABLE_PROPERTY, TRULIA_DATABASE_COLUMN_SAVED_TO_FAVORITES_TIMESTAMP];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding TRULIA_DATABASE_COLUMN_SAVED_TO_FAVORITES_TIMESTAMP column to properties table) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }        
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];  
               
        // All existing saved properties need to have their TRULIA_DATABASE_COLUMN_IS_FAVORITE value set to 1 and sync timestamp set to 0
        sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = 1, %@ = 0;", TRULIA_DATABASE_TABLE_PROPERTY, TRULIA_DATABASE_COLUMN_IS_FAVORITE, TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP];
        
		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (All rows in TRULIA_DATABASE_TABLE_PROPERTY have TRULIA_DATABASE_COLUMN_IS_FAVORITE set to 1) with message '%s'.", sqlite3_errmsg(_database));
				} else {
			sqlite3_step(migration_create_statement);
        }
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];         
        
        
        /*
         *  Search / "History" table migration
         */
        
        /*
        // Renaming History table to search
        GRLog(@"GRStorageManager: Renaming History table to search");

        sql = [NSString stringWithFormat:@"ALTER TABLE History RENAME TO %@", TRULIA_DATABASE_TABLE_SEARCH];
        
		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Renaming History table to search) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }        
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];         
        */
        
        // Add columns to searches to indicate the sync timestamp, whether it's to be deleted (but that hasn't been executed yet) and if it is a manually-saved item or historical item
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP, TRULIA_DATABASE_TABLE_SEARCH);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' REAL", TRULIA_DATABASE_TABLE_SEARCH, TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding sync timestamp column to search table) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }

        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];         
        
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_IS_FAVORITE, TRULIA_DATABASE_TABLE_SEARCH);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' INTEGER;", TRULIA_DATABASE_TABLE_SEARCH, TRULIA_DATABASE_COLUMN_IS_FAVORITE];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding isFavorite column to search table) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }        
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];  
        
        
        // savedToFavoritesTime
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_SAVED_TO_FAVORITES_TIMESTAMP, TRULIA_DATABASE_TABLE_SEARCH);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' REAL;", TRULIA_DATABASE_TABLE_SEARCH, TRULIA_DATABASE_COLUMN_SAVED_TO_FAVORITES_TIMESTAMP];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding TRULIA_DATABASE_COLUMN_SAVED_TO_FAVORITES_TIMESTAMP column to search table) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }        
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];  
        
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_IS_HISTORY, TRULIA_DATABASE_TABLE_SEARCH);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' INTEGER;", TRULIA_DATABASE_TABLE_SEARCH, TRULIA_DATABASE_COLUMN_IS_HISTORY];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding TRULIA_DATABASE_COLUMN_IS_HISTORY column to TRULIA_DATABASE_TABLE_SEARCH table) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];                   
        
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_TO_BE_UNFAVORITED, TRULIA_DATABASE_TABLE_SEARCH);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' INTEGER;", TRULIA_DATABASE_TABLE_SEARCH, TRULIA_DATABASE_COLUMN_TO_BE_UNFAVORITED];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding TRULIA_DATABASE_COLUMN_TO_BE_UNFAVORITED column to TRULIA_DATABASE_TABLE_SEARCH table) with message '%s'.",  sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];   
        

        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_SEARCH_HASH, TRULIA_DATABASE_TABLE_SEARCH);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' TEXT;", TRULIA_DATABASE_TABLE_SEARCH, TRULIA_DATABASE_COLUMN_SEARCH_HASH];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding TRULIA_DATABASE_COLUMN_SEARCH_HASH column to TRULIA_DATABASE_TABLE_SEARCH table) with message '%s'.",  sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];           
        
        // TRULIA_DATABASE_COLUMN_UNSUPPORTED_PARAMETER_STRING
        GRLog(@"GRStorageManager: Adding %@ column to %@ table", TRULIA_DATABASE_COLUMN_UNSUPPORTED_PARAMETER_STRING, TRULIA_DATABASE_TABLE_SEARCH);
        sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN '%@' TEXT;", TRULIA_DATABASE_TABLE_SEARCH, TRULIA_DATABASE_COLUMN_UNSUPPORTED_PARAMETER_STRING];

		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (Adding TRULIA_DATABASE_COLUMN_UNSUPPORTED_PARAMETER_STRING column to TRULIA_DATABASE_TABLE_SEARCH table) with message '%s'.",  sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];   
        
        // All existing historical searches need to have their TRULIA_DATABASE_COLUMN_IS_HISTORY value set to 1 and their TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP set to 0
        sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = 1, %@ = 0;", TRULIA_DATABASE_TABLE_SEARCH, TRULIA_DATABASE_COLUMN_IS_HISTORY, TRULIA_DATABASE_COLUMN_SYNC_TIMESTAMP];
        
		if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &migration_create_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement (All rows in TRULIA_DATABASE_TABLE_SEARCH have TRULIA_DATABASE_COLUMN_IS_HISTORY set to 1) with message '%s'.", sqlite3_errmsg(_database));
		} else {
			sqlite3_step(migration_create_statement);
        }
        
        migration_create_statement = [self cleanSqlite3Statement:migration_create_statement];          
        
        
    }
    
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:GR_DBSTORAGE_VERSION_APP_3_1] forKey:@"appVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)prepareDatabaseForUse; {
    
    // SQLite needs to run in multithreaded mode in preparation for background synchronization. 
    // This function needs to be called before any other SQLite operation.
    if (sqlite3_config(SQLITE_CONFIG_SERIALIZED) == SQLITE_OK) {
        GRLog(@"SQLite connections can now be used by multiple threads.");
    }
    
}

#pragma mark -
#pragma mark NSObject overrides and singleton support

+ (GRStorageManager *)sharedInstance {
    @synchronized(self) {
        if (sharedGRStorageManagerDelegate == nil) {
//            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedGRStorageManagerDelegate;
}

- (id)init {
	self = [super init];
	if (self != nil) {
		currentDbVersion = GR_DBSTORAGE_VERSION;
		[self initializeDatabase];
	}
	return self;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedGRStorageManagerDelegate == nil) {
			sharedGRStorageManagerDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return sharedGRStorageManagerDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

@end
