//
//  BasicInfoVC.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "CreditModel.h"
#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, NSBaseViewPushType) {
    NSBaseViewPushTypeDefault,
    NSBaseViewPushTypeChangeInfo,
};

@interface BasicInfoVC : BaseViewController
@property (nonatomic, strong) BasicInfoModel *basicModel; // 基本数据
// 有两个地方会有用到同一个页面（绑卡和信息确认页），所以用来区分那边跳转过啦的
@property (nonatomic) NSBaseViewPushType baseViewPushType;


@end
