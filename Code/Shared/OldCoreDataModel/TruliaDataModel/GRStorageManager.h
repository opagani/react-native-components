//
//  GRStorageManager.h
//  Trulia
//
//  Created by Michael Coutinho on 11/12/09.
//  Copyright 2009 Trulia. All rights reserved.
//

#import <sqlite3.h>

@interface GRStorageManager : NSObject {
	sqlite3 *_database;
	int currentDbVersion;
	int lastHistoryId;
	int lastFavoriteId;
}

@property(readonly) sqlite3 *_database;

+ (GRStorageManager *)sharedInstance;

#pragma mark -
#pragma mark Database Management

+ (BOOL)sqliteDatabaseExists;
+ (void)deleteDatabase;

- (void)prepareDatabaseForUse;
- (void)closeDatabase;

@end
