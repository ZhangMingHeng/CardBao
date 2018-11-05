//
//  LoginVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/16.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "CodeLoginVC.h"
#import "NSString+Base64.h"
#import "ForgetPasswordVC.h"
#import "TabBarViewController.h"

@interface LoginVC ()
{
    UITextField *phoneText;
    UITextField *passwordText;
    AppDelegate *appDele;
    CGFloat statusHeight; // 状态栏高度
    NSString *latitude; // 纬度
    NSString *longitude; // 经度
    NSString *ipAddress;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self getStatusHeight];
    [self getUI];
    [self getDeviceInfo];
    
}
-(void)getDeviceInfo {
    longitude = @"";
    latitude  = @"";
    // IP数据
    ipAddress = [Helper isNullToString:[Helper deviceWANIPAddress] returnString:@"192.168.1.1"];
    // 定位
    [[LocationManager shareInstance] requestLocation:self resultBlock:^(LocationManager * _Nonnull manage, NSInteger code, NSDictionary * _Nonnull result) {
        if (code == 0) {
            self->longitude   = result[@"longitude"]; // 经度
            self->latitude    = result[@"latitude"]; // 纬度
        }
    }];
}
-(void)getStatusHeight {
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    statusHeight = statusRect.size.height + navRect.size.height;
}
#pragma mark GetUI
-(void)getUI {
    self.title = @"登 录";
//     设置view全屏
//    self.extendedLayoutIncludesOpaqueBars = YES;
   
    // 背景图
    UIImageView *backgroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Common_background"]];
    backgroundImg.contentMode  = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImg];
    // 自定义导航栏
    [self setNavigationViewTitle:@"登 录" hiddenBackButton:YES backgroundColor:nil];
    
    // 背景框
    UIView *boardView             = [[UIView alloc] init];
    boardView.layer.shadowColor   = [UIColor blackColor].CGColor;
    boardView.layer.shadowOpacity = 0.5;
    boardView.layer.cornerRadius  = 12.0;
    boardView.layer.shadowOffset  = CGSizeMake(1, 1);
    boardView.backgroundColor     = [UIColor whiteColor];
    [self.view addSubview:boardView];
    // logo
    UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Common_logo"]];
    logoImg.contentMode  = UIViewContentModeScaleAspectFill;
    [boardView addSubview:logoImg];

    // 输入框
    // 手机
    phoneText                 = [UITextField new];
    phoneText.keyboardType    = UIKeyboardTypeNumberPad;
    phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneText.placeholder     = @"请输入您的手机号码";
//    phoneText.
    [boardView addSubview:phoneText];
    // 密码
    passwordText                 = [UITextField new];
    passwordText.secureTextEntry = YES;
    passwordText.placeholder     = @"请输入登录密码";
    passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [boardView addSubview:passwordText];
    
    // 按钮(4个)
    // 验证码登录
    UIButton *yanButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    yanButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [yanButton setTitle:@"验证码登录" forState:UIControlStateNormal];
    [yanButton setTitleColor:HomeColor forState:UIControlStateNormal];
    [yanButton addTarget:self action:@selector(yanLogin:) forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:yanButton];
    // 登录
    UIButton *loginButton          = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.layer.cornerRadius = 20;
    loginButton.clipsToBounds      = YES;
    [loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:loginButton];
    // 注册
    UIButton *registerButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:DYGrayColor(161.0) forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:registerButton];
    // 忘记密码
    UIButton *forgetButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton setTitleColor:DYColor(254.0, 116.0, 117.0) forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:forgetButton];
    
    
    // 线条
    UILabel *lineA        = [UILabel new];
    UILabel *lineB        = [UILabel new];
    lineB.backgroundColor = lineA.backgroundColor = DYGrayColor(231);
    [boardView addSubview:lineA];
    [boardView addSubview:lineB];
    NSArray *imgName = @[@"Login_phone",@"Login_psw"];
    
    for (int i = 0; i<imgName.count; i++) {
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName[i]]];
        img.contentMode  = UIViewContentModeScaleAspectFill;
        [boardView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(17);
            make.left.equalTo(boardView).offset(15);
            if (i == 0) make.centerY.equalTo(self->phoneText.mas_centerY);
            else make.centerY.equalTo(self->passwordText.mas_centerY);
        }];
    }

    // 布局
    [backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    [boardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-DYCalculateHeigh(45));
        make.top.equalTo(self.view).offset(DYCalculateHeigh(45)+self->statusHeight);
    }];
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(90);
        make.centerX.equalTo(boardView.mas_centerX);
        make.top.equalTo(boardView.mas_top).offset(44);
    }];
    [phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boardView).offset(40);
        make.right.equalTo(boardView).offset(-30);
        make.top.equalTo(logoImg.mas_bottom).offset(44);
        make.height.mas_equalTo(40);
    }];
    [passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->phoneText);
        make.right.equalTo(self->phoneText);
        make.top.equalTo(self->phoneText.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
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
        make.top.equalTo(self->passwordText.mas_bottom);
    }];
    [yanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(lineB.mas_bottom).offset(10);
    }];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(boardView).offset(25);
        make.right.equalTo(boardView).offset(-25);
        make.top.equalTo(yanButton.mas_bottom).offset(20);
    }];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(loginButton.mas_bottom).offset(10);
    }];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(loginButton.mas_bottom).offset(10);
    }];
    
}
#pragma mark 登录
-(void)loginClick:(UIButton*)sender {
    
    if (![Helper justMobile:phoneText.text]) {
        [Helper alertMessage:@"请输入正确的手机号" addToView:self.view];
        return;
    }
    if (passwordText.text.length == 0) {
        [Helper alertMessage:@"密码不能为空" addToView:self.view];
        return;
    }
    if (!longitude||!latitude||[longitude isEqualToString:@""]||[latitude isEqualToString:@""]) {
        [Helper alertMessage:@"请允许授权定位权限" addToView:self.view];
        return;
    }
    sender.enabled = NO;
    // "password": 密码； "account":账号
    NSDictionary *parameters = @{@"account":phoneText.text,
                                 @"password":passwordText.text,
                                 @"eventType":@"02",
                                 @"equipNo":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                 @"ip":ipAddress,
                                 @"longitude":longitude,
                                 @"latitude":latitude};
    [[RequestManager shareInstance]postWithURL:LOGIN_INTERFACE parameters:parameters isLoading:YES loadTitle:@"登录中..." addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
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
        sender.enabled = YES;
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        sender.enabled = YES;
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        sender.enabled = YES;
    } isCache:NO];
    
    
}
#pragma mark 跳转验证码登录页面
-(void)yanLogin:(UIButton*) sender {
    [self.navigationController pushViewController:[CodeLoginVC new] animated:YES];
}
#pragma mark 跳转注册页面
-(void)registerClick:(UIButton*)sender {
    [self.navigationController pushViewController:[RegisterVC new] animated:YES];
}
#pragma mark 跳转忘记密码页面
-(void)forgetClick:(UIButton*)sender {
    [self.navigationController pushViewController:[ForgetPasswordVC new] animated:YES];
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
