//
//  ProtocolWebViewVC.h
//  CardBao
//
//  Created by zhangmingheng on 2018/11/5.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NSprotocolViewPushType) {
    NSprotocolViewPushTypeDefault,
    NSprotocolViewPushTypeConfirm
};

@interface ProtocolWebViewVC : BaseViewController

@property (nonatomic) NSprotocolViewPushType baseViewPushType;

// 协议链接
@property (nonatomic, strong) NSString *h5Url;

@end

NS_ASSUME_NONNULL_END
