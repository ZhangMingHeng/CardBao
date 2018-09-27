//
//  PlanHeaderView.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "PlanHeaderView.h"

@implementation PlanHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}
-(void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *dateLable  = [UILabel new];
    UILabel *moneyLable = [UILabel new];
    dateLable.text      = @"预计还款日";
    moneyLable.text     = @"每月还款额";
    [self.contentView addSubview:dateLable];
    [self.contentView addSubview:moneyLable];
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = DYGrayColor(243);
    [self.contentView addSubview:lineLabel];
    
    // 布局
    [dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    [moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.height.mas_equalTo(1.0);
        make.bottom.equalTo(self.contentView);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
