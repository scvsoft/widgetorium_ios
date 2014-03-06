//
//  SCVLoadingScreen.h
//  Widgetorium
//
//  Created by Seba on 3/6/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCVLoadingScreen : NSObject

+ (SCVLoadingScreen *)sharedInstance;
- (void) show;
- (void) hide;

@end
