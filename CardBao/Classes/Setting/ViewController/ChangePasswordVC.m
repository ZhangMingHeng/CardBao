//
//  ChangePasswordVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/19.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITextField *textField = [self.view viewWithTag:10];
    [textField becomeFirstResponder];
}
#pragma mark GetUI
-(void)getUI {
    self.title = @"修改密码";
    
    
    // 背景框
    UIView *boardView             = [[UIView alloc] init];
    boardView.layer.shadowColor   = [UIColor blackColor].CGColor;
    boardView.layer.shadowOpacity = 0.5;
    boardView.layer.cornerRadius  = 12.0;
    boardView.layer.shadowOffset  = CGSizeMake(1, 1);
    boardView.backgroundColor     = [UIColor whiteColor];
    [self.view addSubview:boardView];
    
    [boardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(55);
        make.height.mas_equalTo(200);
    }];
    
    NSArray *plArray = @[@"请输入原密码",@"请输入新密码，6-16个字符",@"请再次输入新密码"];
    for (int i = 0; i< plArray.count; i++) {
        //title
        UILabel *label = [UILabel new];
        label.text     = i==0?@"原登录密码":@"新登录密码";
        [boardView addSubview:label];
        // 输入框
        UITextField *inputText    = [UITextField new];
        inputText.placeholder     = plArray[i];
        inputText.secureTextEntry = YES;
        inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputText.tag             = i+10;
        [boardView addSubview:inputText];
        // 线
        UILabel *lineLabel        = [UILabel new];
        lineLabel.backgroundColor = DYGrayColor(231);
        [boardView addSubview:lineLabel];
        
        // 布局
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boardView).offset(15);
            make.centerY.equalTo(inputText);
            make.width.mas_equalTo(87);
            
        }];
        [inputText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(10);
            make.right.equalTo(boardView).offset(-15);
            make.top.equalTo(boardView).offset(15+i*(40+20));
            make.height.mas_equalTo(40);
            
        }];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boardView).offset(15);
            make.right.equalTo(boardView).offset(-15);
            make.height.mas_equalTo(1);
            make.top.equalTo(inputText.mas_bottom);
        }];
    }
    
    // 按钮
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.layer.cornerRadius = 20.0;
    submitButton.clipsToBounds      = YES;
    [submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(40);
        make.top.equalTo(boardView.mas_bottom).offset(50);
    }];
}
-(void)submitClick:(UIButton*) sender {
    
    UITextField *oldPsw     = (UITextField*)[self.view viewWithTag:10];
    UITextField *newPsw     = (UITextField*)[self.view viewWithTag:11];
    UITextField *confirmPsw = (UITextField*)[self.view viewWithTag:12];
    if (newPsw.text.length<6||newPsw.text.length>16) {
        [Helper alertMessage:@"请输入6-16个字符" addToView:self.view];
        return;
    }
    if (![newPsw.text isEqualToString:confirmPsw.text]) {
        [Helper alertMessage:@"两次密码输入不一致" addToView:self.view];
        return;
    }
    
    sender.enabled = NO;
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
