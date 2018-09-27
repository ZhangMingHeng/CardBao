//
//  RecordCell.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell
@property (nonatomic, strong) UILabel *codeLabel; // 编号
@property (nonatomic, strong) UILabel *stateLabel; // 编号
@property (nonatomic, strong) UILabel *moneyLabel; // 应还金额
@property (nonatomic, strong) UILabel *monthLabel; // 期限
@property (nonatomic, strong) UILabel *dateLabel; // 还款日
@end
