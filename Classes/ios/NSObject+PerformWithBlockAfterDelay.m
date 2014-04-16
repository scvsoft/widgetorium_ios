//
//  NSObject+PerformWithBlockAfterDelay.m
//  Widgetorium
//
//  Created by Seba on 4/15/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "NSObject+PerformWithBlockAfterDelay.h"

@implementation NSObject (PerformWithBlockAfterDelay)

+ (void)cancelPreviousPerformBlockRequestsWithTarget:(id)target {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fireBlockAfterDelay:) object:nil];
}

- (void)performAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block {
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

@end
