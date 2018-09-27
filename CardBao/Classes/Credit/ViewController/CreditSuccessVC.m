//
//  CreditSuccessVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/25.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "LoanVC.h"
#import "CreditSuccessVC.h"


@interface CreditSuccessVC ()

@end

@implementation CreditSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
-(void)getUI {
    self.title = @"额度计算中";
    // icon
    UIButton *limitLabel                = [UIButton new];
    limitLabel.titleLabel.numberOfLines = 2;
    limitLabel.userInteractionEnabled   = NO;
    limitLabel.titleLabel.font          = DYNormalFont;
    limitLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [limitLabel setTitle:@"额度计算中..." forState:UIControlStateNormal];
    [limitLabel setBackgroundImage:[UIImage imageNamed:@"Loan_Background"] forState:UIControlStateNormal];
    [self.view addSubview:limitLabel];
    
    // detail
    UILabel *detailLabel      = [UILabel new];
    detailLabel.numberOfLines = 0;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.text          = @"您的额度正在计算中，预计1小时内完成，实际结果会以短信的形式通知您。";
    [self.view addSubview:detailLabel];
    // 按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.layer.cornerRadius = 20;
    backButton.clipsToBounds      = YES;
    [backButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 布局
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(DYCalculate(200));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(DYCalculateHeigh(100));
    }];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(limitLabel.mas_bottom).offset(DYCalculateHeigh(60));
    }];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(40);
        make.top.equalTo(detailLabel.mas_bottom).offset(50);
    }];
}
#pragma mark 返回首页
-(void)backClick:(UIButton*)sender {
    
    LoanVC *loanVC = self.navigationController.viewControllers[0];;
    [self.navigationController popToViewController:loanVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
