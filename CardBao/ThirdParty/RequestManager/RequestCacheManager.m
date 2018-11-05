//
//  RequestCacheManager.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/30.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RequestUtils.h"
#import "RequestCacheManager.h"

@interface RequestCacheManager()
@property (nonatomic ,strong) NSString *cachePath; // 存储路径
@end

@implementation RequestCacheManager

- (instancetype)initWithCacheURL:(nonnull NSString *) url withParameters:(nonnull id)parameters{
    self = [super init];
    if (self) {
        [self cacheFilePath:url parameters:parameters];
    }
    return self;
}
//根据url、手机号码和参数创建路径
-(void)cacheFilePath:(NSString*) url parameters:(nonnull id)parameters{
    
    NSString *cacheFileName = [self cacheFileName:url parameters:parameters];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //检测文件路径存不存在
    self.isFileExist = [fileManager fileExistsAtPath:path isDirectory:nil];
    
    // 赋值
    self.cachePath = path;
}

//将请求路径和参数拼接成文件名称
- (NSString *)cacheFileName:(NSString*) url parameters:(nonnull id)parameters{
    
    NSString *requestInfo = [NSString stringWithFormat:@"%@%@%@",kUserPHONE,url, parameters];

    return [RequestUtils md5StringFromString:requestInfo];
    
}
//创建根路径 -文件夹
- (NSString *)cacheBasePath {
    //放入cash文件夹下,为了让手机自动清理缓存文件,避免产生垃圾
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"ZMHRequestCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
    return path;
}
//创建文件夹
-(void)createBaseDirectoryAtPath:(NSString *)path{
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
}
// 存储数据
- (BOOL)saveCaDataForArchiver:(id)responseData {
    BOOL success = NO;
    if (responseData != nil) {
        @try {
            
           success = [NSKeyedArchiver archiveRootObject:responseData toFile:self.cachePath];
            
        } @catch (NSException *exception) {
            NSLog(@"Save cache failed, reason = %@", exception.reason);
        }
    }
    return success;
}
// 获取数据
- (id) getCacheDataForArchiver {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:self.cachePath];
}
@end
