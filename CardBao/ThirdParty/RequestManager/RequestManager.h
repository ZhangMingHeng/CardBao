//
//  RequestManage.h
//  QIJIAApartment
//
//  Created by zhangmingheng on 2017/8/9.
//  Copyright © 2017年 Shenzhen Feiben Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RequestManager;

typedef void (^httpRequestSuccsess)(RequestManager * _Nonnull manage,id _Nonnull model);
typedef void (^httpRequestFaile)(RequestManager * _Nonnull manage,id _Nonnull model);
typedef void (^httpRequestWarn)(RequestManager * _Nonnull manage,id _Nonnull model);

@interface RequestManager : NSObject

@property (nonatomic, strong) id _Nullable model; // Response响应数据

@property (nonatomic, assign) BOOL isCache; // 是否缓存 默认NO


// 实例化
+(RequestManager *_Nonnull)shareInstance;

/**
 
// @每次post请求都是调用这个方法
 
// @parameter  urlString ：URL
// @parameter  parameters：参数
// @parameter  isLoad：是否加载
// @parameter  title：加载文字
// @parameter  view：在那个地方加载
// @parameter  success：成功回调
// @parameter  faile：失败的回调
// @parameter  isCache: 是否缓存 默认NO
   @return     NSURLSessionDataTask Session任务
 
 **/
-(NSURLSessionDataTask*_Nonnull)postWithURL:(NSString*_Nonnull) urlString parameters:(id _Nullable )parameters isLoading:(BOOL) isLoad loadTitle:(NSString*_Nullable) title addLoadToView:(UIView*_Nullable) view andWithSuccess:(httpRequestSuccsess _Nonnull )success andWithWarn:(httpRequestWarn _Nonnull )warn andWithFaile:(httpRequestFaile _Nonnull )faile isCache:(BOOL) isCache;

// 上传文件
-(NSURLSessionDataTask*_Nonnull)upLoadPostWithUR:(NSString*_Nonnull) urlString file:(id _Nonnull )file fileType:(NSString* _Nonnull )fileType parameters:(id _Nullable )parameters isLoading:(BOOL) isLoad addLoadToView:(UIView*_Nullable) view andWithSuccess:(httpRequestSuccsess _Nonnull )success andWithFaile:(httpRequestFaile _Nonnull )faile;

//// 给第三方faceId开个小灶
//-(NSURLSessionDataTask*_Nonnull)postWithFaceIDURL:(NSString*_Nonnull) urlString parameters:(id _Nullable )parameters isLoading:(BOOL) isLoad loadTitle:(NSString*_Nullable) title addLoadToView:(UIView*_Nullable) view andWithSuccess:(httpRequestSuccsess _Nonnull )success;
//
//// 给第三方faceId开个小灶
//-(NSURLSessionDataTask*_Nonnull)postWithFaceIDLiveURl:(NSString*_Nonnull) urlString file:(id _Nonnull )file fileType:(NSString* _Nonnull )fileType parameters:(id _Nullable )parameters isLoading:(BOOL) isLoad addLoadToView:(UIView*_Nullable) view andWithSuccess:(httpRequestSuccsess _Nonnull )success andWithFaile:(httpRequestFaile _Nonnull )faile;
@end
