//
//  DeepLinkingTests.m
//  DeepLinkingTests
//
//  Created by Garrett Richards on 10/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import <objc/runtime.h>
#import "DeepLinkingTests.h"
#import "ICAppEntryPointRouter.h"
#import "ICAppDelegate.h"
//#import "ICRouterInput.h"
#import "ICMobileWebAdapter.h"
#import "ICListingParameters.h"
#import "NSString+ApiStringParsing.h"
#import "ICConstant.h"
#import "OCMock.h"


@interface DeepLinkingTests()
@property(nonatomic, retain) ICAppEntryPointRouter *entryPointController;
@end


@implementation DeepLinkingTests

- (void)setUp
{
    [super setUp];
    
    self.entryPointController = [[ICAppEntryPointRouter alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    
    self.entryPointController = nil;
}

/*-(void) testHandlePush
{
    STAssertNotNil(_entryPointController,@"entry point controller is not initialized!" );

    @try{
        [_entryPointController handlePush:nil];
    }
    @catch(NSException * ex){
        STFail([ex description]);
    }


}

-(void) testEntryPointCanOpenNilUrl
{
    @try
    {
        STAssertFalse([_entryPointController canOpenUrl:nil], @"entry point should not open nil url" );
    }
    @catch (NSException *ex)
    {
        STFail([ex description]);
    }


}

-(void) testEntryPointCanOpenNonOpenableUrl
{
    @try
    {
        NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
        STAssertFalse([_entryPointController canOpenUrl:url], @"entry point should not open non trulia url" );
    }
    @catch (NSException *ex)
    {
        STFail([ex description]);
    }
}

-(void) testOldOpenUrl_property
{
    NSURL * url = [NSURL URLWithString:@"trulia://property?id=2846657&idt=sold&st=CA&cy=Pleasanton"];
    ICAppDelegate * delg = (ICAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delg application:[UIApplication sharedApplication] handleOpenURL:url];
}

-(void) testOldOpenUrl_sold
{
    NSURL * url = [NSURL URLWithString:@"trulia://search?srch=Dallas,+TX&c_m_seach_text=Dallas,+TX&idt=sold"];
    ICAppDelegate * delg = (ICAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delg application:[UIApplication sharedApplication] handleOpenURL:url];
}*/

/*
-(void) testParseUrl
{
    NSURL * url = [NSURL URLWithString:@"trulia://property?id=2846657&idt=sold&st=CA&cy=Pleasanton"];
    [_entryPointController openUrl:url];

}
*/

-(void) testPropertyParseSold
{
    NSURL *url = [NSURL URLWithString:@"trulia://property?id=2846657&idt=sold&st=CA&cy=Pleasanton"];
    ICRouterInput *input = [_entryPointController parseUrl:url];


    NSLog(@"%s input: %@", __func__, input);

    STAssertTrue(input.action == ROUTINGACTION_PROPERTY, @"action is incorrect");
    STAssertTrue(input.searchType == ROUTING_SEARCH_TYPE_SOLD, @"search type is incorrect");


}

-(void) testSearchParseForSale
{
    NSURL *url = [NSURL URLWithString:@"trulia://search?srch=Queens,+NY&c_m_search_text=Queens,+NY&idt=for+sale"];
    ICRouterInput * input = [_entryPointController parseUrl:url];

    NSLog(@"%s input: %@",__func__, input);

    STAssertTrue(input.action == ROUTINGACTION_SEARCH, @"action is incorrect");
    STAssertTrue(input.searchType == ROUTING_SEARCH_TYPE_FOR_SALE, @"search type is incorrect");

}

- (void)testInit {
    id mockService = [OCMockObject mockForClass:[ICMobileWebAdapter class]];
}

-(void) testSearchParseForRent
{
    NSURL *url = [NSURL URLWithString:@"trulia://search?srch=Bakersfield,+CA&c_m_seach_text=Bakersfield,+CA&idt=for+rent"];
    ICMobileWebAdapter *adapter = [[ICMobileWebAdapter alloc] init];
    ICRouterInput * input = [_entryPointController parseUrl:url];



    STAssertTrue(input.action == ROUTINGACTION_SEARCH, @"action is incorrect");
    STAssertTrue(input.searchType == ROUTING_SEARCH_TYPE_FOR_RENT, @"search type is incorrect");

}

-(void) testSearchParseSold
{
    NSURL *url = [NSURL URLWithString:@"trulia://search?srch=Dallas,+TX&c_m_seach_text=Dallas,+TX&idt=sold"];
    ICRouterInput * input = [_entryPointController parseUrl:url];



    STAssertTrue(input.action == ROUTINGACTION_SEARCH, @"action is incorrect");
    STAssertTrue(input.searchType == ROUTING_SEARCH_TYPE_SOLD, @"search type is incorrect");

    ICListingParameters * lp = [ICMobileWebAdapter parseSearch:input.args];
    STAssertEqualObjects(lp.srch, @"Dallas, TX", @"srch is not equal: %@", lp.srch);
}

-(void) testSetBedrooms
{
    ICMobileWebAdapter * adapter = [ICMobileWebAdapter new];
    NSDictionary * args = @{@"bd": @"3"};
    id returnValue = [ICMobileWebAdapter parseSearch:args];

    ICListingParameters * params = (ICListingParameters *) [ICMobileWebAdapter parseSearch:args];

    STAssertTrue([params.maxBedroom intValue] == 3, @"max bedroom: %d", params.maxBedroom);
    STAssertTrue([params.minBedroom intValue] == 3, @"min bedroom: %d", params.minBedroom);

    args = @{@"bd": @"[1|2]"};
    params = (ICListingParameters *) [ICMobileWebAdapter parseSearch:args];
    STAssertTrue([params.maxBedroom intValue] == 2, @"max bedroom: %d", params.maxBedroom);
    STAssertTrue([params.minBedroom intValue] == 1, @"min bedroom: %d", params.minBedroom);

}

-(void) testSearchSetVariousProperties
{
    ICMobileWebAdapter *adapter = [ICMobileWebAdapter new];
    NSDictionary *args = @{@"bd": @"3", @"ba":@"2", @"sq":@"2000",@"pt":@"(Single-Family Home | Condo )", @"idt":@"(For Sale| For Rent | Sold)" , @"srl" : @"6", @"oh":@"p"};
    ICListingParameters *params = (ICListingParameters *) [ICMobileWebAdapter parseSearch:args];

    STAssertTrue([params.maxBedroom intValue] == 3, @"max bedroom: %d", params.maxBedroom);
    STAssertTrue([params.minBedroom intValue] == 3, @"min bedroom: %d", params.minBedroom);

    STAssertTrue([params.maxBathroom intValue] == 2, @"max bath: %d", params.maxBathroom);
    STAssertTrue([params.minBathroom intValue] == 2, @"min bath: %d", params.minBathroom);

    STAssertTrue([params.maxSqft intValue] == 2000, @"max sqft: %d", params.maxSqft);
    STAssertTrue([params.minSqft intValue] == 2000, @"min sqft: %d", params.minSqft);

    STAssertTrue([params.propertyType containsObject:@"Single-Family Home"], @"incorrect property types: %@", params.propertyType);
    STAssertTrue([params.propertyType containsObject:@"Condo"], @"incorrect property types: %@", params.propertyType);


    STAssertTrue([params.indexType containsObject:@"For Sale"], @"incorrect index types: %@", params.indexType);
    STAssertTrue([params.indexType containsObject:@"For Rent"], @"incorrect index types: %@", params.indexType);
    STAssertTrue([params.indexType containsObject:@"Sold"], @"incorrect index types: %@", params.indexType);

    STAssertTrue([params.soldWithinMonths intValue] == 6, @"sold within: %d", params.soldWithinMonths);

    STAssertTrue(params.openHouse , @"open house incorrect");


}


-(void) testRangeMatch
{
//    NSString * test = @"(  5|43| 1 |22|   93)";
//    NSString * test = @"(  5|43|1|22|93)";
    NSString * test = @"(1|2|3|4)";
    NSError * error = nil;
//    NSString * pattern = @"^\\[\\s*([0-9]+)\\s*\\|\\s*([0-9]+)\\s*\\]$";
//    NSString * pattern = @"\\(\\s*(\\d+)\\s*([\\|]\\s*(\\d)+\\s*)*\\s*\\)";
//    NSString * pattern = @"(\\|?\\d+)+";
//    NSString * pattern = @"([^,]*)(, ?([^,]*))*";
//    NSString * pattern = @"\\(\\s*(\\d+)\\s*([\\|]\\s*(\\d)+\\s*)*\\s*\\)";
    NSString * pattern = @"(?!=^\\|)(\\d+)+";

    NSString * assurePattern = @"\(.*\)";


    NSRegularExpression * assureItIsMultiValue = [NSRegularExpression regularExpressionWithPattern:assurePattern options:NSRegularExpressionCaseInsensitive error:nil];
    STAssertTrue([assureItIsMultiValue numberOfMatchesInString:test options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [test length])] > 0, @" not a multi value") ;

    NSLog(@"%s *** pattern: %@",__func__, pattern);
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];


    __block NSMutableArray *matches = [NSMutableArray array];

    [regex enumerateMatchesInString:test options:0 range:NSMakeRange(0, [test length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
    {
        for(int i = 1; i < [result numberOfRanges]; i++)
        {
            NSString *match = [test substringWithRange:[result rangeAtIndex:i]];
            [matches addObject:match];
        }
    }];

    NSLog(@"%s matches: %@ ",__func__, matches);

}

-(void) testRangeMatch2WithStringExtension
{
    NSString * test = @"[ 22 | 33 ]";

    STAssertTrue([test isApiSearchRangeString], @"is not range string");

    NSArray * values = [test getApiSearchRangeValues];

    STAssertEquals([[values objectAtIndex:0] intValue], 22, @"values not equal");
    STAssertEquals([[values objectAtIndex:1] intValue], 33, @"values not equal");


    test = @" [3|5] ";
    values = [test getApiSearchRangeValues];
    STAssertEquals([[values objectAtIndex:0] intValue], 3, @"values not equal");
    STAssertEquals([[values objectAtIndex:1] intValue], 5, @"values not equal");

}

-(void) testInvalidRangeStringsOnExtension
{
    NSString *test = @" 22 | 33 ";

    STAssertFalse([test isApiSearchRangeString], @"should not be a range string %@", test);

    test = @"2p";
    STAssertFalse([test isApiSearchRangeString], @"should not be a range string %@", test);


    test = @"(2|3)";
    STAssertFalse([test isApiSearchRangeString], @"should not be a range string %@", test);


    // valid test
    test = @" [3|5] ";
    STAssertTrue([test isApiSearchRangeString], @"is not range string %@", test);
}



-(void) testPValueMatchWithStringExtension
{
    NSString * test = @"3p";
    NSNumber * value = [test getApiSearchPValue];
    STAssertEquals([value intValue], 3, @"invalid p value: %@ for test %@", value, test);

    test = @"10p";
    value = [test getApiSearchPValue];
    STAssertEquals([value intValue], 10, @"invalid p value: %@ for test %@", value, test);

    test = @"11p";
    value = [test getApiSearchPValue];
    STAssertEquals([value intValue], 11, @"invalid p value: %@ for test %@", value, test);

    test = @"0p";
    value = [test getApiSearchPValue];
    STAssertEquals([value intValue], 0, @"invalid p value: %@ for test %@", value, test);

    test = @"12.1p";
    value = [test getApiSearchPValue];
    STAssertNil(value, @"invalid p value: %@ for test %@", value, test);

    test = @"0.4p";
    value = [test getApiSearchPValue];
    STAssertNil(value, @"invalid p value: %@ for test %@", value, test);

    test = @"[ 3p|4]";
    value = [test getApiSearchPValue];
    STAssertNil(value, @"invalid p value: %@ for test %@", value, test);


}

- (void)testMultiValueOnExtension
{
    NSString * test = @"(1|2|3|4)";
    NSArray * values = [test getApiMultiValues];
    NSArray * expected = @[@"1", @"2", @"3", @"4"];
    STAssertEquals([values count], [expected count], @"counts do not match val: %d epected: %d", [values count], [expected count]);
    for(int i=0; i< [values count]; i++)
    {
        STAssertEqualObjects([values objectAtIndex:i], [expected objectAtIndex:i], @"values were not the same result: %@ expected: %@", [values objectAtIndex:i], [expected objectAtIndex:i]);

    }


    test = @"(1 | 2 | 3 | 4)";
    values = [test getApiMultiValues];
    expected = @[@"1", @"2", @"3", @"4"];
    STAssertEquals([values count], [expected count], @"counts do not match val: %d epected: %d", [values count], [expected count]);
    for(int i = 0; i < [values count]; i++)
    {
        STAssertEqualObjects([values objectAtIndex:i], [expected objectAtIndex:i], @"values were not the same result: %@ expected: %@", [values objectAtIndex:i], [expected objectAtIndex:i]);
    }


    test = @"(1 | 2 |3|4)";
    values = [test getApiMultiValues];
    expected = @[@"1", @"2", @"3", @"4"];
    STAssertEquals([values count], [expected count], @"counts do not match val: %d epected: %d", [values count], [expected count]);
    for(int i = 0; i < [values count]; i++)
    {
        STAssertEqualObjects([values objectAtIndex:i], [expected objectAtIndex:i], @"values were not the same result: %@ expected: %@", [values objectAtIndex:i], [expected objectAtIndex:i]);
    }


    test = @"(100 | 21 |39|4| 33)";
    values = [test getApiMultiValues];
    expected = @[@"100", @"21", @"39", @"4" , @"33"];
    STAssertEquals([values count], [expected count], @"counts do not match val: %d epected: %d", [values count], [expected count]);
    for(int i = 0; i < [values count]; i++)
    {
        STAssertEqualObjects([values objectAtIndex:i], [expected objectAtIndex:i], @"values were not the same result: %@ expected: %@", [values objectAtIndex:i], [expected objectAtIndex:i]);
    }


    test = @"(foo | bar | 3)";
    values = [test getApiMultiValues];
    expected = @[@"foo", @"bar", @"3"];
    STAssertEquals([values count], [expected count], @"counts do not match val: %d epected: %d", [values count], [expected count]);
    for(int i = 0; i < [values count]; i++)
    {
        STAssertEqualObjects([values objectAtIndex:i], [expected objectAtIndex:i], @"values were not the same result: %@ expected: %@", [values objectAtIndex:i], [expected objectAtIndex:i]);
    }

}


-(void) testDetectionOfApiSearchTypes
{
    NSString * multi = @"(1|2|3|4)";
    NSString *range = @"[1|2]";
    NSString *pValue = @"2p";

    STAssertTrue([multi isApiSearchMulitValue], @"should be a multi value: %@", multi) ;
    STAssertFalse([range isApiSearchMulitValue], @"should NOT be a multi value: %@", range) ;
    STAssertFalse([pValue isApiSearchMulitValue], @"should NOT be a multi value: %@", pValue) ;

    STAssertFalse([multi isApiSearchRangeString], @"should NOT be a range: %@", multi);
    STAssertTrue([range isApiSearchRangeString], @"should be a range: %@", range);
    STAssertFalse([pValue isApiSearchRangeString], @"should NOT be a range: %@", pValue);


    STAssertFalse([multi getApiSearchPValue], @"should NOT be a pValue: %@", multi);
    STAssertFalse([range getApiSearchPValue], @"should NOT be a pValue: %@", range);
    STAssertTrue([pValue getApiSearchPValue], @"should be a pValue: %@", pValue);

}


-(void) testCurrentAppToSupportLink
{

}

-(void) testTruliaSchemeUrl
{
    NSURL * facebookUrl = [NSURL URLWithString:@"fb://hellworld?foobar=test"];

    BOOL result = [_entryPointController isTruliaScheme:facebookUrl];

    STAssertFalse(result, @"facebook url failed: %@", facebookUrl);

    NSURL * yelpUrl = [NSURL URLWithString:@"yelp://restaurants"];

    result = [_entryPointController isTruliaScheme:yelpUrl];

    STAssertFalse(result, @"yelp url failed: %@", yelpUrl);


    NSURL * truliaGenericUrl = [NSURL URLWithString:@"trulia://property?idt=for+sale"];

    result = [_entryPointController isTruliaScheme:truliaGenericUrl];

    STAssertTrue(result, @"truliaGeneric url failed: %@", truliaGenericUrl);


    NSURL *truliaSpecificUrl = [NSURL URLWithString:@"TruliaAgent://property?idt=for+sale"];

    result = [_entryPointController isTruliaScheme:truliaSpecificUrl];

    STAssertTrue(result, @"truliaSpecific url failed: %@", truliaSpecificUrl);

}

-(void) testGenericTruliaScheme
{
    NSURL *facebookUrl = [NSURL URLWithString:@"fb://hellworld?foobar=test"];

    BOOL result = [_entryPointController isGenericTruliaScheme:facebookUrl];

    STAssertFalse(result, @"facebook url failed: %@", facebookUrl);

    NSURL *truliaSpecificUrl = [NSURL URLWithString:@"TruliaAgent://property?idt=for+sale"];

    result = [_entryPointController isGenericTruliaScheme:truliaSpecificUrl];

    STAssertFalse(result, @"truliaSpecific url failed: %@", truliaSpecificUrl);

    NSURL *truliaGenericUrl = [NSURL URLWithString:@"trulia://property?idt=for+sale"];

    result = [_entryPointController isGenericTruliaScheme:truliaGenericUrl];

    STAssertTrue(result, @"truliaGeneric url failed: %@", truliaGenericUrl);


}

@end
