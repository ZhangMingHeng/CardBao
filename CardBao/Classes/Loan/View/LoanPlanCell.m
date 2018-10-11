//
//  LoanPlanCell.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "LoanPlanCell.h"

@implementation LoanPlanCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}
// 子视图
-(void)setupSubviews {
    
    [self.contentView addSubview:self.dataLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.describeLabel];
    
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.width.mas_lessThanOrEqualTo(screenWidth/2.0);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_dataLabel.mas_right);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self->_dataLabel);
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self->_moneyLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}
// 创建子试图
-(void)layoutSubviews {
    [super layoutSubviews];
    self.moneyLabel.textAlignment    = NSTextAlignmentRight;
    self.describeLabel.textAlignment = NSTextAlignmentRight;
}           
-(UILabel*)dataLabel {
    if (!_dataLabel) {
        _dataLabel = [UILabel new];
    }
    return _dataLabel;
}
-(UILabel*)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
    }
    return _moneyLabel;
}
-(UILabel*)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [UILabel new];
    }
    return _describeLabel;
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
