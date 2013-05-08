//
//  TruliaBaseProperty.h
//  Trulia
//
//  Created by Bill Kunz on 5/29/10.
//  Copyright 2010 Trulia, Inc. All rights reserved.
//
//  This class's superclass was generated and maintained by Wolf Rentzch's mogenerator + Xmo'd toolkit.
//  Said superclass could be regenerated from the .xcdatamodel file using Xcode if you choose to not reuse this toolkit.
//

#import "_TruliaBaseProperty.h"
//#import "TruliaPropertyContact.h"
#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>


@interface TruliaBaseProperty : _TruliaBaseProperty {


}


//+ (void)deleteAllProperties:(BOOL)favoritesOnly;
+ (void)deleteAllProperties:(BOOL)favoritesOnly inContext:(NSManagedObjectContext *)moc; 
+ (NSArray *)allFavoritePropertiesInContext:(NSManagedObjectContext *)moc;

@end
