// 
//  ManagedListing.m
//  TruliaMap
//
//  Created by Daniel Lowrie on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//query by indexType - PID - ST

#import "ManagedListing.h"


@implementation ManagedListing 

@dynamic cy;
@dynamic std;
@dynamic zip;
@dynamic str;
@dynamic cyd;
@dynamic bd;
@dynamic lon;
@dynamic stn;
@dynamic idt;
@dynamic prc;
@dynamic cs;
@dynamic sta;
@dynamic lt;
@dynamic id;
@dynamic pcn;
@dynamic murl;
@dynamic pb;
@dynamic nh;
@dynamic lat;
@dynamic ba;
@dynamic apt;
@dynamic pt;
@dynamic pl;
@dynamic st;
@dynamic isFavorite;
@dynamic isHistory;

+(ManagedListing *)managedListingWithListingDictionary:(NSDictionary *)listingDictionary isFavorite:(BOOL)isFavorite isHistory:(BOOL)isHistory {
	
	ManagedListing *managedListing = nil;
    
	//does listing already exist?
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", [listingDictionary valueForKey:@"id"]];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ManagedListing" 
								   inManagedObjectContext:((AppDelegate_Shared *)[UIApplication sharedApplication].delegate).managedObjectContext];
	
	[fetchRequest setPredicate:predicate];
	[fetchRequest setEntity:entity];
    
    
    NSError *error = nil;
    NSArray *results = [((AppDelegate_Shared *)[UIApplication sharedApplication].delegate).managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
	//create new item if necessary
    if (error || (results == nil) || ([results count] == 0)) {
        
        if (error) {
			//handle error
        }
        
        // Create a new item
		managedListing = (ManagedListing *)[NSEntityDescription insertNewObjectForEntityForName:@"ManagedListing" inManagedObjectContext:((AppDelegate_Shared *)[UIApplication sharedApplication].delegate).managedObjectContext];
		
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:listingDictionary];
		NSArray *managedKeys = managedListing.entity.attributesByName.allKeys;
		NSArray *dataKeys = [dict allKeys];
		
		//clean out key/values that don't belong in managed object	
		for (NSString *key in dataKeys) {
			if (![managedKeys containsObject:key]) {
				[dict removeObjectForKey:key];
			}
		}
		[managedListing setValuesForKeysWithDictionary:dict];
		
		[managedListing setIsHistory:[NSNumber numberWithBool:isHistory]];
		[managedListing setIsFavorite:[NSNumber numberWithBool:isFavorite]];
		
		error = nil;
		if (![((AppDelegate_Shared *)[UIApplication sharedApplication].delegate).managedObjectContext save:&error]) {
			NSLog(@"error saving: %@", error);
		}
        
        
    } else {
        managedListing = (ManagedListing *)[results objectAtIndex:0];
    }    
    
	//NSLog(@"%@", managedListing);
    return managedListing;
	
}

+ (NSArray *)getAllListings; {
	NSManagedObjectContext *moc = ((AppDelegate_Shared *)[UIApplication sharedApplication].delegate).managedObjectContext;
	
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"ManagedListing" inManagedObjectContext:moc]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:searchRequest error:&error]; 
    [searchRequest release];
    
    if (error) {
        //handle error
		GRLog(@"Error fetching searches. %@ %@", [error localizedDescription], [error localizedFailureReason]);
        
    }
	
	return results;
}

+ (void)deleteAllListings:(BOOL)favoritesOnly; {
    
	NSManagedObjectContext *moc = ((AppDelegate_Shared *)[UIApplication sharedApplication].delegate).managedObjectContext;
	
    NSPredicate *predicate = favoritesOnly ? [NSPredicate predicateWithFormat:@"isFavorite == YES"] : nil;
    
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[NSEntityDescription entityForName:@"ManagedListing" inManagedObjectContext:moc]];
	
    if (predicate) {
        [searchRequest setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:searchRequest error:&error]; 
    [searchRequest release];
    
    if (error) {
        //handle error
		GRLog(@"Error fetching searches. %@ %@", [error localizedDescription], [error localizedFailureReason]);
        
    }   
    
    for (ManagedListing *item in results) {
        [moc deleteObject:item];
    }
    
}



@end
