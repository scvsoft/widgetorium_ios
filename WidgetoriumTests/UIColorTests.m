//
//  UIColorTests.m
//  WidgetoriumTests
//
//  Created by Emanuel Andrada on 25/03/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIColor+Utils.h"

@interface UIColorTests : XCTestCase

@end

@implementation UIColorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testColorWithRGBColorSpace
{
    XCTAssertEqualObjects([UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5],
                          [[UIColor colorWithWhite:.5 alpha:.5] colorWithRGBColorSpace],
                          @"Gray colors don't match");
}

- (void)testColorWithHexa
{
    [self testColorWithHexa:0x000000FF isEqualsToColor:[UIColor blackColor]];
    [self testColorWithHexa:0xFFFFFFFF isEqualsToColor:[UIColor whiteColor]];
    [self testColorWithHexa:0xFF0000FF isEqualsToColor:[UIColor redColor]];
    [self testColorWithHexa:0x00FF00FF isEqualsToColor:[UIColor greenColor]];
    [self testColorWithHexa:0x0000FFFF isEqualsToColor:[UIColor blueColor]];
    [self testColorWithHexa:0xFFFF00FF isEqualsToColor:[UIColor yellowColor]];
    [self testColorWithHexa:0x00FFFFFF isEqualsToColor:[UIColor cyanColor]];
    [self testColorWithHexa:0xFF00FFFF isEqualsToColor:[UIColor magentaColor]];
    [self testColorWithHexa:0x00000000 isEqualsToColor:[UIColor clearColor]];
    [self testColorWithHexa:0x00000080 isEqualsToColor:[[UIColor blackColor] colorWithAlphaComponent:128./255.]];
}

- (void)testColorWithHexa:(NSUInteger)hexaValue isEqualsToColor:(UIColor *)color
{
    UIColor *hexaColor = [UIColor colorWithHexa:hexaValue];
    color = [color colorWithRGBColorSpace];
    XCTAssertEqualObjects(hexaColor, color, @"Color #%08lx does not match", (unsigned long)hexaValue);
}

@end
