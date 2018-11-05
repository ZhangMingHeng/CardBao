//
//  BankCardModel.h
//  CardBao
//
//  Created by zhangmingheng on 2018/10/13.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

//bankId
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankCardModel : NSObject

// 卡号
@property (nonatomic, strong) NSString *bankCardNo;

// 预留手机
@property (nonatomic, strong) NSString *phoneNo;

// 开户行 详见最上方
@property (nonatomic, assign) NSInteger bankId;

@end

NS_ASSUME_NONNULL_END
