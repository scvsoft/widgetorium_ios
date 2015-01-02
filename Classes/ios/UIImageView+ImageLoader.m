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
#import <objc/runtime.h>


static const char kDefaultImageViewLoaderKey;

@interface UIImageView ()
@property(nonatomic, strong) UIImage *defaultImage;
@end


@interface UIImageView (URLDownloaderObserver) <SCVURLDowloaderObserver>
@end


@implementation UIImageView (ImageLoader)

- (UIImage*) defaultImage {
    return  objc_getAssociatedObject(self, &kDefaultImageViewLoaderKey);
}

- (void) setDefaultImage:(UIImage *)defaultImage {
    objc_setAssociatedObject(self, &kDefaultImageViewLoaderKey, defaultImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)loadImageWithURL:(NSURL *)url
  activityIndicatorStyle:(UIActivityIndicatorViewStyle)style
            defaultImage:(UIImage*)defaultImage
{
    self.defaultImage = defaultImage;
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
        if (image) {
            [[SCVURLImageCache sharedInstance] setCachedImage:image forURL:url];
        }
    }
    self.image = image ? image : self.defaultImage;
    [[self activityIndicator] removeFromSuperview];
}

- (void)urlDownloader:(SCVURLDownloader *)downloader didFailedDownloadingFileWithURL:(NSURL *)url error:(NSError *)error
{
    self.image = self.defaultImage;
    [[self activityIndicator] removeFromSuperview];
}

@end