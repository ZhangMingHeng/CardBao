//
//  AdvanceEndAlert.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "AdvanceEndAlert.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 比例宏
#define DYCalculate(size) (size / 375.0 * screenWidth)

@interface AdvanceEndAlert()
{
    UILabel *totalLabel; // 总额
    UILabel *moneyLabel; // 本金
    UILabel *interestLabel; // 利息
    UILabel *feeLabel; // 手续费
    
}
@end

@implementation AdvanceEndAlert


- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor    = [UIColor colorWithWhite:0 alpha:0.7];
        self.frame              = CGRectMake(0, 0, WIDTH,HEIGHT);
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.window addSubview:self];
        
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews {
    [self setupAlertView];
}
- (void)setupAlertView {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(40, DYCalculateHeigh(160), WIDTH-80, 320)];
    backView.backgroundColor    = [UIColor whiteColor];
    backView.layer.cornerRadius = 10;
    backView.clipsToBounds      = YES;
    [self addSubview:backView];
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, CGRectGetWidth(backView.frame), 15)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text          = @"提前结清";
    titleLabel.font          = [UIFont systemFontOfSize:18];
    [backView addSubview:titleLabel];
    
    // 总额
    totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+20, CGRectGetWidth(backView.frame)-20, 15)];
    [backView addSubview:totalLabel];
    
    //边框
    UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(totalLabel.frame)+15, CGRectGetWidth(backView.frame)-30,115)];
    borderView.layer.borderWidth = 1;
    borderView.layer.borderColor = HomeColor.CGColor;
    [backView addSubview:borderView];
    
    // 剩余本金
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(totalLabel.frame)+30, CGRectGetWidth(backView.frame)-30, 15)];
    [backView addSubview:moneyLabel];
    // 剩余利息
    interestLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(moneyLabel.frame)+20, CGRectGetWidth(backView.frame)-30, 15)];
    [backView addSubview:interestLabel];
    // 手续费
    feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(interestLabel.frame)+20, CGRectGetWidth(backView.frame)-30, 15)];
    [backView addSubview:feeLabel];
    
    // tips
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(feeLabel.frame)+30, CGRectGetWidth(backView.frame)-10, 40)];
    tipsLabel.text          = @"提前结清手续费：剩余本金*3%（不足100按100计）";
    tipsLabel.numberOfLines = 0;
    tipsLabel.font          = [UIFont systemFontOfSize:13];
    
    [backView addSubview:tipsLabel];
    
    // 按钮
    for (int i = 0; i<2; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20+i*(CGRectGetWidth(backView.frame)-40-DYCalculate(100)), CGRectGetMaxY(tipsLabel.frame)+5, DYCalculate(100), 44)];
        [button setTitle:i==0?@"取消":@"确定" forState:UIControlStateNormal];
        button.layer.cornerRadius = 5.0;
        button.clipsToBounds      = YES;
        button.tag                = 1+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        
        // 按钮背景色
        [button setBackgroundImage:[Helper imageWithColor:i==0?[UIColor lightGrayColor]:HomeColor withButonWidth:DYCalculate(100) withButtonHeight:44] forState:UIControlStateNormal];
    }
    
}
-(void)buttonClick:(UIButton*)sender {
    [self removeFromSuperview];
    _event(sender.tag);
}
-(void)setTotalNum:(NSString *)totalNum {
    totalLabel.text = [NSString stringWithFormat:@"%@",totalNum];
}
-(void)setMoneyNum:(NSString *)moneyNum {
    moneyLabel.text = [NSString stringWithFormat:@"%@",moneyNum];
}
-(void)setInterestNum:(NSString *)interestNum {
    interestLabel.text = [NSString stringWithFormat:@"%@",interestNum];
}
-(void)setFeeNum:(NSString *)feeNum {
    feeLabel.text = [NSString stringWithFormat:@"%@",feeNum];
}
@end
