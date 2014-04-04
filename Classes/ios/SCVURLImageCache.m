//
//  SCVURLImageCache.m
//  Widgetorium
//
//  Created by Emanuel Andrada on 03/04/14.
//  Copyright (c) 2014 SCVSoft. All rights reserved.
//

#import "SCVURLImageCache.h"
#import <sqlite3.h>

#define BASE_FOLDER @"imageCache/"
#define DB_FILE     @"db.sqlite"

@interface SCVURLImageCache () {
    sqlite3 *_db;
}

@property (nonatomic, strong) NSString *basePath;
@property (nonatomic, strong) NSMapTable *currentImages;

@end

@implementation SCVURLImageCache

+ (instancetype)sharedInstance
{
    static SCVURLImageCache *_sharedInstance = nil;
    if (!_sharedInstance) {
        _sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
}

- (instancetype)init
{
    if ((self = [super init])) {
        self.basePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:BASE_FOLDER];
        [[NSFileManager defaultManager] createDirectoryAtPath:self.basePath
                                  withIntermediateDirectories:YES attributes:nil error:NULL];
        [self openDatabase];
        self.currentImages = [NSMapTable strongToWeakObjectsMapTable];
    }
    return self;
}

- (UIImage *)cachedImageForURL:(NSURL *)url
{
    BOOL exists;
    int hash = [self hashForImageAtURL:url existsInDB:&exists];
    UIImage *retval = [self.currentImages objectForKey:@(hash)];
    if (!retval && exists) {
        NSString *path = [self filenameForHash:hash];
        retval = [UIImage imageWithContentsOfFile:path];
        if (retval) {
            [self.currentImages setObject:retval forKey:@(hash)];
        }
    }
    if (retval) {
        [self updateLastAccessForHash:hash date:[NSDate date]];
    }
    return retval;
}

- (void)setCachedImage:(UIImage *)image forURL:(NSURL *)url
{
    BOOL existsInDB;
    int hash = [self hashForImageAtURL:url existsInDB:&existsInDB];
    NSString *path = [self filenameForHash:hash];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:NO];
    [self.currentImages setObject:image forKey:@(hash)];
    if (!existsInDB) {
        [self insertHash:hash url:[url absoluteString] date:[NSDate date]];
    }
}

- (void)removeCachedImageForURL:(NSURL *)url
{
    int hash = [self hashForImageAtURL:url existsInDB:NULL];
    NSString *path = [self filenameForHash:hash];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    [self.currentImages removeObjectForKey:@(hash)];
    [self removeHash:hash];
}

- (void)removeCachedImagesOlderThan:(NSDate *)date
{
    [self removeImagesOlderThan:[date timeIntervalSinceReferenceDate]];
}

- (NSString *)filenameForHash:(int)hash
{
    NSString *filename = [NSString stringWithFormat:@"%x.png", hash];
    return [self.basePath stringByAppendingPathComponent:filename];
}

- (int)hashForImageAtURL:(NSURL *)url existsInDB:(BOOL *)existsInDB
{
    int hash = [self hashForUrl:url otherHash:0];
    __block BOOL found = NO;
    while (!found) {
        BOOL exists = [self getRow:hash block:^(NSString *urlString, NSDate *lastAccess) {
            if ([[url absoluteString] isEqualToString:urlString]) {
                found = YES;
            }
        }];
        found = found || !exists;
        if (existsInDB) {
            *existsInDB = exists;
        }
    }
    return hash;
}

- (int)hashForUrl:(NSURL *)url otherHash:(int)otherHash // to avoid collisions
{
    if (!otherHash) {
        return (int)[[url absoluteString] hash];
    }
    return (int)[[NSString stringWithFormat:@"%@%x", [url absoluteString], otherHash] hash];
}

#pragma mark - DB

- (void)openDatabase
{
    const char *path = [[self.basePath stringByAppendingPathComponent:DB_FILE] UTF8String];
    sqlite3_open(path, &_db);
    sqlite3_exec(_db, "CREATE TABLE IF NOT EXISTS Image (hash int primary key, url varchar, lastAccess double)", NULL, NULL, NULL);
}

- (BOOL)getRow:(int)hash block:(void (^)(NSString *urlString, NSDate *lastAccess))block
{
    const char *sql = "SELECT url, lastAccess FROM Image WHERE hash = ?";
    sqlite3_stmt *statement;
    sqlite3_prepare_v2(_db, sql, -1, &statement, NULL);
    sqlite3_bind_int(statement, 1, hash);
    BOOL found = NO;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        if (block) {
            NSString *url = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)];
            NSDate *lastAccess = [NSDate dateWithTimeIntervalSinceReferenceDate:sqlite3_column_double(statement, 1)];
            block(url, lastAccess);
        }
        found = YES;
    }
    sqlite3_finalize(statement);
    return found;
}

- (void)insertHash:(int)hash url:(NSString *)urlString date:(NSDate *)date
{
    const char *sql = "INSERT INTO Image (hash, url, lastAccess) VALUES (?, ?, ?)";
    sqlite3_stmt *statement;
    sqlite3_prepare_v2(_db, sql, -1, &statement, NULL);
    sqlite3_bind_int(statement, 1, hash);
    sqlite3_bind_text(statement, 2, [urlString UTF8String], -1, NULL);
    sqlite3_bind_double(statement, 3, [date timeIntervalSinceReferenceDate]);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
}

- (void)updateLastAccessForHash:(int)hash date:(NSDate *)date
{
    const char *sql = "UPDATE Image SET lastAccess = ? WHERE hash = ?";
    sqlite3_stmt *statement;
    sqlite3_prepare_v2(_db, sql, -1, &statement, NULL);
    sqlite3_bind_double(statement, 1, [date timeIntervalSinceReferenceDate]);
    sqlite3_bind_int(statement, 2, hash);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
}

- (void)removeHash:(int)hash
{
    sqlite3_stmt *statement;
    const char *sql = "DELETE FROM Image WHERE hash = ?";
    sqlite3_prepare_v2(_db, sql, -1, &statement, NULL);
    sqlite3_bind_int(statement, 1, hash);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
}

- (void)removeImagesOlderThan:(double)date
{
    sqlite3_stmt *statement;
    const char *sql = "SELECT hash FROM Image WHERE lastAccess < ?";
    sqlite3_prepare_v2(_db, sql, -1, &statement, NULL);
    sqlite3_bind_double(statement, 1, date);
    while (sqlite3_step(statement) == SQLITE_ROW) {
        int hash = sqlite3_column_int(statement, 0);
        NSString *path = [self filenameForHash:hash];
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
        [self.currentImages removeObjectForKey:@(hash)];
    }
    sqlite3_finalize(statement);
    sql = "DELETE FROM Image WHERE lastAccess < ?";
    sqlite3_prepare_v2(_db, sql, -1, &statement, NULL);
    sqlite3_bind_double(statement, 1, date);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
}

@end
