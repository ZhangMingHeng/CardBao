//
//  LocationManager.h
//  CardBao
//
//  Created by zhangmingheng on 2018/10/29.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LocationManager;
// manage:self  code:0成功\1失败  result:结果
typedef void (^requestLocation)(LocationManager * _Nonnull manage, NSInteger code ,NSDictionary *_Nonnull result);

@interface LocationManager : NSObject

// 初始化定位类
+(instancetype)shareInstance;

// 获取定位数据
- (void)requestLocation:(UIViewController* _Nonnull) viewController resultBlock:(requestLocation _Nonnull) requestLocation;
@end

NS_ASSUME_NONNULL_END
