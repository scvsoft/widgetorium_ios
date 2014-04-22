//
//  NSArray+Utils.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 22/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)

- (NSArray *)selectWithBlock:(id(^)(id obj))selectBlock
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        id retval = selectBlock(obj);
        if (retval) {
            [array addObject:retval];
        }
    }
    return [array copy];
}

- (NSArray *)selectManyWithBlock:(void(^)(NSMutableArray *dest, id obj))selectManyBlock
{
    NSMutableArray *array = [NSMutableArray array];
    for (id obj in self) {
        selectManyBlock(array, obj);
    }
    return [array copy];
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
