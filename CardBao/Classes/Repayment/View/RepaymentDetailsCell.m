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
    
    _currentTotalLabel = [UILabel new];
    [self.contentView addSubview:_currentTotalLabel];
    
    _repaymentButton                    = [UIButton buttonWithType:UIButtonTypeCustom];
    _repaymentButton.frame              = CGRectMake(screenWidth-115, 10, 100, 40);
    _repaymentButton.layer.cornerRadius = 20;
    _repaymentButton.clipsToBounds      = YES;
    [_repaymentButton setTitle:@"立即还款" forState:UIControlStateNormal];
    [_repaymentButton setBackgroundImage:[Helper imageWithColor:HomeColor withButonWidth:100 withButtonHeight:40] forState:UIControlStateNormal];
    [self.contentView addSubview:_repaymentButton];
    
    _billLabel = [UILabel new];
    [self.contentView addSubview:_billLabel];
    
    _moneyLabel = [UILabel new];
    [self.contentView addSubview:_moneyLabel];
    
    _interestLabel = [UILabel new];
    [self.contentView addSubview:_interestLabel];
    
    _dateLabel = [UILabel new];
    [self.contentView addSubview:_dateLabel];
    
    _penaltyLabel = [UILabel new];
    [self.contentView addSubview:_penaltyLabel];
    
    // 布局
    [_currentTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(screenWidth-115);
        make.top.equalTo(self.contentView).offset(20);
    }];
    [_billLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_currentTotalLabel);
        make.top.equalTo(self->_currentTotalLabel.mas_bottom).offset(20);
        
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_currentTotalLabel);
        make.top.equalTo(self->_billLabel.mas_bottom).offset(10);
        
    }];
    [_interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self->_moneyLabel);
        
    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_currentTotalLabel);
        make.top.equalTo(self->_moneyLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    [_penaltyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self->_dateLabel);
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
