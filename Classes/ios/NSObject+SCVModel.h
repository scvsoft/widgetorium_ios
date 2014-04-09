//
//  NSObject+SCVModel.h
//  Widgetorium
//
//  Created by Emanuel Andrada on 04/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "SCVModel.h"

@interface NSObject (SCVModel) <SCVModel>

//
+ (instancetype)populatedObjectWithObject:(id)object
                                  options:(NSDictionary *)options
                                    error:(NSError **)error
                                   parent:(id)parent
                                parentKey:(NSString *)parentKey;

// Translate key
- (NSString *)keyForDictionaryKey:(NSString *)key;

// Translate values
// Useful to translate strings to enums
- (NSNumber *)numberWithValue:(id)value forKey:(NSString *)key;

// NSDate
// Default callback instanciating a NSDate
- (NSDate *)dateWithString:(NSString *)string
                    forKey:(NSString *)key
                   options:(NSDictionary *)options
                     error:(NSError *__autoreleasing*)error;

// NSArray
- (Class)classForArrayPropertyWithKey:(NSString *)key
                              options:(NSDictionary *)options
                                error:(NSError **)error;

@end
