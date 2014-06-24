//
//  SCVModel.h
//  Widgetorium
//
//  Created by Emanuel Andrada on 04/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SCVModelPropertyTypeBool,
    SCVModelPropertyTypeChar,
    SCVModelPropertyTypeUnsignedChar,
    SCVModelPropertyTypeInt,
    SCVModelPropertyTypeUnsignedInt,
    SCVModelPropertyTypeLong,
    SCVModelPropertyTypeUnsignedLong,
    SCVModelPropertyTypeFloat,
    SCVModelPropertyTypeDouble,
    SCVModelPropertyTypeObject
} SCVModelPropertyType;

@protocol SCVModel <NSObject>

+ (instancetype)populatedObjectWithObject:(id)object
                                    error:(NSError **)error;

+ (instancetype)populatedObjectWithObject:(id)object
                                  options:(NSDictionary *)options
                                    error:(NSError **)error;
+ (instancetype)populatedObjectWithDictionary:(NSDictionary *)dictionary
                                      options:(NSDictionary *)options
                                        error:(NSError **)error;
+ (NSArray *)populatedObjectArrayWithArray:(NSArray *)array
                                      options:(NSDictionary *)options
                                        error:(NSError **)error;

- (BOOL)populateWithDictionary:(NSDictionary *)dictionary
                       options:(NSDictionary *)options
                         error:(NSError **)error;

@end
