//
//  RepaymentModel.h
//  CardBao
//
//  Created by zhangmingheng on 2018/10/23.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RepaymentModel : NSObject

// ID
@property (nonatomic, assign) NSInteger iId;

// 编号
@property (nonatomic, strong) NSString *kaobaoId;

// 本期应还金额
@property (nonatomic, strong) NSString *loanAmount;

// 借款期限
@property (nonatomic, strong) NSString *loanLimit;

// 最近还款日
@property (nonatomic, strong) NSString *loanRecordTime;


@end

@interface RepaymentDetailsModel : NSObject

// 当前应还金额
@property (nonatomic, strong) NSString *currentTotal;

// 借款总额
@property (nonatomic, strong) NSString *total;

// 待还金额
@property (nonatomic, strong) NSString *repayMoney;

// 借款期限
@property (nonatomic, strong) NSString *term;

// 借款期限(当前需要还款)
@property (nonatomic, strong) NSString *currentTerm;

// 当前借款期限(当前需要还款)
@property (nonatomic, strong) NSString *totalTerm;

// 应还本金
@property (nonatomic, strong) NSString *principal;

// 应还利息
@property (nonatomic, strong) NSString *interest;

// 应还日期
@property (nonatomic, strong) NSString *date;

// 应还罚息
@property (nonatomic, strong) NSString *penaltyInterest;

// 当前是否还款 0否  1是
@property (nonatomic, strong) NSString *currentStatus;

@end

@interface RepaymentPlanModel : NSObject

// 应还日期
@property (nonatomic, strong) NSString *shouldDate;

// 还款状态
@property (nonatomic, strong) NSString *status;

// 应还款额
@property (nonatomic, strong) NSString *shouldMoney;

// 期数
@property (nonatomic, strong) NSString *currentTerm;
@end

@interface RepaymentStatementsModel : NSObject

// 还款总额
@property (nonatomic, strong) NSString *total;

// 剩余本金
@property (nonatomic, strong) NSString *principal;

// 剩余利息
@property (nonatomic, strong) NSString *interest;

// 手续费
@property (nonatomic, strong) NSString *serviceCharge;

// 违约金
@property (nonatomic, strong) NSString *damage;
@end

NS_ASSUME_NONNULL_END
