//
//  RepaymentDetailsCell.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RepaymentDetailsCell.h"

@implementation RepaymentDetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI {
    
    _currentTotalLabel               = [UILabel new];
    _currentTotalLabel.numberOfLines = 0;
    [self.contentView addSubview:_currentTotalLabel];
    
    // 立即还款按钮
    _repaymentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_repaymentButton setTitle:@"立即还款" forState:UIControlStateNormal];
    [_repaymentButton setTitleColor:HomeColor forState:UIControlStateNormal];
    [self.contentView addSubview:_repaymentButton];
    self.repaymentButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    // 分割线
    UILabel *separatorLine        = [UILabel new];
    separatorLine.backgroundColor = DYGrayColor(239);
    [self.contentView addSubview:separatorLine];
    // 账单期数
    _billLabel = [UILabel new];
    [self.contentView addSubview:_billLabel];
    // 应还本金
    _moneyLabel = [UILabel new];
    [self.contentView addSubview:_moneyLabel];
    // 应还利息
    _interestLabel = [UILabel new];
    [self.contentView addSubview:_interestLabel];
    // 应还时间
    _dateLabel = [UILabel new];
    [self.contentView addSubview:_dateLabel];
    // 应还罚息
    _penaltyLabel = [UILabel new];
    [self.contentView addSubview:_penaltyLabel];
    
    // 右对齐、颜色 样式
//    self.penaltyLabel.textAlignment  =
//    self.dateLabel.textAlignment     =
//    self.interestLabel.textAlignment =
//    self.moneyLabel.textAlignment    = NSTextAlignmentRight;
    self.penaltyLabel.textColor  =
    self.dateLabel.textColor     =
    self.interestLabel.textColor =
    self.moneyLabel.textColor    = DYGrayColor(161.0);
    self.penaltyLabel.font  =
    self.dateLabel.font     =
    self.interestLabel.font =
    self.moneyLabel.font    = [UIFont systemFontOfSize:12.0];
    
    // 布局
    [_currentTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    [_repaymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.currentTotalLabel);
        make.right.equalTo(self.contentView).offset(-5.0);
    }];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.0);
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.currentTotalLabel);
        make.top.equalTo(self.currentTotalLabel.mas_bottom).offset(15.0);
    }];
    [_billLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel);
        make.left.equalTo(self->_currentTotalLabel);
        make.bottom.equalTo(self->_penaltyLabel.mas_bottom);
        
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel);
        make.right.equalTo(self.contentView).offset(-15.0);
        make.top.equalTo(separatorLine.mas_bottom).offset(20.0);
        
    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_moneyLabel);
        make.top.equalTo(self->_moneyLabel.mas_bottom).offset(15);
    }];
    [_interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel);
        make.right.equalTo(self.moneyLabel);
        make.top.equalTo(self->_dateLabel.mas_bottom).offset(15);
        
    }];
    [_penaltyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel);
        make.right.equalTo(self.moneyLabel);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self->_interestLabel.mas_bottom).offset(15);
    }];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
