//
//  ApplyLoanModel.h
//  CardBao
//
//  Created by zhangmingheng on 2018/8/1.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyLoanModel : NSObject

// 放款金额
@property (nonatomic, strong) NSString *creditMoney;

// 放款期限
@property (nonatomic, strong) NSString *creditTerm;

// 放款银行卡
@property (nonatomic, strong) NSString *bankCardNo;

// 借款用途
@property (nonatomic, strong) NSString *loanOfUse;
@end
