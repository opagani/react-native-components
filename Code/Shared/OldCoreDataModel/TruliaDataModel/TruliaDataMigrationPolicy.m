//
//  TruliaDataMigrationPolicy.m
//  Trulia
//
//  Created by Bill Kunz on 10/18/10.
//  Copyright 2010 Trulia, Inc. All rights reserved.
//

#import "TruliaDataMigrationPolicy.h"
#import "TruliaSearchParameters.h"


@implementation TruliaDataMigrationPolicySearchParameters41

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sourceInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error; {
      
    if ([[mapping destinationEntityName] isEqualToString:@"TruliaSearchParameters"]) {
    
        TruliaSearchParameters *newSearch = (TruliaSearchParameters *)[NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName] inManagedObjectContext:[manager destinationContext]];
        
        NSArray *keys = [[[sourceInstance entity] attributesByName] allKeys];
        for (NSString *key in keys) {
            
            if (![key isEqualToString:@"propertyTypeIndex"]) {
            
                id value = [sourceInstance valueForKey:key];
                
                if (![(NSNull *)value isEqual:[NSNull null]]) {
                    [newSearch setValue:value forKey:key];
                } else {
                    GRLog(@"Found one!");
                }
                
            }
        }
        
        NSNumber *currentPropertyType = (NSNumber *)[sourceInstance valueForKey:@"propertyTypeIndex"];
        
        if ([currentPropertyType intValue] > TruliaSearchPropertyTypeAll) {
            
            NSArray *propertyTypes = [NSArray arrayWithObject:currentPropertyType];
            
            NSString *errorString = nil;
            NSData *dataFromPropertyTypes = [NSPropertyListSerialization dataFromPropertyList:propertyTypes format:NSPropertyListBinaryFormat_v1_0 errorDescription:&errorString];        
            
            if (!errorString) {
                [newSearch setValue:dataFromPropertyTypes forKey:@"propertyTypesData"];
            }
            
        }
                          
        [manager associateSourceInstance:sourceInstance withDestinationInstance:newSearch forEntityMapping:mapping];
        
        return YES;
    
    } else {
        return [super createDestinationInstancesForSourceInstance:sourceInstance entityMapping:mapping manager:manager error:error];
    }
    
}

- (BOOL)createRelationshipsForDestinationInstance:(NSManagedObject*)dInstance entityMapping:(NSEntityMapping*)mapping manager:(NSMigrationManager*)manager error:(NSError**)error; {
    return YES;
}

@end
