//
//  LoanPlanModel.h
//  CardBao
//
//  Created by zhangmingheng on 2018/10/23.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoanPlanModel : NSObject

// 期数
@property (nonatomic, strong) NSString *repayDate;

// 每月还款额
@property (nonatomic, strong) NSString *repayTotalMonth;

// 当期应还本金
@property (nonatomic, strong) NSString *principal;

// 当期应还利息
@property (nonatomic, strong) NSString *interest;


@end

NS_ASSUME_NONNULL_END
