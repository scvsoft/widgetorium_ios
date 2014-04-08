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
    SCVModelPropertyTypeInt,
    SCVModelPropertyTypeLong,
    SCVModelPropertyTypeUnsignedLong,
    SCVModelPropertyTypeFloat,
    SCVModelPropertyTypeDouble,
    SCVModelPropertyTypeObject
} SCVModelPropertyType;

@protocol SCVModel <NSObject>

+ (instancetype)populatedObjectWithObject:(id)object
                                  options:(NSDictionary *)options
                                    error:(NSError **)error;
+ (instancetype)populatedObjectWithDictionary:(NSDictionary *)dictionary
                                      options:(NSDictionary *)options
                                        error:(NSError **)error;
+ (NSArray *)populatedObjectArrayWithArray:(NSArray *)array
                                      options:(NSDictionary *)options
                                        error:(NSError **)error;

/*
 *  Override points:
 */
- (BOOL)populateWithDictionary:(NSDictionary *)dictionary
                       options:(NSDictionary *)options
                         error:(NSError **)error;
- (Class)classForArrayPropertyWithKey:(NSString *)key
                              options:(NSDictionary *)options
                                error:(NSError **)error;
- (NSDate *)dateFromString:(NSString *)dateString
                       key:(NSString *)key
                   options:(NSDictionary *)options
                     error:(NSError **)error;

@end
