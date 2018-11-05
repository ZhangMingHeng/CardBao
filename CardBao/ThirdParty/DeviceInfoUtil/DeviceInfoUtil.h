//
//  DeviceInfoUtil.h
//  CardBao
//
//  Created by zhangmingheng on 2018/10/29.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoUtil : NSObject


- (NSString *)getIPAddress:(BOOL)preferIPv4;

- (void) getDeviceInfo;
@end

NS_ASSUME_NONNULL_END
