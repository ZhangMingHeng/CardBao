//
//  ApplyLoanModel.h
//  CardBao
//
//  Created by zhangmingheng on 2018/8/1.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyLoanModel : NSObject

// 可用额度
@property (nonatomic, strong) NSString *creditLimitAvailable;

// 放款金额
@property (nonatomic, strong) NSString *creditMoney;

// 放款期限
@property (nonatomic, strong) NSString *creditTerm;
@property (nonatomic, strong) NSArray *termList;

// 放款银行卡
@property (nonatomic, strong) NSString *bankCardNo;

// 放款银行卡开户行
@property (nonatomic, strong) NSString *bankName;

// 借款用途
@property (nonatomic, strong) NSString *loanOfUse;
@property (nonatomic, strong) NSString *loanOfUseNum;
@end
