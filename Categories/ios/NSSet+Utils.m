//
//  NSSet+Utils.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 22/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "NSSet+Utils.h"

@implementation NSSet (Utils)

- (NSSet *)selectWithBlock:(id(^)(id obj))selectBlock
{
    NSMutableSet *set = [NSMutableSet setWithCapacity:self.count];
    for (id obj in self) {
        id retval = selectBlock(obj);
        if (retval) {
            [set addObject:retval];
        }
    }
    return [set copy];
}

- (NSSet *)selectManyWithBlock:(void(^)(NSMutableSet *dest, id obj))selectManyBlock
{
    NSMutableSet *set = [NSMutableSet set];
    for (id obj in self) {
        selectManyBlock(set, obj);
    }
    return [set copy];
}

- (id)chooseWithBlock:(id(^)(id a, id b))chooseBlock
{
    id choosen = nil;
    for (id obj in self) {
        if (!choosen) {
            choosen = obj;
        }
        else {
            choosen = chooseBlock(choosen, obj);
        }
    }
    return choosen;
}

@end
