//
//  SCVLoadingScreen.m
//  Widgetorium
//
//  Created by Seba on 3/6/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "SCVLoadingScreen.h"

@interface SCVLoadingScreen()

@property (strong, nonatomic) UIView *loadingView;

- (void) create;

@end

@implementation SCVLoadingScreen

+ (SCVLoadingScreen *)sharedInstance {
    
    static dispatch_once_t pred = 0;
    __strong static SCVLoadingScreen *_loadingScreen = nil;
    
    dispatch_once(&pred, ^{
        
        _loadingScreen = [[self alloc] init];
        [_loadingScreen create];
    });
    
    return _loadingScreen;
}


- (void) create {
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    UIView *loadingView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, size.width, size.height)];
	
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
	
	UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
	activity.center = CGPointMake(loadingView.frame.size.width /2, loadingView.frame.size.height /2);
	[activity startAnimating];
    
	[loadingView addSubview: activity];
    
    self.loadingView = loadingView;
}

- (void) show {
    UIWindow *frontWindow = [[UIApplication sharedApplication] keyWindow];
    if (![self.loadingView.superview isEqual:frontWindow]) {
        [frontWindow addSubview:self.loadingView];
    }
}

- (void) hide {
    [self.loadingView removeFromSuperview];
}

@end
