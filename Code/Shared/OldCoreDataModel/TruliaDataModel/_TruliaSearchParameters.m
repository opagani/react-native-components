// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TruliaSearchParameters.m instead.

#import "_TruliaSearchParameters.h"

@implementation TruliaSearchParametersID
@end

@implementation _TruliaSearchParameters

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TruliaSearchParameters" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TruliaSearchParameters";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TruliaSearchParameters" inManagedObjectContext:moc_];
}

- (TruliaSearchParametersID*)objectID {
	return (TruliaSearchParametersID*)[super objectID];
}


@dynamic centroidLatitude;
@dynamic centroidLongitude;

@dynamic currentProperties;
@dynamic type;

@dynamic freeSearchText;
@dynamic truliaURI;
@dynamic mlsId;

@dynamic address;
@dynamic neighborhood;
@dynamic county;

@dynamic propertyTypesData;

@dynamic openHomeTime;



- (int)openHomeTimeValue {
	NSNumber *result = [self openHomeTime];
	return result ? [result intValue] : 0;
}

- (void)setOpenHomeTimeValue:(int)value_ {
	[self setOpenHomeTime:[NSNumber numberWithInt:value_]];
}






@dynamic minLongitude;






@dynamic minLatitude;






@dynamic nearbyCity;







@dynamic state;






@dynamic toBeUnfavorited;



- (BOOL)toBeUnfavoritedValue {
	NSNumber *result = [self toBeUnfavorited];
	return result ? [result boolValue] : 0;
}

- (void)setToBeUnfavoritedValue:(BOOL)value_ {
	[self setToBeUnfavorited:[NSNumber numberWithBool:value_]];
}










@dynamic lookUpLocation;



- (BOOL)lookUpLocationValue {
	NSNumber *result = [self lookUpLocation];
	return result ? [result boolValue] : 0;
}

- (void)setLookUpLocationValue:(BOOL)value_ {
	[self setLookUpLocation:[NSNumber numberWithBool:value_]];
}






@dynamic bathroomsMinimum;



- (int)bathroomsMinimumValue {
	NSNumber *result = [self bathroomsMinimum];
	return result ? [result intValue] : 0;
}

- (void)setBathroomsMinimumValue:(int)value_ {
	[self setBathroomsMinimum:[NSNumber numberWithInt:value_]];
}






@dynamic searchFromCurrentLocation;



- (BOOL)searchFromCurrentLocationValue {
	NSNumber *result = [self searchFromCurrentLocation];
	return result ? [result boolValue] : 0;
}

- (void)setSearchFromCurrentLocationValue:(BOOL)value_ {
	[self setSearchFromCurrentLocation:[NSNumber numberWithBool:value_]];
}






@dynamic sqrftIndex;



- (int)sqrftIndexValue {
	NSNumber *result = [self sqrftIndex];
	return result ? [result intValue] : 0;
}

- (void)setSqrftIndexValue:(int)value_ {
	[self setSqrftIndex:[NSNumber numberWithInt:value_]];
}






@dynamic soldWithinMonths;







@dynamic bedroomsMinimum;



- (int)bedroomsMinimumValue {
	NSNumber *result = [self bedroomsMinimum];
	return result ? [result intValue] : 0;
}

- (void)setBedroomsMinimumValue:(int)value_ {
	[self setBedroomsMinimum:[NSNumber numberWithInt:value_]];
}






@dynamic searchDate;






@dynamic nearbyState;






@dynamic maxLongitude;






@dynamic rentMinimum;



- (int)rentMinimumValue {
	NSNumber *result = [self rentMinimum];
	return result ? [result intValue] : 0;
}

- (void)setRentMinimumValue:(int)value_ {
	[self setRentMinimum:[NSNumber numberWithInt:value_]];
}






@dynamic maxLatitude;






@dynamic savedToFavoritesDate;






@dynamic criteriaString;






@dynamic searchHash;










@dynamic daysSincePriceReduction;



- (int)daysSincePriceReductionValue {
	NSNumber *result = [self daysSincePriceReduction];
	return result ? [result intValue] : 0;
}

- (void)setDaysSincePriceReductionValue:(int)value_ {
	[self setDaysSincePriceReduction:[NSNumber numberWithInt:value_]];
}






@dynamic petsAllowed;






@dynamic priceMaximum;



- (int)priceMaximumValue {
	NSNumber *result = [self priceMaximum];
	return result ? [result intValue] : 0;
}

- (void)setPriceMaximumValue:(int)value_ {
	[self setPriceMaximum:[NSNumber numberWithInt:value_]];
}






@dynamic nearbyZip;






@dynamic unsupportedParameters;






@dynamic zip;






@dynamic loggedToHistoryDate;






@dynamic syncDate;






@dynamic sortMethodIndex;



- (int)sortMethodIndexValue {
	NSNumber *result = [self sortMethodIndex];
	return result ? [result intValue] : 0;
}

- (void)setSortMethodIndexValue:(int)value_ {
	[self setSortMethodIndex:[NSNumber numberWithInt:value_]];
}






@dynamic city;






@dynamic searchId;



- (int)searchIdValue {
	NSNumber *result = [self searchId];
	return result ? [result intValue] : 0;
}

- (void)setSearchIdValue:(int)value_ {
	[self setSearchId:[NSNumber numberWithInt:value_]];
}






@dynamic isHistory;



- (BOOL)isHistoryValue {
	NSNumber *result = [self isHistory];
	return result ? [result boolValue] : 0;
}

- (void)setIsHistoryValue:(BOOL)value_ {
	[self setIsHistory:[NSNumber numberWithBool:value_]];
}






@dynamic rentMaximum;



- (int)rentMaximumValue {
	NSNumber *result = [self rentMaximum];
	return result ? [result intValue] : 0;
}

- (void)setRentMaximumValue:(int)value_ {
	[self setRentMaximum:[NSNumber numberWithInt:value_]];
}






@dynamic shallBeMassDeleted;



- (BOOL)shallBeMassDeletedValue {
	NSNumber *result = [self shallBeMassDeleted];
	return result ? [result boolValue] : 0;
}

- (void)setShallBeMassDeletedValue:(BOOL)value_ {
	[self setShallBeMassDeleted:[NSNumber numberWithBool:value_]];
}






@dynamic priceMinimum;



- (int)priceMinimumValue {
	NSNumber *result = [self priceMinimum];
	return result ? [result intValue] : 0;
}

- (void)setPriceMinimumValue:(int)value_ {
	[self setPriceMinimum:[NSNumber numberWithInt:value_]];
}






@dynamic isFavorite;



- (BOOL)isFavoriteValue {
	NSNumber *result = [self isFavorite];
	return result ? [result boolValue] : 0;
}

- (void)setIsFavoriteValue:(BOOL)value_ {
	[self setIsFavorite:[NSNumber numberWithBool:value_]];
}






@dynamic indexType;






@dynamic listingType;








@end
