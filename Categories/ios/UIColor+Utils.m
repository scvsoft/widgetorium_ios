//
//  UIColor+Utils.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 26/03/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "UIColor+Utils.h"

#define MAX_VALUE   255.f

@implementation UIColor (Utils)

+ (UIColor *)colorWithHexa:(NSUInteger)hexaValue
{
    CGFloat red = (CGFloat)(hexaValue / 0x1000000) / MAX_VALUE;
    CGFloat green = (CGFloat)(hexaValue / 0x10000 % 0x100) / MAX_VALUE;
    CGFloat blue = (CGFloat)(hexaValue / 0x100 % 0x100) / MAX_VALUE;
    CGFloat alpha = (CGFloat)(hexaValue % 0x100) / MAX_VALUE;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)colorWithRGBColorSpace
{
    if (CGColorSpaceGetModel(CGColorGetColorSpace([self CGColor])) == kCGColorSpaceModelMonochrome) {
        const CGFloat *oldComponents = CGColorGetComponents([self CGColor]);
        return [UIColor colorWithRed:oldComponents[0]
                               green:oldComponents[0]
                                blue:oldComponents[0]
                               alpha:oldComponents[1]];
    }
    return self;
}

@end
