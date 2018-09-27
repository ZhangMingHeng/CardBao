//
//  LoanModel.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/31.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//


/*****
 
//业务状态业务状态：
//0, "无授权"
//1, "身份认证"
//2, "银行卡认证"
//3, "基本信息认证"
//4, "芝麻信用认证"
//5, "手机运营认证"
//6, "额度计算中"
//7, "评分不足"
//8, "授权超时"
//9, "授权成功"

*****/

#import <Foundation/Foundation.h>

@interface LoanModel : NSObject
// 用户名
@property (nonatomic, strong) NSString *userName;

// 业务状态业务状态：详情见顶部
@property (nonatomic, assign) int step;

// 电话
@property (nonatomic, strong) NSString *phoneNo;

// 头像
@property (nonatomic, strong) NSString *headImgUrl;

// 可用额度
@property (nonatomic, strong) NSString *availableCredit;

// 最大额度
@property (nonatomic, strong) NSString *maxCredit;

@end
