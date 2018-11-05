//
//  CreditModel.h
//  CardBao
//
//  Created by zhangmingheng on 2018/10/17.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreditModel : NSObject

@end

// 身份证Model
@interface IdentityModel : NSObject
// 身份证姓名
@property (nonatomic, strong) NSString *userIDCardName;

// 身份证号码
@property (nonatomic, strong) NSString *userIDCardNumber;

// 身份证住址
@property (nonatomic, strong) NSString *userAddress;

// 身份证有效起始时间
@property (nonatomic, strong) NSString *userValidDateStart;

// 身份证有效结束时间
@property (nonatomic, strong) NSString *userValidDateEnd;

// 身份证人像面
@property (nonatomic, strong) UIImage *idcardPortraitImage;

// 身份证国徽面
@property (nonatomic, strong) UIImage *idcardEmblemImage;

// 手持证件图
@property (nonatomic, strong) UIImage *handheldImage;

// 人头像
@property (nonatomic, strong) UIImage *userImage;

//// 身份证有效起始时间
//@property (nonatomic, strong) NSString *userValidDateStart;
//
//// 身份证有效起始时间
//@property (nonatomic, strong) NSString *userValidDateStart;
//
//// 身份证有效起始时间
//@property (nonatomic, strong) NSString *userValidDateStart;

@end


// 银行卡Model

//开户银行 bankType
//1-储蓄银行,
//2-工商银行,
//3-农业银行,
//4-中国银行,
//5-建设银行,
//6-交通银行,
//7-中信银行,
//8-光大银行,
//9-广发银行,
//10-招商银行,
//11-兴业银行,
//12-浦发银行,
//13-上海银行,
//14-宁波银行,
//15-平安银行,
//16-兰州银行,
//17-包商银行
@interface BingBankCardModel : NSObject

//用户手机号码
@property (nonatomic, strong) NSString *userTel;
// 身份证姓名
@property (nonatomic, strong) NSString *userName;

// 身份证号码
@property (nonatomic, strong) NSString *idCardNo;

// 证件类型  目前仅支持01-身份证
@property (nonatomic, strong) NSString *idCardType;


// 银行卡号
@property (nonatomic, strong) NSString *bankCardNo;

// 开户行和名称 支持的银行详情看上方
@property (nonatomic, assign) NSInteger bankType;
@property (nonatomic, strong) NSString *bankTypeName;

// 银行卡预留手机号
@property (nonatomic, strong) NSString *bankCardTel;

// 验证码
@property (nonatomic, strong) NSString *verificationCode;

// 绑卡流水
@property (nonatomic, strong) NSString *serialNo;
@end

// 支持的银行列表
@interface BankCardListModel : NSObject

//银行名称
@property (nonatomic, strong) NSString *bankName;

// Id
@property (nonatomic, assign) NSInteger iId;

@end

// 基本信息Model
@interface BasicInfoModel : NSObject

// 个人信息
// 婚姻状态
@property (nonatomic, strong) NSString *marrStatus;
@property (nonatomic, strong) NSString *marrName;

// 学历
@property (nonatomic, strong) NSString *degree;
@property (nonatomic, strong) NSString *degreeName;

// 现居住状况
@property (nonatomic, strong) NSString *residentialStatus;
@property (nonatomic, strong) NSString *residentialName;

// 居住地址
@property (nonatomic, strong) NSString *address;

// 居住详细地址
@property (nonatomic, strong) NSString *detailAddress;

// 公司数据
@property (nonatomic, strong) NSMutableDictionary *companyInfo;

// 联系人信息
@property (nonatomic, strong) NSMutableDictionary *userRelationInfo;

// 联系人关系
@property (nonatomic, strong) NSString *contactRelation;
@property (nonatomic, strong) NSString *contactRelationName;

// 联系人姓名
@property (nonatomic, strong) NSString *contactName;

// 联系人电话
@property (nonatomic, strong) NSString *contactMobile;

// 联系人关系1
@property (nonatomic, strong) NSString *contactRelation1;
@property (nonatomic, strong) NSString *contactRelationName1;

// 联系人姓名1
@property (nonatomic, strong) NSString *contactName1;

// 联系人电话1
@property (nonatomic, strong) NSString *contactMobile1;


// 公司信息
// 单位地址
@property (nonatomic, strong) NSString *comyAddrs;

// 单位详细地址
@property (nonatomic, strong) NSString *companyDetailAddress;

// 单位名称
@property (nonatomic, strong) NSString *comyName;

// 单位电话号码
@property (nonatomic, strong) NSString *officePhone;

// 所属行业
@property (nonatomic, strong) NSString *industry;
@property (nonatomic, strong) NSString *industryName;

// 单位职能
@property (nonatomic, strong) NSString *jobRank;
@property (nonatomic, strong) NSString *jobRankName;


@end



NS_ASSUME_NONNULL_END
