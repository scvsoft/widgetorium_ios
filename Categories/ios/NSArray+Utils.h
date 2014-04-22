//
//  NSArray+Utils.h
//  Widgetorium
//
//  Created by Emanuel Andrada on 22/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)

/// Projects each element of a sequence into a new form.
- (NSArray *)selectWithBlock:(id(^)(id obj))selectBlock;

/// Projects each element of a sequence allowing to add
/// zero, one or more elements into into one sequence.
- (NSArray *)selectManyWithBlock:(void(^)(NSMutableArray *dest, id obj))selectManyBlock;

/// Choose one object by comparing to each other.
- (id)chooseWithBlock:(id(^)(id a, id b))chooseBlock;

@end
