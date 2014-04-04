//
//  NSObject+SCVModel.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 04/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "NSObject+SCVModel.h"
#import <NSObjectProperties/NSObject+Properties.h>

@implementation NSObject (SCVModel)

- (BOOL)populateWithDictionary:(NSDictionary *)dictionary options:(NSDictionary *)options error:(NSError *__autoreleasing *)error
{
    // use autopopulate if it's not overriden
    if ([[self class] instanceMethodForSelector:_cmd]
        == [NSObject instanceMethodForSelector:_cmd]) {
        return [self autopopulateWithDictionary:dictionary options:options error:error];
    }
    else if (error) {
        *error = nil;
    }
    return NO;
}

- (BOOL)autopopulateWithDictionary:(NSDictionary *)dictionary options:(NSDictionary *)options error:(NSError *__autoreleasing *)returnError
{
    NSError *error;
	NSArray* keys = [dictionary allKeys];
	for (NSString *theKey in keys) {
		id value = [dictionary valueForKey:theKey];
        NSString *key = [self keyForDictionaryKey:theKey];
		SEL selector = [self setterForKey:key];
		if (selector) {
            NSMethodSignature* signature = [self methodSignatureForSelector:selector];
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:selector];
            switch ([self typeForSignature:signature]) {
                case SCVModelPropertyTypeBool: {
                    BOOL str = [[self numberWithValue:value forKey:key] boolValue];
                    [invocation setArgument:&str atIndex:2];
                    break;
                }
                case SCVModelPropertyTypeInt: {
                    int str = [[self numberWithValue:value forKey:key] intValue];
                    [invocation setArgument:&str atIndex:2];
                    break;
                }
                case SCVModelPropertyTypeLong: {
                    unsigned long long str = [[self numberWithValue:value forKey:key] longValue];
                    [invocation setArgument:&str atIndex:2];
                    break;
                }
                case SCVModelPropertyTypeUnsignedLong: {
                    long long str = [[self numberWithValue:value forKey:key] longLongValue];
                    [invocation setArgument:&str atIndex:2];
                    break;
                }
                case SCVModelPropertyTypeFloat: {
                    float str = [[self numberWithValue:value forKey:key] floatValue];
                    [invocation setArgument:&str atIndex:2];
                    break;
                }
                case SCVModelPropertyTypeDouble: {
                    double str = [[self numberWithValue:value forKey:key] doubleValue];
                    [invocation setArgument:&str atIndex:2];
                    break;
                }
                case SCVModelPropertyTypeObject: {
                    id obj = value;
                    if (![obj isKindOfClass:[NSNull class]]) {
                        Class clazz = [self classTypeForKey:key options:options error:&error];
                        obj = [self populatedObjectForKey:key class:clazz object:obj options:options error:&error];
                        [invocation setArgument:&obj atIndex:2];
                    }
                    else {
                        // do not set null values
                        continue;
                    }
                }
            }
			[invocation invoke];
		}
		else {
 			NSLog(@"%s does not have a property named %@", class_getName([self class]), key);
		}
	}
    if (returnError) {
        *returnError = error;
    }
    return !error;
}

- (NSString *)keyForDictionaryKey:(NSString *)key
{
    if (![[self class] hasPropertyNamed:key]) {
        key = [NSString stringWithFormat:@"%@%@", [[key substringToIndex:1] lowercaseString], [key substringFromIndex:1]];
    }
    return key;
}

- (SEL)setterForKey:(NSString *)key
{
    return [[self class] setterForKey:key];
}

+ (SEL)setterForKey:(NSString *)name
{
	objc_property_t property = class_getProperty( self, [name UTF8String] );
	if (!property) {
		return NULL;
    }
	SEL result = property_getSetter(property);
	if (result) {
		return result;
	}
	// build a setter name
	NSMutableString *str = [NSMutableString stringWithString:@"set"];
	[str appendString:[[name substringToIndex:1] uppercaseString]];
	if ([name length] > 1)
		[str appendString: [name substringFromIndex: 1]];
    [str appendString:@":"];
	result = NSSelectorFromString(str);
	if (![self instancesRespondToSelector:result]) {
		[NSException raise: NSInternalInconsistencyException
					format: @"%@ has property '%@' with no custom setter, but does not respond to the default setter",
		 self, str];
	}
	return result;
}

- (SCVModelPropertyType)typeForSignature:(NSMethodSignature *)signature
{
    const char *type = [signature getArgumentTypeAtIndex:2];
    if (strcmp(type,@encode(int)) == 0) {
        return SCVModelPropertyTypeInt;
    }
    else if (strcmp(type,@encode(double)) == 0) {
        return SCVModelPropertyTypeDouble;
    }
    else if (strcmp(type,@encode(float)) == 0) {
        return SCVModelPropertyTypeFloat;
    }
    else if (strcmp(type,@encode(unsigned long long)) == 0) {
        return SCVModelPropertyTypeUnsignedLong;
    }
    else if (strcmp(type,@encode(long long)) == 0) {
        return SCVModelPropertyTypeLong;
    }
    else if (strcmp(type, @encode(BOOL)) == 0) {
        return SCVModelPropertyTypeBool;
    }
    return SCVModelPropertyTypeObject;
}

- (Class)classForArrayPropertyWithKey:(NSString *)key options:(NSDictionary *)options error:(NSError **)error
{
    @throw [NSException exceptionWithName:@"SCV.ModelAutopopulateCouldNotResolveClass" reason:[NSString stringWithFormat:@"Model autopopulate could not resolve class name for items in property array %@", key] userInfo:nil];
}

- (NSDate *)dateFromString:(NSString *)dateString key:(NSString *)key options:(NSDictionary *)options error:(NSError **)error
{
    @throw [NSException exceptionWithName:@"SCV.ModelAutopopulateCouldNotParseDate" reason:[NSString stringWithFormat:@"Model autopopulate could not parse date for property %@", key] userInfo:nil];
}

#pragma mark - convert values for key

- (NSNumber *)numberWithValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    @throw [NSException exceptionWithName:@"SCV.ModelAutopopulateCouldNotParseNumber" reason:[NSString stringWithFormat:@"Model autopopulate could not parse number for property %@. Override -[%@ numberValue:forKey:]", key, NSStringFromClass([self class])] userInfo:nil];
}

- (id)populatedObjectForKey:(NSString *)key
                      class:(Class)clazz
                     object:(id)object
                    options:(NSDictionary *)options
                      error:(NSError **)error
{
    return [clazz populatedObjectWithObject:object options:options error:error];
}

- (Class)classTypeForKey:(NSString *)key options:(NSDictionary *)options error:(NSError *__autoreleasing *)error
{
    Class clazz = [[self class] classOfPropertyNamed:key];
    if ([clazz isSubclassOfClass:[NSArray class]]) {
        clazz = [self classForArrayPropertyWithKey:key options:options error:error];
    }
    return clazz;
}

#pragma mark -

+ (instancetype)populatedObjectWithObject:(id)object options:(NSDictionary *)options error:(NSError **)error
{
    if ([object isKindOfClass:[NSArray class]]) {
        return [self populatedObjectArrayWithArray:object options:options error:error];
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        return [self populatedObjectWithDictionary:object options:options error:error];
    }
    return nil;
}

+ (instancetype)populatedObjectWithDictionary:(NSDictionary *)dictionary options:(NSDictionary *)options error:(NSError *__autoreleasing *)error
{
    id retval = [self new];
    [retval populateWithDictionary:dictionary options:options error:error];
    return retval;
}

+ (NSArray *)populatedObjectArrayWithArray:(NSArray *)input options:(NSDictionary *)options error:(NSError *__autoreleasing *)error
{
    NSMutableArray *output = [NSMutableArray arrayWithCapacity:[input count]];
    NSError *myError = nil;
    for (id obj in input) {
        id model = [self populatedObjectWithObject:obj options:options error:&myError];
        if (model && !myError) {
            [output addObject:model];
        }
        else if (myError) {
            if (error) {
                *error = myError;
            }
            return nil;
        }
    }
    return [output copy];
}

@end

@implementation NSNumber (SCVModel)

+ (instancetype)populatedObjectWithObject:(id)object options:(NSDictionary *)options error:(NSError *__autoreleasing *)error
{
    if ([object isKindOfClass:[NSNumber class]]) {
        return object;
    }
    return [super populatedObjectWithObject:object options:options error:error];
}

@end

@implementation NSString (SCVModel)

+ (instancetype)populatedObjectWithObject:(id)object options:(NSDictionary *)options error:(NSError **)error
{
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    return [super populatedObjectWithObject:object options:options error:error];
}

@end

@implementation NSURL (SCVModel)

+ (instancetype)populatedObjectWithObject:(id)object options:(NSDictionary *)options error:(NSError *__autoreleasing *)error
{
    if ([object isKindOfClass:[NSString class]]) {
        return [NSURL URLWithString:object];
    }
    return [super populatedObjectWithObject:object options:options error:error];
}

@end
