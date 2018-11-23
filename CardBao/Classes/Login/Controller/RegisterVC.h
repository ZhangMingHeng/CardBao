//
//  RegisterVC.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/18.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef NS_ENUM(NSUInteger, NSPushType) {
//    NSPushTypeRegisterVC,
//    NSPushTypeForgetPswVC,
//};

@interface RegisterVC : BaseViewController
@property (nonatomic, strong) NSString *longitude; // 经度
@property (nonatomic, strong) NSString *latitude; // 纬度
//@property (nonatomic, assign) NSPushType pushType;
@end
