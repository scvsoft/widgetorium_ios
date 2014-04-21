//
//  UIView+Utils.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 21/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

@end
