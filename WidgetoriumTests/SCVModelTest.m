//
//  SCVModelTest.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 04/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "NSObject+SCVModel.h"

#define DATE_FORMATTER_OPTION   @"dateFormatter"

@interface SCVModelTest : XCTestCase

@end

@interface TestSimpleModel : NSObject

@property (nonatomic, strong) NSString *stringField;
@property (nonatomic, assign) NSInteger intField;
@property (nonatomic, assign) BOOL boolField;
@property (nonatomic, assign) char charField;
@property (nonatomic, assign) unsigned char unsignedCharField;

@end

@interface TestCompositeModel : NSObject

@property (nonatomic, strong) NSURL *anUrl;
@property (nonatomic, strong) TestSimpleModel *simple;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDate *aDate;

@end

typedef NS_ENUM(NSUInteger, SCVTestEnum) {
    SCVTestEnumNone,
    SCVTestEnumSomething
};

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

- (NSDate *)dateWithString:(NSString *)string forKey:(NSString *)key options:(NSDictionary *)options error:(NSError *__autoreleasing *)error
{
    NSDateFormatter *dateFormatter = options[DATE_FORMATTER_OPTION];
    return [dateFormatter dateFromString:string];
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
    NSDictionary *input = @{
        @"stringField": @"stringValue",
        @"intField": @(123456789),
        @"boolField": @YES,
        @"charField": @(123),
        @"unsignedCharField": @(250)
    };
    TestSimpleModel *object = [TestSimpleModel populatedObjectWithObject:input options:nil error:NULL];
    XCTAssertEqualObjects(object.stringField, @"stringValue", @"");
    XCTAssertEqual(object.intField, 123456789, @"");
    XCTAssertEqual(object.boolField, YES, @"");
    XCTAssertEqual(object.charField, 123, @"");
    XCTAssertEqual(object.unsignedCharField, 250, @"");
}

- (void)testCompositeModel
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_us"];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    NSDictionary *input = @{
        @"anUrl": @"http://www.google.com",
        @"simple": @{
            @"stringField": @"stringValue",
            @"intField": @(123456789)
        },
        @"array": @[@"1", @"2", @"3"],
        @"aDate": @"1985/06/01"
    };
    TestCompositeModel *object = [TestCompositeModel populatedObjectWithObject:input options:@{
        DATE_FORMATTER_OPTION: dateFormatter} error:NULL];
    XCTAssertEqualObjects(object.anUrl, [NSURL URLWithString:@"http://www.google.com"], @"");
    XCTAssertEqualObjects(object.simple.stringField, @"stringValue", @"");
    XCTAssertEqual(object.simple.intField, 123456789, @"");
    XCTAssertEqual(object.array.count, 3, @"");
    XCTAssertEqualObjects(object.array.lastObject, @"3", @"");
    XCTAssertEqualObjects(object.aDate, [dateFormatter dateFromString:@"1985/06/01"], @"");
}

- (void)testEnumModel
{
    NSDictionary *input = @{
        @"enumValue": @"something"
    };
    TestEnumModel *object = [TestEnumModel populatedObjectWithObject:input options:nil error:NULL];
    XCTAssertEqual(object.enumValue, SCVTestEnumSomething, @"");
}

- (void)testKeyConversion
{
    TestSimpleModel *object = [TestSimpleModel new];
    XCTAssertEqualObjects([object keyForDictionaryKey:@"string_field"], @"stringField");
    XCTAssertEqualObjects([object keyForDictionaryKey:@"String_Field"], @"stringField");
    XCTAssertEqualObjects([object keyForDictionaryKey:@"StringField"], @"stringField");
    XCTAssertEqualObjects([object keyForDictionaryKey:@"stringField"], @"stringField");
    XCTAssertEqualObjects([object keyForDictionaryKey:@"string_____field"], @"stringField");
    XCTAssertEqualObjects([object keyForDictionaryKey:@"_string_field"], @"stringField");
    XCTAssertEqualObjects([object keyForDictionaryKey:@"unsigned_char_field"], @"unsignedCharField");
}

- (void)testArray
{
    NSArray *input = @[@{
        @"stringField": @"a string value"
    }, @{
        @"intField": @(987654321)
    }, @{
        @"boolField": @NO
    }, @{
        @"charField": @(-10)
    }, @{
        @"unsignedCharField": @(128)
    }];
    NSError *error;
    NSArray *array = [TestSimpleModel populatedObjectArrayWithArray:input options:nil error:&error];
    XCTAssertEqual(array.count, 5, @"");
    XCTAssertEqualObjects([array[0] stringField], @"a string value", @"");
    XCTAssertEqual([array[1] intField], 987654321, @"");
    XCTAssertEqual([array[2] boolField], NO, @"");
    XCTAssertEqual([array[3] charField], -10, @"");
    XCTAssertEqual([array[4] unsignedCharField], 128, @"");
}

@end
