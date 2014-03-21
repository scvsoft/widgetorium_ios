//
//  NSData+Utilities.m
//  Widgetorium
//
//  Created by Gabe Daraio on 21/03/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "NSData+Utilities.h"

@implementation NSData (Utilities)

- (NSUInteger) extractByte:(NSUInteger)index {
    NSUInteger buffer = 0;
    [self getBytes:&buffer range:NSMakeRange(index, 1)];
    return buffer;
}

@end
