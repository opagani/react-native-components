//
//  TruliaBaseProperty.m
//  Trulia
//
//  Created by Bill Kunz on 5/29/10.
//  Copyright 2010 Trulia, Inc. All rights reserved.
//
//  This class's superclass was generated and maintained by Wolf Rentzch's mogenerator + Xmo'd toolkit.
//  Said superclass could be regenerated from the .xcdatamodel file using Xcode if you choose to not reuse this toolkit.
//

#import "TruliaBaseProperty.h"

#include <math.h>

@interface TruliaBaseProperty (Private)

+ (NSArray *)propertiesWithPredicate:(NSPredicate *)aPredicate sortDescriptor:(NSSortDescriptor *)aSortDescriptor inContext:(NSManagedObjectContext *)moc;

@end

@implementation TruliaBaseProperty

#pragma mark -
#pragma mark Instantiation shortcuts

+ (void)deleteAllProperties:(BOOL)favoritesOnly inContext:(NSManagedObjectContext *)moc; {
    
    NSPredicate *predicate = favoritesOnly ? [NSPredicate predicateWithFormat:@"isFavorite == YES"] : nil;

    NSArray *items = [TruliaBaseProperty propertiesWithPredicate:predicate sortDescriptor:nil inContext:moc];
    
    for (TruliaBaseProperty *item in items) {
        [moc deleteObject:item];
    }
    
}



#pragma mark -
#pragma mark Fetching

+ (NSArray *)propertiesWithPredicate:(NSPredicate *)aPredicate sortDescriptor:(NSSortDescriptor *)aSortDescriptor inContext:(NSManagedObjectContext *)moc; {
    
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    [searchRequest setEntity:[TruliaBaseProperty entityInManagedObjectContext:moc]];

    if (aPredicate) {
        [searchRequest setPredicate:aPredicate];
    }
    
    if (aSortDescriptor) {
        [searchRequest setSortDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
    }
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:searchRequest error:&error]; 
    
    if (error) {
        GRLog(@"Error fetching searches. %@ %@", [error localizedDescription], [error localizedFailureReason]);
        return nil;
    }
    
    return results;
    
}

+ (NSArray *)allFavoritePropertiesInContext:(NSManagedObjectContext *)moc; {
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"savedToFavoritesDate" ascending:NO];
    
    return [TruliaBaseProperty propertiesWithPredicate:[NSPredicate predicateWithFormat:@"isFavorite == YES"] sortDescriptor:sortDescriptor inContext:moc];
    
}



@end
