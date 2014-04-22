//
//  UIColor+Utils.h
//  Widgetorium
//
//  Created by Emanuel Andrada on 26/03/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)

///  Returns a UIColor that matches the given hexa value.
///  Example: [UIColor colorWithHexa:0xRRGGBBAA]
///  RR red value, GG green value, BB blue value, AA alpha value
+ (UIColor *)colorWithHexa:(NSUInteger)hexaValue;

- (UIColor *)colorWithRGBColorSpace;

@end
