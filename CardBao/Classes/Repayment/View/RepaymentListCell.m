//
//  RepaymentListCell.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RepaymentListCell.h"

#define LabelW (screenWidth-10)/3.0

@implementation RepaymentListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI {
    // icon
    _iconImgView             = [UIImageView new];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImgView];
    // 编号
    _codeLabel = [UILabel new];
    [self.contentView addSubview:_codeLabel];
    // 实线
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = DYGrayColor(239.0);
    [self.contentView addSubview:lineLabel];
    // 金额
    _moneyLabel         = [UILabel new];
    _moneyLabel.font    = [UIFont systemFontOfSize:18.0];
    [self.contentView addSubview:_moneyLabel];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.textColor     = DYColor(42.0, 112.0, 241.0);
    _moneyLabel.numberOfLines = 0;
    // 期限
    _monthLabel         = [UILabel new];
    [self.contentView addSubview:_monthLabel];
    // 时间
    _dateLabel         = [UILabel new];
    [self.contentView addSubview:_dateLabel];
    // 事件
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitleColor:HomeColor forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_button];
    // 状态
    _statusLabbel = [UILabel new];
    [self.contentView addSubview:_statusLabbel];
    
    // 样式
   _statusLabbel.font      = _dateLabel.font      = _monthLabel.font      = [UIFont systemFontOfSize:12.0];
   _statusLabbel.textColor = _dateLabel.textColor = _monthLabel.textColor = DYGrayColor(161);
    
    // 布局
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(15);
    }];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self->_codeLabel);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.codeLabel.mas_bottom).offset(15.0);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthLabel);
//        make.bottom.equalTo(self.dateLabel);
        make.left.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
    }];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel);
        make.top.equalTo(lineLabel.mas_bottom).offset(15);
        make.right.equalTo(self.contentView).offset(-15.0);
    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.monthLabel);
        make.top.equalTo(self.monthLabel.mas_bottom).offset(12.0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
    }];
    // 注册监听者
    [self addObserver:self forKeyPath:@"self.iconImgView.image" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"self.dateLabel.text" options:NSKeyValueObservingOptionNew context:nil];
}
// 监听回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"self.iconImgView.image"]) {
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(31.0);
            make.top.equalTo(self.contentView).offset(9);
            make.left.equalTo(self.contentView).offset(20);
        }];
        [_codeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(60.0);
        }];
    } else if ([keyPath isEqualToString:@"self.dateLabel.text"]) {
      
        [_dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.monthLabel);
            make.top.equalTo(self.monthLabel.mas_bottom).offset(8.0);
        }];
        [_statusLabbel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.monthLabel);
            make.right.equalTo(self.monthLabel);
            make.top.equalTo(self.dateLabel.mas_bottom).offset(8.0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
        }];
    }
}
// 释放监听者
-(void)dealloc {
    [self removeObserver:self forKeyPath:@"self.iconImgView.image"];
    [self removeObserver:self forKeyPath:@"self.dateLabel.text"];
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
