//
//  SCVURLDownloader.h
//  Widgetorium
//
//  Created by Emanuel Andrada on 03/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCVURLDownloader;

@protocol SCVURLDowloaderObserver

- (void)urlDownloader:(SCVURLDownloader *)downloader didDownloadFileWithURL:(NSURL *)url data:(NSData *)data;
- (void)urlDownloader:(SCVURLDownloader *)downloader didFailedDownloadingFileWithURL:(NSURL *)url error:(NSError *)error;

@end

@interface SCVURLDownloader : NSObject

+ (instancetype)sharedInstance;

- (void)downloadFileWithURL:(NSURL *)url observer:(id<SCVURLDowloaderObserver>)observer;
- (void)cancelDownloadWithURL:(NSURL *)url;
- (void)cancelDownloadsWithObserver:(id<SCVURLDowloaderObserver>)observer;

@property (nonatomic, assign) NSUInteger maxConnections;

@end
