//
//  RepaymentDetailsCell.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepaymentDetailsCell : UITableViewCell
@property (nonatomic, strong) UILabel *currentTotalLabel; // 当前应还金额
@property (nonatomic, strong) UILabel *billLabel; // 账单期数
@property (nonatomic, strong) UILabel *moneyLabel; // 应还本金
@property (nonatomic, strong) UILabel *dateLabel; // 应还日期
@property (nonatomic, strong) UILabel *interestLabel; // 应还利息
@property (nonatomic, strong) UILabel *penaltyLabel; // 应还罚息
@property (nonatomic, strong) UIButton *repaymentButton;  // 还款按钮
@end
