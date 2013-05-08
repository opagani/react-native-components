//
//  ICStateTests.m
//  ICStateTests
//
//  Created by Garrett Richards on 11/9/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "ICStateTests.h"
//#import "NSMutableDictionary+ICStateManipulationUtils.h"
#import "ICState.h"



//@interface NSArray(ICStateManipulationUtils)
//
//@end
//
//@implementation NSArray (ICStateManipulationUtils)
//
//@end


@implementation ICStateTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}
/*
-(void) testDictionaryMerge
{
    NSMutableDictionary *orig = [@{@"a":@"apple", @"b":@"book", @"c":@"cat", @"z":@"zoo"} mutableCopy] ;
    NSMutableDictionary *updated = [@{@"a":@"apple", @"b":@"baboon", @"c":@"cat", @"d":@"dog"} mutableCopy] ;

    NSArray * keys = updated.allKeys;

    for(NSString * k in keys)
    {
        [orig setValue:[updated objectForKey:k] forKey:k];
    }

    NSLog(@"%s orig: %@",__func__, orig);


    for(NSString * k in keys)
    {
        STAssertEqualObjects([updated objectForKey:k], [orig objectForKey:k], @"values not equal");
    }

    STAssertEqualObjects( @"zoo",[orig objectForKey:@"z"], @"zoo not found");

}

-(void) testMergeWithDictionaryOnExtension
{
    NSMutableDictionary *orig = [@{@"a":@"apple", @"b":@"book", @"c":@"cat", @"z":@"zoo"} mutableCopy];
    NSMutableDictionary *updated = [@{@"a":@"apple", @"b":@"baboon", @"c":@"cat", @"d":@"dog"} mutableCopy];

    [orig mergeWithDictionary:updated];

    NSLog(@"%s orig: %@",__func__, orig);


    NSArray * keys = updated.allKeys;
    for(NSString * k in keys)
    {
        STAssertEqualObjects([updated objectForKey:k], [orig objectForKey:k], @"values not equal");
    }

    STAssertEqualObjects( @"zoo",[orig objectForKey:@"z"], @"zoo not found");


}


-(void) testDictionaryMergeWithSubDictionaries
{
    NSMutableDictionary *orig = [@{@"a":@"apple", @"b":@"book", @"c":@"cat", @"z":@"zoo"} mutableCopy];
    NSMutableDictionary *updated = [@{@"a":@"apple", @"b":@"baboon", @"c":@"cat", @"d":@"dog", @"e":
    @{@"one":@"111",@"two":@"222"}
    } mutableCopy] ;

    [orig mergeWithDictionary:updated];

    NSLog(@"%s orig: %@", __func__, orig);


    NSArray *keys = updated.allKeys;
    for(NSString *k in keys)
    {
        STAssertEqualObjects([updated objectForKey:k], [orig objectForKey:k], @"values not equal");
    }

    NSDictionary * subOrig = [orig objectForKey:@"e"];
    NSDictionary *subUpdated = [updated valueForKey:@"e"];
    keys = subUpdated.allKeys;

    for(NSString *k in keys)
    {
        STAssertEqualObjects([subUpdated objectForKey:k], [subOrig objectForKey:k], @"values not equal");
    }

    STAssertEqualObjects( @"zoo", [orig objectForKey:@"z"], @"zoo not found");


}


-(void) testDictionaryMergeWithExistingSubDirectoryMerge
{
    NSMutableDictionary *orig = [@{@"a":@"apple", @"b":@"book", @"c":@"cat", @"z":@"zoo" , @"e": @{@"one":@"111",@"two":@"000", @"three":@"333"}  } mutableCopy];
    NSMutableDictionary *updated = [@{@"a":@"apple", @"b":@"baboon", @"c":@"cat", @"d":@"dog", @"e":
    @{@"one":@"111",@"two":@"222"}
    } mutableCopy];

    [orig mergeWithDictionary:updated];

    NSLog(@"%s orig: %@", __func__, orig);


    NSArray *keys = updated.allKeys;
    for(NSString *k in keys)
    {
        if (![k isEqualToString:@"e"])
            STAssertEqualObjects([updated objectForKey:k], [orig objectForKey:k], @"values not equal");
    }

    NSDictionary * subOrig = [orig objectForKey:@"e"];
    NSDictionary *subUpdated = [updated valueForKey:@"e"];
    keys = subUpdated.allKeys;

    for(NSString *k in keys)
    {
        STAssertEqualObjects([subUpdated objectForKey:k], [subOrig objectForKey:k], @"values not equal");
    }

    STAssertEqualObjects(@"333", [subOrig objectForKey:@"three"], @"value does not exist");

    STAssertEqualObjects( @"zoo", [orig objectForKey:@"z"], @"zoo not found");

}

-(void) testArrayMerge
{
    NSArray * a1 = @[@1, @2, @3];
    NSArray * a2 = @[@8, @9];

    NSArray * expected = @[@1, @2, @3, @8 , @9];

    NSArray *result = [a1 arrayByAddingObjectsFromArray:a2];

    STAssertEqualObjects(expected, result, @"arrays differ");


    NSMutableDictionary * resultDict = [NSMutableDictionary dictionary];
    [resultDict setICStateValue:nil forKey:@"test"];

    NSLog(@"%s dict: %@",__func__, resultDict);

    STAssertNotNil(resultDict, @"nil");

}

-(void) testSetICStateValueNil
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    [resultDict setICStateValue:nil forKey:@"test"];

    NSLog(@"%s dict: %@", __func__, resultDict);

    STAssertEquals(0, (int) [resultDict.allKeys count], @"there should be no keys: %@", resultDict);
}

-(void) testSetICStateValueEmptyString
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    [resultDict setICStateValue:@"" forKey:@"test"];

    NSLog(@"%s dict: %@", __func__, resultDict);

    STAssertEquals(0, (int) [resultDict.allKeys count], @"there should be no keys: %@", resultDict);

}

-(NSMutableDictionary *) setupIcStateDictForKey:(NSString *) key
{

    NSMutableDictionary * resultDict = [@{key: [@{@"Value":@"insert value here", @"State":@"ICSTATE_DIRTY"} mutableCopy]} mutableCopy];
    return resultDict;
}

-(void) testSetICStateValueDictionaryMerge
{
    NSMutableDictionary *resultDict = [self setupIcStateDictForKey:@"test"];
    NSMutableDictionary * value = [@{@"a": @"antennae", @"y" : @"yacht", @"z" : @"zoo"} mutableCopy];
    [resultDict setValue:value forKeyPath:@"test.Value"];

    NSMutableDictionary * d1 = [@{@"a": @"apple",@"b" : @"bat", @"c" : @"cat" } mutableCopy];
    [resultDict setICStateValue:d1 forKey:@"test"];
    NSDictionary *expected =   @{@"a": @"antennae", @"b" : @"bat", @"c" : @"cat", @"y" : @"yacht", @"z" : @"zoo" };

    NSDictionary *v = [resultDict valueForKeyPath:@"test.Value"];
    for(NSString *k in expected.allKeys)
    {
        NSString *keyPath = [NSString stringWithFormat:@"test.Value.%@",k];
        STAssertEqualObjects([expected objectForKey:k], [resultDict valueForKeyPath:keyPath], @"not equal: %@", keyPath);
    }
}

-(void) testSetICStateValueArrayAggregate
{
    NSMutableDictionary *resultDict = [self setupIcStateDictForKey:@"test"];
    NSMutableDictionary * value = @[@1,@2];
    [resultDict setValue:value forKeyPath:@"test.Value"];

    NSArray * add = @[@8,@9];

    [resultDict setICStateValue:add forKey:@"test"];
    NSDictionary *expected =   @[@1,@2,@8,@9];


    STAssertEqualObjects(expected , [resultDict valueForKeyPath:@"test.Value"], @"not equal");
}

-(void) testNonMutableDictionarySetICStateValue
{
    NSMutableDictionary * v1 = [ @{@"test":@{@"Value":@"insert value here", @"State":@"ICSTATE_DIRTY"} } mutableCopy];
    [v1 setICStateValue:@"hello" forKey:@"test"];

    STAssertEqualObjects(@"hello", [v1 valueForKeyPath:@"test.Value"], @"not equal");
}

//-(void) testMergeOnImmutableDictionary
//{
//
//
//    NSDictionary *v1 = @{@"test" : @{@"Value" : @"insert value here", @"State" : @"ICSTATE_DIRTY"}} ;
//    NSArray *arrayValue = @[@1, @2];
//    BOOL failed = NO;
//    @try
//    {
//        [(NSMutableDictionary *) v1 setICStateValue:arrayValue forKey:@"test"];
//    }
//    @catch (NSException *ex)
//    {
//        failed = YES;
//    }
//
//    STAssertTrue(failed, @"should have thrown exception");
//
//    STAssertEqualObjects(@"hello", [v1 valueForKeyPath:@"test.Value"], @"not equal");
//
//}
//
//
//-(void) testMergeWithImmutableDictAsValue
//{
////    NSMutableDictionary * val = [@{@"one":@"one", @"two":@"two"} mutableCopy ];
//
//
//    NSMutableDictionary *val = [@{@"val3" : @"val3"} mutableCopy];
//    NSDictionary *val1 = @{@"a" : val, @"b" : val};
//
//    NSMutableDictionary * v1 = [ @{@"test":@{@"Value":val1, @"State":@"ICSTATE_DIRTY"} } mutableCopy];
//
//
//    NSDictionary *t1 = @{@"t1" : @"t1", @"t1_array" : @{@"y":@"z"} };
//
//    NSDictionary *t2 = @{@"t2" : t1};
////    NSDictionary *t3 = @{@"t3_a" : t2, @"t3_b" : arr2};
//    NSDictionary *t3 = @{@"a" : t2, @"b" : t2};
//
//
//
//    [v1 setICStateValue:t3 forKey:@"test"];
//    STAssertEqualObjects(@"hello", [v1 valueForKeyPath:@"test.Value"], @"not equal");
//}

-(void) testMutableNess
{
    id immutable = [NSDictionary dictionary];
    id mutable = [NSMutableDictionary dictionary];

    STAssertFalse([immutable respondsToSelector:@selector(setObject:forKey:)], @"should not respond");
    STAssertTrue([immutable respondsToSelector:@selector(setValue:forKey:)], @"should not respond");
    STAssertTrue([mutable respondsToSelector:@selector(setObject:forKey:)], @"should  respond");


    NSMutableDictionary * attribs = nil;


    [attribs setICStateValue:@"foo" forKey:@"fooobar"];

}

-(void) testCrashsetICStateValue
{
    id immutable = @{@"hello": @{@"foo":@"bar"}};

    id immutable2 = @{@"world":@{@"bar":@"ffffoooo", @"foo":@"barrrrrr"}};

    [[ICState sharedInstance] setAttributes:immutable];

    [[ICState sharedInstance] setAttributes:immutable2 named:@"hello"];


}

*/






@end
