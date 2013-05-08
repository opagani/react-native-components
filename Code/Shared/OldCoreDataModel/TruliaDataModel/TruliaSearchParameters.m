//
//  TruliaSearchParameters.m
//  Trulia
//
//  Created by Bill Kunz on 5/29/10.
//  Copyright 2010 Trulia, Inc. All rights reserved.
//
//  This class's superclass was generated and maintained by Wolf Rentzch's mogenerator + Xmo'd toolkit.
//  Said superclass could be regenerated from the .xcdatamodel file using Xcode if you choose to not reuse this toolkit.
//

#import "TruliaSearchParameters.h"
#import <math.h>

@interface TruliaSearchParameters (Private)
+ (NSArray *)searchesWithPredicate:(NSPredicate *)aPredicate sortDescriptor:(NSSortDescriptor *)aSortDescriptor fetchLimit:(NSNumber *)aFetchLimit inContext:(NSManagedObjectContext *)moc;
@end


@implementation TruliaSearchParameters


//+ (NSArray *)propertyTypeStringsForAPI; {
//    
//    if (!TRULIA_SEARCH_PROPERTY_TYPE_API_STRINGS) {
//        TRULIA_SEARCH_PROPERTY_TYPE_API_STRINGS = [[NSArray arrayWithObjects:
//                                                    @"", 
//                                                    @"SINGLE-FAMILY HOME", 
//                                                    @"CONDO", 
//                                                    @"TOWNHOUSE", 
//                                                    @"COOP", 
//                                                    @"APARTMENT", 
//                                                    @"LOFT", 
//                                                    @"TIC", 
//                                                    @"APARTMENT/CONDO/TOWNHOUSE", 
//                                                    @"MOBILE/MANUFACTURED", 
//                                                    @"FARM/RANCH", 
//                                                    @"LOT/LAND", 
//                                                    @"MULTI-FAMILY", 
//                                                    @"INCOME/INVESTMENT", 
//                                                    @"HOUSEBOAT", 
//                                                    @"UNKNOWN", 
//                                                    nil] retain];
//    }
//    
//    return TRULIA_SEARCH_PROPERTY_TYPE_API_STRINGS;
//    
//}





+ (void)deleteAllSearches:(BOOL)favoritesOnly inContext:(NSManagedObjectContext *)moc; {
    
    NSPredicate *predicate = favoritesOnly ? [NSPredicate predicateWithFormat:@"isFavorite == YES"] : nil;

    NSArray *allSearches = [TruliaSearchParameters searchesWithPredicate:predicate sortDescriptor:nil fetchLimit:nil inContext:moc];
    
    for (TruliaSearchParameters *search in allSearches) {
        [moc deleteObject:search];
    }
    
}



#pragma mark -
#pragma mark Fetching

+ (NSArray *)searchesWithPredicate:(NSPredicate *)aPredicate sortDescriptor:(NSSortDescriptor *)aSortDescriptor fetchLimit:(NSNumber *)aFetchLimit inContext:(NSManagedObjectContext *)moc; {
    
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[TruliaSearchParameters entityInManagedObjectContext:moc]];

    if (aPredicate) {
        [searchRequest setPredicate:aPredicate];
    }
    
    if (aSortDescriptor) {
        [searchRequest setSortDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
    }
	
	if(aFetchLimit && !isnan([aFetchLimit intValue])) {
		[searchRequest setFetchLimit:[aFetchLimit intValue]];
	}
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:searchRequest error:&error];
    
    
    if (error) {
        GRLog(@"Error fetching searches. %@ %@", [error localizedDescription], [error localizedFailureReason]);
        return nil;
    }
    
    return results;
    
}

+ (NSArray *)allFavoriteSearchesInContext:(NSManagedObjectContext *)moc; {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"savedToFavoritesDate" ascending:NO];
    return [TruliaSearchParameters searchesWithPredicate:[NSPredicate predicateWithFormat:@"isFavorite == YES"] sortDescriptor:sortDescriptor fetchLimit:nil inContext:moc];
}

+ (NSArray *)allRecentSearchesInContext:(NSManagedObjectContext *)moc; {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"loggedToHistoryDate" ascending:NO];
    return [TruliaSearchParameters searchesWithPredicate:[NSPredicate predicateWithFormat:@"isHistory == YES"] sortDescriptor:sortDescriptor fetchLimit:[NSNumber numberWithInt:15] inContext:moc];  
}


- (NSString *)freeSearchTextOrCityStateWithStaticLocations:(BOOL)includeStaticLocations includeNearbyLocations:(BOOL)includeNearbyLocations includeNearbyPrefix:(BOOL)includeNearbyPrefix; {
    
    if (self.freeSearchText) {
        return self.freeSearchText;
    } else {
        return [self locationStringWithStaticLocations:includeStaticLocations includeNearbyLocations:includeNearbyLocations includeNearbyPrefix:includeNearbyPrefix];
    }    
    
}

- (NSString *)locationStringWithStaticLocations:(BOOL)includeStaticLocations includeNearbyLocations:(BOOL)includeNearbyLocations includeNearbyPrefix:(BOOL)includeNearbyPrefix; {
    
    NSMutableString *locationString = [NSMutableString string];
    
    if (self.city != nil) {
        
        if (self.state != nil) {
            
            if (self.address != nil) {
                [locationString appendFormat:@"%@, ", self.address];
            }
            
            if (self.neighborhood != nil) {
                [locationString appendFormat:@"%@, ", self.neighborhood];
            }
            
            [locationString appendFormat:@"%@, ", [self.city capitalizedString]];
            
            if (self.county) {
                [locationString appendFormat:@"%@ County, ", [self.county capitalizedString]];
            }
            
            [locationString appendFormat:@"%@", [self.state uppercaseString]];
            
        } else {
            
            [locationString appendFormat:@"%@", [self.city capitalizedString]];
            
            if (self.county) {
                [locationString appendFormat:@"%@ County", [self.county capitalizedString]];
            }
            
        }
        
    } else if (self.state != nil) {
        
        if (self.address != nil) {
            [locationString appendFormat:@"%@, ", self.address];
        }
        
        if (self.neighborhood != nil) {
            [locationString appendFormat:@"%@, ", self.neighborhood];
        }
        
        if (self.county) {
            [locationString appendFormat:@"%@ County, ", [self.county capitalizedString]];
        }
        
        [locationString appendString:[self.state uppercaseString]];
        
    } else if (self.zip != nil) {
        
        [locationString appendString:self.zip];
        
	} else if (includeNearbyLocations && (self.nearbyCity || self.nearbyState || self.nearbyZip)) {
        
        // Fall back on "Nearby" locations
        NSString *nearbyPrefix = includeNearbyPrefix ? @"Near " : @"";
        
        if (self.nearbyCity != nil) {
            if (self.nearbyState != nil) {
                [locationString appendFormat:@"%@%@, %@", nearbyPrefix, [self.nearbyCity capitalizedString], [self.nearbyState uppercaseString]];
            } else {
                [locationString appendFormat:@"%@%@", nearbyPrefix, [self.nearbyCity capitalizedString]];
            }
        } else if (self.nearbyState != nil) {
            [locationString appendFormat:@"%@%@", nearbyPrefix, [self.nearbyState uppercaseString]];
        } else if (self.nearbyZip != nil) {
            [locationString appendFormat:@"%@%@", nearbyPrefix, self.nearbyZip];
        }
	} else {
        if (includeStaticLocations) {
            
            if ([self.searchFromCurrentLocation boolValue]) {
                [locationString appendString:IC_SEARCH_DEFAULT_NEARBY];
            } else {
                [locationString appendString:IC_SEARCH_DEFAULT_MAPAREA];
            }
        }
    }
    
    return [locationString length] > 0 ? locationString : nil;  
    
}


@end
