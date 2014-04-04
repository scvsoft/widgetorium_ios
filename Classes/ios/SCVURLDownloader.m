//
//  SCVURLDownloader.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 03/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "SCVURLDownloader.h"

@interface SCVURLDownloader()

@property (nonatomic, strong) NSMutableDictionary *observers; // key URL, value observers array
@property (nonatomic, strong) NSMutableDictionary *connections; // key url, value connection
@property (nonatomic, strong) NSMutableDictionary *connectionsData; // key url, value mutable data
@property (nonatomic, strong) NSMutableArray *runningConnections;
@property (nonatomic, strong) NSMutableArray *queuedConnections;

@end

@implementation SCVURLDownloader

+ (instancetype)sharedInstance
{
    static SCVURLDownloader *_sharedInstance = nil;
    if (!_sharedInstance) {
        _sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
}

- (id)init
{
    if ((self = [super init])) {
        self.observers = [NSMutableDictionary dictionary];
        self.connections = [NSMutableDictionary dictionary];
        self.connectionsData = [NSMutableDictionary dictionary];
        self.maxConnections = 10;
        self.runningConnections = [NSMutableArray array];
        self.queuedConnections = [NSMutableArray array];
    }
    return self;
}

- (void)downloadFileWithURL:(NSURL *)url observer:(id<SCVURLDowloaderObserver>)observer
{
    BOOL startNewConnection = NO;
    if (!self.observers[url]) {
        self.observers[url] = [NSMutableArray array];
        startNewConnection = YES;
    }
    [self.observers[url] addObject:observer];
    if (startNewConnection) {
        [self startNewConnectionForURL:url];
    }
}

- (void)cancelDownloadWithURL:(NSURL *)url
{
    NSURLConnection *connection = self.connections[url];
    [connection cancel];
    [self finishConnectionForURL:url withError:nil];
}

- (void)cancelDownloadsWithObserver:(id<SCVURLDowloaderObserver>)observer
{
    NSMutableArray *canceledUrls = [NSMutableArray array];
    for (NSURL *url in self.observers) {
        NSMutableArray *observers = self.observers[url];
        [observers removeObject:observer];
        if ([observers count] == 0) {
            [canceledUrls addObject:url];
        }
    }
    for (NSURL *url in canceledUrls) {
        [self cancelDownloadWithURL:url];
    }
}

- (void)startNewConnectionForURL:(NSURL *)url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
    if (connection) {
        self.connections[url] = connection;
        [self.queuedConnections addObject:connection];
        [self startQueuedConnectionIfRequired];
    }
    else {
        [self finishConnectionForURL:url withError:nil];
    }
}

- (void)startQueuedConnectionIfRequired
{
    if ([self.runningConnections count] < self.maxConnections && [self.queuedConnections count] > 0) {
        NSURLConnection *connection = self.queuedConnections[0];
        [self.queuedConnections removeObject:connection];
        [self.runningConnections addObject:connection];
        [connection start];
    }
}

- (void)finishConnectionForURL:(NSURL *)url withData:(NSData *)data
{
    NSArray *observers = self.observers[url];
    for (id<SCVURLDowloaderObserver> observer in observers) {
        [observer urlDownloader:self didDownloadFileWithURL:url data:data];
    }
    [self clearObjectsForURL:url];
    [self startQueuedConnectionIfRequired];
}

- (void)finishConnectionForURL:(NSURL *)url withError:(NSError *)error
{
    NSArray *observers = self.observers[url];
    for (id<SCVURLDowloaderObserver> observer in observers) {
        [observer urlDownloader:self didFailedDownloadingFileWithURL:url error:error];
    }
    [self clearObjectsForURL:url];
    [self startQueuedConnectionIfRequired];
}

- (void)clearObjectsForURL:(NSURL *)url
{
    NSConnection *connection = self.connections[url];
    [self.connections removeObjectForKey:url];
    [self.connectionsData removeObjectForKey:url];
    [self.runningConnections removeObject:connection];
    [self.queuedConnections removeObject:connection];
    [self.observers removeObjectForKey:url];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSURL *url = [self.connections allKeysForObject:connection][0];
    self.connectionsData[url] = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSURL *url = [self.connections allKeysForObject:connection][0];
    [self.connectionsData[url] appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSURL *url = [self.connections allKeysForObject:connection][0];
    [self finishConnectionForURL:url withError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURL *url = [self.connections allKeysForObject:connection][0];
    [self finishConnectionForURL:url withData:self.connectionsData[url]];
}

@end
