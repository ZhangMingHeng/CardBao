//
//  TabIndexView.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "TabIndexView.h"
#define UnSelecetColor [UIColor lightGrayColor]
#define SelecetColor HomeColor
@interface TabIndexView()

@property (nonatomic, strong) UILabel *pointLabelOne;
@property (nonatomic, strong) UILabel *pointLabelTwo;
@property (nonatomic, strong) UILabel *pointOne;
@property (nonatomic, strong) UILabel *pointTwo;
@end

@implementation TabIndexView

- (instancetype)init {
    if (self = [super init]) {
        
        [self setView];
        
    }
    return self;
}
#pragma mark 初始化UI
-(void)setView {
    self.frame = CGRectMake(0, 0, screenWidth, 100);
    
    [self addSubview:self.pointOne];
    [self addSubview:self.pointTwo];
    [self addSubview:self.pointLabelOne];
    [self addSubview:self.pointLabelTwo];
    
    // 提示
    // 生成附件
    NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
    textAttach.image = [UIImage imageNamed:@"Credit_tips"];
    textAttach.bounds = CGRectMake(20, -3, 15, 15);
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:textAttach];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"        请填写详细真是的信息，可加快审核、提高额度"];
    [attri insertAttributedString:imgAtt atIndex:0];
    UILabel *tipsLabel        = [UILabel new];
    tipsLabel.attributedText  = attri;
    tipsLabel.textColor       = [UIColor lightGrayColor];
    tipsLabel.font            = [UIFont systemFontOfSize:12.0];
    tipsLabel.backgroundColor = DYGrayColor(239.0);
    [self addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(30.0);
    }];
    
    // 中间线
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineLabel];
    
    // 布局
    [self.pointOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(20);
        make.height.width.mas_equalTo(20);
        make.centerX.equalTo(self).offset(-40);
    }];
    [self.pointTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(20);
        make.height.width.mas_equalTo(20);
        make.centerX.equalTo(self).offset(40);
    }];
    [self.pointLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointOne.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self).offset(-40);
    }];
    [self.pointLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointOne.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self).offset(40);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pointOne.mas_right).offset(5);
        make.right.equalTo(self.pointTwo.mas_left).offset(-5);
        make.centerY.equalTo(self.pointOne);
        make.height.mas_equalTo(1.0);
    }];
    
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.index = 0;
    
    _pointOne.layer.cornerRadius = CGRectGetWidth(_pointOne.frame)/2.0;
    _pointOne.clipsToBounds      = YES;
    _pointTwo.layer.cornerRadius = CGRectGetWidth(_pointTwo.frame)/2.0;
    _pointTwo.clipsToBounds      = YES;
}
-(UILabel*)pointOne {
    if (!_pointOne) {
        _pointOne               = [UILabel new];
        _pointOne.text          = @"1";
        _pointOne.textAlignment = NSTextAlignmentCenter;
        _pointOne.font          = [UIFont systemFontOfSize:12.0];
    }
    return _pointOne;
}
-(UILabel*)pointTwo {
    if (!_pointTwo) {
        _pointTwo               = [UILabel new];
        _pointTwo.text          = @"2";
        _pointTwo.textAlignment = NSTextAlignmentCenter;
        _pointTwo.font          = [UIFont systemFontOfSize:12.0];
    }
    return _pointTwo;
}
-(UILabel*)pointLabelTwo {
    if (!_pointLabelTwo) {
        _pointLabelTwo      = [UILabel new];
        _pointLabelTwo.text = @"单位信息";
        _pointLabelTwo.font = [UIFont systemFontOfSize:12.0];
        
    }
    return _pointLabelTwo;
}
-(UILabel*)pointLabelOne {
    if (!_pointLabelOne) {
        _pointLabelOne      = [UILabel new];
        _pointLabelOne.text = @"个人信息";
        _pointLabelOne.font = [UIFont systemFontOfSize:12.0];
    }
    return _pointLabelOne;
}

// 设置样式
-(void)setIndex:(NSInteger)index {
    _index = index;
    _pointOne.textColor = _pointTwo.textColor = [UIColor whiteColor];
    
    _pointOne.backgroundColor = index==0?SelecetColor:UnSelecetColor;
//    _pointOne.layer.borderWidth = 1.0;
    _pointLabelOne.textColor    = index==0?SelecetColor:UnSelecetColor;
    
//    _pointTwo.textColor         = index==0?UnSelecetColor:SelecetColor;
    _pointTwo.backgroundColor = index==0?UnSelecetColor:SelecetColor;
//    _pointTwo.layer.borderWidth = 1.0;
    _pointLabelTwo.textColor    = index==0?UnSelecetColor:SelecetColor;
   
}
@end
