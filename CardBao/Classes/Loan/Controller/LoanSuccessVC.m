//
//  LoanSuccessVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/23.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "ApplyRecordVC.h"
#import "LoanSuccessVC.h"

@interface LoanSuccessVC ()

@end

@implementation LoanSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
-(void)getUI {
    [self.navigationItem setTitle:@"借款申请"];
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Loan_success"]];
    [self.view addSubview:img];
    UILabel *titleLabel      = [UILabel new];
    titleLabel.text          = @"借款申请已提交，预计2个小时内完成借款审核，审核结果我们会通过短信提醒您。";
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    
    //    提交按钮
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"查看我的借款" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    submitButton.layer.cornerRadius = 20.0;
    submitButton.clipsToBounds      = YES;
    [submitButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    
    // 布局
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(DYCalculate(100));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view).offset(-DYCalculate(100));
    }];
}
-(void)submitClick {
    [self.navigationController pushViewController:[ApplyRecordVC new] animated:YES];
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
