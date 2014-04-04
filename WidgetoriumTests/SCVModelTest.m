//
//  SCVModelTest.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 04/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "NSObject+SCVModel.h"

@interface SCVModelTest : XCTestCase

@end

@interface TestSimpleModel : NSObject

@property (nonatomic, strong) NSString *stringField;
@property (nonatomic, assign) NSInteger intField;

@end

@interface TestCompositeModel : NSObject

@property (nonatomic, strong) NSURL *anUrl;
@property (nonatomic, strong) TestSimpleModel *simple;
@property (nonatomic, strong) NSArray *array;

@end

typedef enum {
    SCVTestEnumNone,
    SCVTestEnumSomething
} SCVTestEnum;

@interface TestEnumModel : NSObject

@property (nonatomic, assign) SCVTestEnum enumValue;

@end

@implementation TestSimpleModel

@end

@implementation TestCompositeModel

- (Class)classForArrayPropertyWithKey:(NSString *)key options:(NSDictionary *)options error:(NSError **)error
{
    if ([@"array" isEqual:key]) {
        return [NSString class];
    }
    return [super classForArrayPropertyWithKey:key options:options error:error];
}

@end

@implementation TestEnumModel

- (NSNumber *)numberWithValue:(id)value forKey:(NSString *)key
{
    if ([@"enumValue" isEqualToString:key]) {
        NSDictionary *values = @{
            @"none": @(SCVTestEnumNone),
            @"something": @(SCVTestEnumSomething)
        };
        return values[value];
    }
    return value;
}

@end

@implementation SCVModelTest

- (void)testSimpleModel
{
    TestSimpleModel *object = [TestSimpleModel new];
    NSDictionary *input = @{
        @"stringField": @"stringValue",
        @"intField": @(123456789)
    };
    [object populateWithDictionary:input options:nil error:NULL];
    XCTAssertEqualObjects(object.stringField, @"stringValue", @"");
    XCTAssertEqual(object.intField, 123456789, @"");
}

- (void)testCompositeModel
{
    TestCompositeModel *object = [[TestCompositeModel alloc] init];
    NSDictionary *input = @{
        @"anUrl": @"http://www.google.com",
        @"simple": @{
            @"stringField": @"stringValue",
            @"intField": @(123456789)
        },
        @"array": @[@"1", @"2", @"3"]
    };
    [object populateWithDictionary:input options:nil error:NULL];
    XCTAssertEqualObjects(object.anUrl, [NSURL URLWithString:@"http://www.google.com"], @"");
    XCTAssertEqualObjects(object.simple.stringField, @"stringValue", @"");
    XCTAssertEqual(object.simple.intField, 123456789, @"");
    XCTAssertEqual(object.array.count, 3, @"");
    XCTAssertEqualObjects(object.array.lastObject, @"3", @"");
}

- (void)testEnumModel
{
    TestEnumModel *object = [TestEnumModel new];
    NSDictionary *input = @{
        @"enumValue": @"something"
    };
    [object populateWithDictionary:input options:nil error:NULL];
    XCTAssertEqual(object.enumValue, SCVTestEnumSomething, @"");
}

@end
