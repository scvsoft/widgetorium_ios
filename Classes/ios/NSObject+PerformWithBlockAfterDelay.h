//
//  NSObject+PerformWithBlockAfterDelay.h
//  Widgetorium
//
//  Created by Seba on 4/15/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformWithBlockAfterDelay)

/// Cancel a pending perform block after delay if the block does not start running.
/// Be extra carefaul about canceling blocks because we you may have cancelling a
/// pending block that you didn't want to. We suggest not having too many different
/// blocks for the same object at a time.
+ (void)cancelPreviousPerformBlockRequestsWithTarget:(id)target;

/// Executes a block (without parameters) after a delay in seconds. The contract is
/// very similar to performSelector:afterDelay found on NSObject
- (void)performAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block;

@end
