//
//  CodeLoginVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/18.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RegisterVC.h"
#import "CodeLoginVC.h"
#import "TabBarViewController.h"

#define CodeNumer 120

@interface CodeLoginVC ()
{
    UITextField *phoneText;
    UITextField *codeText;
    UIButton *codeButton;
    AppDelegate *appDele;
}
@property (nonatomic, assign) int countDown;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CodeLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self getUI];
}
#pragma mark getUI
-(void)getUI {
    self.title = @"登 录";
    
    // 背景框
    UIView *boardView             = [[UIView alloc] init];
    boardView.layer.shadowColor   = [UIColor blackColor].CGColor;
    boardView.layer.shadowOpacity = 0.5;
    boardView.layer.cornerRadius  = 12.0;
    boardView.layer.shadowOffset  = CGSizeMake(1, 1);
    boardView.backgroundColor     = [UIColor whiteColor];
    [self.view addSubview:boardView];
    
    // 输入框
    // 手机
    phoneText                 = [UITextField new];
    phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneText.keyboardType    = UIKeyboardTypeNumberPad;
    phoneText.placeholder     = @"请输入您的手机号码";
    [boardView addSubview:phoneText];
    // 密码
    codeText                 = [UITextField new];
    codeText.keyboardType    = UIKeyboardTypeNumberPad;
    codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeText.placeholder     = @"请输入验证码";
    [boardView addSubview:codeText];
    // 获取验证码
    codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeButton.titleLabel.font = DYNormalFont;
    [codeButton setBackgroundImage:[Helper imageWithColor:HomeColor withButonWidth:90 withButtonHeight:30] forState:UIControlStateNormal];
    [codeButton addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    codeButton.layer.cornerRadius = 5;
    codeButton.clipsToBounds      = YES;
    [boardView addSubview:codeButton];
    // 登录
    UIButton *loginButton          = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.layer.cornerRadius = 20;
    loginButton.clipsToBounds      = YES;
    [loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    // 注册
    UIButton *registerButton      = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:HomeColor forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    // 密码
    UIButton *pswButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    pswButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [pswButton setTitle:@"密码登录" forState:UIControlStateNormal];
    [pswButton setTitleColor:HomeColor forState:UIControlStateNormal];
    [pswButton addTarget:self action:@selector(passwordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pswButton];
    
    // 线条
    UILabel *lineA        = [UILabel new];
    UILabel *lineB        = [UILabel new];
    lineB.backgroundColor = lineA.backgroundColor = DYGrayColor(231);
    [boardView addSubview:lineA];
    [boardView addSubview:lineB];
    
    
    // 布局
    [boardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(55);
        make.height.mas_equalTo(130);
    }];
    [phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boardView).offset(30);
        make.right.equalTo(boardView).offset(-30);
        make.top.equalTo(boardView).offset(15);
        make.height.mas_equalTo(40);
    }];
    [codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->phoneText);
        make.right.equalTo(self->codeButton.mas_left);
        make.top.equalTo(self->phoneText.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(boardView).offset(-30);
        make.centerY.equalTo(self->codeText.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(90);
    }];
    [lineA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boardView).offset(15);
        make.right.equalTo(boardView).offset(-15);
        make.height.mas_equalTo(1);
        make.top.equalTo(self->phoneText.mas_bottom);
    }];
    [lineB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineA);
        make.right.equalTo(lineA);
        make.height.mas_equalTo(1);
        make.top.equalTo(self->codeText.mas_bottom);
    }];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.top.equalTo(boardView.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
    }];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(loginButton.mas_bottom).offset(10);
    }];
    [pswButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(loginButton.mas_bottom).offset(10);
    }];
    
}
#pragma mark 登录
-(void)loginClick:(UIButton*)sender {
    if (![Helper justMobile:phoneText.text]  ) {
        [Helper alertMessage:@"请输入正确的手机号码" addToView:self.view];
        return;
    }
    if ([codeText.text length] == 0) {
        [Helper alertMessage:@"请输入验证码" addToView:self.view];
        return;
    }
    
    // 取消第一响应者
    [Helper resignTheFirstResponder];
    
    
    // "xCode" 验证码； "account":账号
    [[RequestManager shareInstance]postWithURL:CODELOGIN_INTERFACE parameters:@{@"vCode":codeText.text,@"account":phoneText.text} isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        NSDictionary *dic = model;
        
        if ([Helper justDictionary:dic]) {
            NSString *token = dic[@"token"];
            if (token.length != 0 ) {
                INPUTTOKEN(dic[@"token"]);
                INPUTLoginState(YES);
                INPUTUserPHONE(self->phoneText.text);
                self->appDele.window.rootViewController = [TabBarViewController new];
                return ;
            }
        }
        [Helper alertMessage:@"登录失败" addToView:self.view];
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
#pragma mark 返回
-(void)passwordClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 跳转注册页面
-(void)registerClick:(UIButton*)sender {
    // 注册和忘记密码公用一个页面
    [self.navigationController pushViewController:[RegisterVC new] animated:YES];
}
#pragma mark 获取验证码
-(void)getCodeClick:(UIButton*)sender {
 
    if (![Helper justMobile:phoneText.text]) {
        [Helper alertMessage:@"请输入正确手机号码" addToView:self.view];
        return;
    }
    // type 2:注册 ， 1:登录 ； "account":账号
    [[RequestManager shareInstance] postWithURL:GETCODE_INTERFACE parameters:@{@"account":phoneText.text,@"type":@1} isLoading:YES loadTitle:@"发送中..." addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        [Helper alertMessage:@"发送成功" addToView:self.view];
        
        // 置为第一响应者
        [self->codeText becomeFirstResponder];
        
        // 开始倒计时
        self.countDown = CodeNumer;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        [self->codeText becomeFirstResponder];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        self->_countDown = CodeNumer;
        
        [self.timer invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setEnabled:YES];
            [sender setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        });
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        self->_countDown = CodeNumer;
        [self.timer invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setEnabled:YES];
            [sender setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        });
    } isCache:NO];
}
-(void)handleTimer{
    UIButton *button = codeButton;
    if (_countDown>0) {
        [button setEnabled:NO];
        [button setTitle:[NSString stringWithFormat:@"%d秒",self->_countDown] forState:UIControlStateNormal];
    } else {
        _countDown = CodeNumer;
        [self.timer invalidate];
        [button setEnabled:YES];
        [button setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
    }
    _countDown = _countDown-1;
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
