//
//  UIImageView+ImageLoader.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 03/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "UIImageView+ImageLoader.h"
#import "SCVURLImageCache.h"
#import "SCVURLDownloader.h"

@interface UIImageView (URLDownloaderObserver) <SCVURLDowloaderObserver>

@end

@implementation UIImageView (ImageLoader)

- (void)loadImageWithURL:(NSURL *)url
  activityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    [[SCVURLDownloader sharedInstance] cancelDownloadsWithObserver:self];
    UIImage *image = [[SCVURLImageCache sharedInstance] cachedImageForURL:url];
    self.image = image;
    if (!image) {
        UIActivityIndicatorView *activityIndicator = [self activityIndicator];
        if (!activityIndicator) {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
            activityIndicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            [self addSubview:activityIndicator];
        }
        [activityIndicator startAnimating];
        [[SCVURLDownloader sharedInstance] downloadFileWithURL:url observer:self];
    }
    else {
        [[self activityIndicator] removeFromSuperview];
    }
}

- (UIActivityIndicatorView *)activityIndicator
{
    UIActivityIndicatorView *activityIndicator = (id)[self.subviews lastObject];
    if ([activityIndicator isKindOfClass:[UIActivityIndicatorView class]]) {
        return activityIndicator;
    }
    return nil;
}

@end

@implementation UIImageView (URLDownloaderObserver)

- (void)urlDownloader:(SCVURLDownloader *)downloader didDownloadFileWithURL:(NSURL *)url data:(NSData *)data
{
    UIImage *image = [[SCVURLImageCache sharedInstance] cachedImageForURL:url];
    if (!image) {
        image = [UIImage imageWithData:data];
        [[SCVURLImageCache sharedInstance] setCachedImage:image forURL:url];
    }
    self.image = image;
    [[self activityIndicator] removeFromSuperview];
}

- (void)urlDownloader:(SCVURLDownloader *)downloader didFailedDownloadingFileWithURL:(NSURL *)url error:(NSError *)error
{
    [[self activityIndicator] removeFromSuperview];
}

@end