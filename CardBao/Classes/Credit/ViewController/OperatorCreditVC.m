//
//  OperatorCreditVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/25.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "ConfirmInfoVC.h"
#import "OperatorCreditVC.h"
#import "CreditExtensionMainVC.h"

@interface OperatorCreditVC ()
{
    UITextField *pswInput;
    
}
@end

@implementation OperatorCreditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [pswInput becomeFirstResponder];
}
-(void)getUI {
    CreditExtensionMainVC *mainVC = self.navigationController.viewControllers.lastObject;
    mainVC.title                  = @"运营商授权";
    mainVC.stepLabel.text         = @"5/5";
    
    // 手机号码
    UILabel *phoneLabel = [UILabel new];
    phoneLabel.text     = @"手机号码：13570435050";
    [self.view addSubview:phoneLabel];
    
    // 服务密码
    UILabel *labelpsw        = [UILabel new];
    labelpsw.text            = @"服务密码";
    pswInput                 = [UITextField new];
    pswInput.placeholder     = @"请输入手机服务密码";
    pswInput.secureTextEntry = YES;
    pswInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:labelpsw];
    [self.view addSubview:pswInput];
    
    // 下一步按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 20;
    nextButton.clipsToBounds      = YES;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
    // 布局
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(50);
    }];
    [labelpsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel);
        make.top.equalTo(phoneLabel.mas_bottom).offset(30);
    
    }];
    [pswInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(screenWidth/2.0);
        make.left.equalTo(labelpsw.mas_right).offset(20);
        make.top.equalTo(labelpsw);
    }];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.bottom.equalTo(self.view).offset(-100);
    }];
}
-(void)nextClick:(UIButton*)sender {
    [Helper resignTheFirstResponder];
    
    ConfirmInfoVC *infoVC = [ConfirmInfoVC new];
    [self addChildViewController:infoVC];
    self.childViewControllers[0].view.frame = self.view.bounds;
    [self.view addSubview:infoVC.view];
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
