//
//  RequestCacheManager.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/30.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestCacheManager : NSObject
@property (nonatomic, assign) BOOL isFileExist;

/***
 @初始化
 @parameter url: 请求地址
 
 @parameter parameters: 请求参数
 ***/
- (instancetype)initWithCacheURL:(nonnull NSString *) url withParameters:(nonnull id)parameters;

/***
 
 @保存数据
 @parameter responseData: 响应数据
 @return BOOL: 是否存储成功
 ***/
- (BOOL)saveCaDataForArchiver:(id)responseData;

/***
 
 @获取缓存数据
 
 ***/
- (id)getCacheDataForArchiver;
@end
