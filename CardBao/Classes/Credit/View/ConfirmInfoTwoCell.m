//
//  ConfirmInfoTwoCell.m
//  CardBao
//
//  Created by zhangmingheng on 2018/8/11.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "ConfirmInfoTwoCell.h"

@implementation ConfirmInfoTwoCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self getUI];
    }
    return self;
}
-(void)getUI {
    UILabel *headerTitle = [UILabel new];
    headerTitle.text     = @"基本信息";
    [self.contentView addSubview:headerTitle];
    
    // 修改信息按钮
    [self.contentView addSubview:self.changeInfo];
    
    // 布局
    [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
    }];
    [_changeInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(40);
        
    }];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.changeInfo.titleEdgeInsets = UIEdgeInsetsMake(0, -self.changeInfo.imageView.bounds.size.width, 0, self.changeInfo.imageView.bounds.size.width);
    self.changeInfo.imageEdgeInsets = UIEdgeInsetsMake(0, self.changeInfo.titleLabel.bounds.size.width, 0, -self.changeInfo.titleLabel.bounds.size.width);
}
-(UIButton*)changeInfo {
    if (!_changeInfo) {
        _changeInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeInfo.titleLabel.font = [UIFont systemFontOfSize:17];
        [_changeInfo setTitle:@"修改信息 " forState:UIControlStateNormal];
        [_changeInfo setTitleColor:HomeColor forState:UIControlStateNormal];
        [_changeInfo setImage:[UIImage imageNamed:@"Credit_right"] forState:UIControlStateNormal];
        
    }
    return _changeInfo;
}
-(void)titleArray:(NSArray <NSString*>*) titleS withValueArray:(NSArray <NSString*>*) valueS {
    
    // 防止数组
    if (titleS.count > valueS.count) return;
    
    UILabel *topValueLabel = nil;
    for (int i = 0; i<titleS.count; i++) {
        // 初始化
        UILabel *titleLabel = [UILabel new];
        UILabel *valueLabel = [UILabel new];
        titleLabel.text     = titleS[i];
        valueLabel.text     = valueS[i];
        valueLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:valueLabel];
        
        //布局
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(valueLabel);
            make.width.mas_greaterThanOrEqualTo(80);
        }];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.left.equalTo(self.contentView).offset(110);
            
            if (i == 0) make.top.equalTo(self.contentView).offset(60);
            else {
                make.top.equalTo(topValueLabel.mas_bottom).offset(15);
                
                // 最后一个给bottom值，为了适配cell高度。
                if (i == titleS.count-1) {
                    make.bottom.equalTo(self.contentView).offset(-20);
                }
            }
            
        }];
        topValueLabel = valueLabel;
        
    }
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
