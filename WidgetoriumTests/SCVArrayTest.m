//
//  SCVArrayTest.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 22/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+Utils.h"

@interface SCVArrayTest : XCTestCase

@end

@implementation SCVArrayTest

- (void)testSelect
{
    NSArray *input = @[@0, @1, @2, @3, @4, @5];
    NSArray *output = [input selectWithBlock:^id(id obj) {
        return [obj intValue] > 2? obj: nil;
    }];
    XCTAssertEqual(output.count, 3);
    XCTAssertEqualObjects(output[0], @3);
    output = [input selectWithBlock:^id(id obj) {
        return @(5 - [obj intValue]);
    }];
    XCTAssertEqual(output.count, 6);
    [output enumerateObjectsUsingBlock:^(id number, NSUInteger idx, BOOL *stop) {
        XCTAssertEqualObjects(number, @(5 - idx));
    }];
}

- (void)testSelectMany
{
    NSArray *input = @[@0, @1, @2, @3];
    NSArray *output = [input selectManyWithBlock:^(NSMutableArray *dest, id obj) {
        for (int i = 0; i < [obj intValue]; i++) {
            [dest addObject:@(i)];
        }
    }];
    XCTAssertEqual(output.count, 6);
}

- (void)testChoose
{
    NSArray *input = @[@10, @1, @22, @333, @44, @5];
    id max = [input chooseWithBlock:^id(id a, id b) {
        return [a intValue] > [b intValue]? a: b;
    }];
    id min = [input chooseWithBlock:^id(id a, id b) {
        return [a intValue] < [b intValue]? a: b;
    }];
    XCTAssertEqualObjects(max, @333);
    XCTAssertEqualObjects(min, @1);
}

@end
