//
//  RepaymentListCell.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RepaymentListCell : UITableViewCell
@property (nonatomic, strong) UILabel *codeLabel; // 编号
@property (nonatomic, strong) UILabel *moneyLabel; // 金额
@property (nonatomic, strong) UILabel *monthLabel; // 期限
@property (nonatomic, strong) UILabel *dateLabel; // 时间
@property (nonatomic, strong) UIButton *button;  // 触发事件
@property (nonatomic, strong) UILabel *statusLabbel; // 状态
@property (nonatomic, strong) UIImageView *iconImgView; // 图标

@end

