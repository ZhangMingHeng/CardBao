//
//  CreditExtensionMainVC.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CreditViewPush){
    CreditViewPushIdentity, // 身份证
    CreditViewPushBankCard, // 银行卡
    CreditViewPushBasicInfo, // 基本信息
    CreditViewPushZHIMACredit, // 芝麻认证
    CreditViewPushOperator, // 运营商
    CreditViewPushConfirmInfo, // 信息确认
};


#import "BaseViewController.h"


@interface CreditExtensionMainVC : BaseViewController
@property (nonatomic,strong) UILabel *stepLabel;

// 授信编号
@property (nonatomic, strong) NSString *creditNo;

// 根据viewPush显示到那个流程页面，默认为上传身份证页面
@property (nonatomic) CreditViewPush viewPush;
@end
