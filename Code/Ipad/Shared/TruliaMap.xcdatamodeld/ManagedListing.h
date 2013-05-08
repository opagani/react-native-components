//
//  ManagedListing.h
//  TruliaMap
//
//  Created by Daniel Lowrie on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate_Shared.h"


@interface ManagedListing :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * cy;
@property (nonatomic, retain) NSString * std;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * str;
@property (nonatomic, retain) NSString * cyd;
@property (nonatomic, retain) NSString * bd;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSString * stn;
@property (nonatomic, retain) NSString * idt;
@property (nonatomic, retain) NSString * prc;
@property (nonatomic, retain) NSString * cs;
@property (nonatomic, retain) NSString * sta;
@property (nonatomic, retain) NSString * lt;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * pcn;
@property (nonatomic, retain) NSString * murl;
@property (nonatomic, retain) NSString * pb;
@property (nonatomic, retain) NSString * nh;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * ba;
@property (nonatomic, retain) NSString * apt;
@property (nonatomic, retain) NSString * pt;
@property (nonatomic, retain) NSString * pl;
@property (nonatomic, retain) NSString * st;

@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * isHistory;

+ (NSArray *)getAllListings;
+ (void)deleteAllListings:(BOOL)favoritesOnly;
+(ManagedListing *)managedListingWithListingDictionary:(NSDictionary *)listingDictionary isFavorite:(BOOL)isFavorite isHistory:(BOOL)isHistory;

@end



