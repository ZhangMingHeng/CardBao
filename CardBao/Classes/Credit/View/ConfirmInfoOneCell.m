//
//  ConfirmInfoOneCell.m
//  CardBao
//
//  Created by zhangmingheng on 2018/8/11.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "ConfirmInfoOneCell.h"

@implementation ConfirmInfoOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self getUI];
    }
    return self;
}
-(void)getUI {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.bankLabel];
    [self.contentView addSubview:self.bankNumLabel];
    
    
    // title
    UILabel *superTitle = nil;
    NSArray *titleArray = @[@"真实姓名",@"开户银行",@"银行卡号"];
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text     = titleArray[i];
        
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.width.mas_greaterThanOrEqualTo(70);
            if (i == 0)  make.top.equalTo(self.nameLabel);
            else if (i == 1)  make.top.equalTo(self.bankLabel);
            else  {
                make.top.equalTo(self.bankNumLabel);
            }
        }];
        if (i == 0) superTitle = titleLabel;
    }
    
    
    // 布局
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(superTitle.mas_right).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    [_bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    [_bankNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel);
        make.top.equalTo(self.bankLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];

}
-(void)layoutSubviews {
    [super layoutSubviews];
}
-(UILabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}
-(UILabel*)bankLabel {
    if (!_bankLabel) {
        _bankLabel = [UILabel new];
        _bankLabel.numberOfLines = 0;
        
    }
    return _bankLabel;
}
-(UILabel*)bankNumLabel {
    if (!_bankNumLabel) {
        _bankNumLabel = [UILabel new];
        _bankNumLabel.numberOfLines = 0;
        
    }
    return _bankNumLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
