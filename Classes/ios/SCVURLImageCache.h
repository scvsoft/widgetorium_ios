//
//  SCVURLImageCache.h
//  Widgetorium
//
//  Created by Emanuel Andrada on 03/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCVURLImageCache : NSObject

+ (instancetype)sharedInstance;

- (UIImage *)cachedImageForURL:(NSURL *)url;
- (void)setCachedImage:(UIImage *)image forURL:(NSURL *)url;
- (void)removeCachedImageForURL:(NSURL *)url;
- (void)removeCachedImagesOlderThan:(NSDate *)date;

@end
