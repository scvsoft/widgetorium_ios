//
//  SCVSetTest.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 22/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSSet+Utils.h"

@interface SCVSetTest : XCTestCase

@end

@implementation SCVSetTest

- (void)testSelect
{
    NSSet *input = [NSSet setWithArray:@[@0, @1, @2, @3, @4, @5]];
    NSSet *output = [input selectWithBlock:^id(id obj) {
        return [obj intValue] > 2? obj: nil;
    }];
    NSSet *expectedOutput = [NSSet setWithObjects:@3, @4, @5, nil];
    XCTAssertEqual(output.count, 3);
    XCTAssertEqualObjects(output, expectedOutput);
    output = [input selectWithBlock:^id(id obj) {
        return @(5 - [obj intValue]);
    }];
    XCTAssertEqual(output.count, 6);
    XCTAssertEqualObjects(output, input);
}

- (void)testSelectMany
{
    NSSet *input = [NSSet setWithArray:@[@0, @1, @2, @3]];
    NSSet *output = [input selectManyWithBlock:^(NSMutableSet *dest, id obj) {
        for (int i = 0; i <= [obj intValue]; i++) {
            [dest addObject:@(i * [obj intValue])];
        }
    }];
    NSSet *expectedOutput = [NSSet setWithObjects:@0, @1, @2, @3, @4, @6, @9, nil];
    XCTAssertEqualObjects(output, expectedOutput);
}

- (void)testChoose
{
    NSSet *input = [NSSet setWithArray:@[@10, @1, @22, @333, @44, @5]];
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
