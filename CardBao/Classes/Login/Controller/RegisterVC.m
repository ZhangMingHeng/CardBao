//
//  RegisterVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/18.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RegisterVC.h"
#import "ProtocolWebViewVC.h"
#import "TabBarViewController.h"

#define CodeNumer 120

@interface RegisterVC ()<UITextViewDelegate>
{
    UIButton *codeButton;
    UIButton *selectButton;
    AppDelegate *appDele;
    CGFloat statusHeight; // 状态栏高度
    NSString *latitude; // 纬度
    NSString *longitude; // 经度
    NSString *ipAddress;
}
@property (nonatomic, assign) int countDown;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self getDeviceInfo];
    [self getStatusHeight];
    [self getUI];
    
}
-(void)getDeviceInfo {
    longitude = @"";
    latitude  = @"";
    // IP数据
    ipAddress = [Helper isNullToString:[Helper deviceWANIPAddress] returnString:@"192.168.1.1"];
    // 定位
    [[LocationManager shareInstance] requestLocation:self resultBlock:^(LocationManager * _Nonnull manage, NSInteger code, NSDictionary * _Nonnull result) {
        if (code == 0) {
            self->longitude = result[@"longitude"]; // 经度
            self->latitude  = result[@"latitude"]; // 纬度
        }
    }];
}
-(void)getStatusHeight {
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    statusHeight = statusRect.size.height + navRect.size.height;
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITextField *phoneText = [self.view viewWithTag:1];
    [phoneText becomeFirstResponder];
}
#pragma mark GETUI
-(void)getUI {
    self.title = @"注 册";
    
    // 背景图
    UIImageView *backgroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Common_background"]];
    backgroundImg.contentMode  = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImg];
    // 自定义导航栏
    [self setNavigationViewTitle:@"注 册" hiddenBackButton:NO backgroundColor:nil];
    
    NSArray *plArray = @[@"请输入手机号码",@"请输入验证码",@"密码 6-16数字、字母或符号组成"];
    
    // 背景输入框
    UIView *boardView             = [[UIView alloc] init];
    boardView.layer.shadowColor   = [UIColor blackColor].CGColor;
    boardView.layer.shadowOpacity = 0.5;
    boardView.layer.cornerRadius  = 12.0;
    boardView.layer.shadowOffset  = CGSizeMake(1, 1);
    boardView.backgroundColor     = [UIColor whiteColor];
    [self.view addSubview:boardView];
    // 输入框
    NSArray *imgName = @[@"Login_phone",@"Login_yan",@"Login_psw"];
    for (int i = 0; i<plArray.count; i++) {
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName[i]]];
        img.contentMode  = UIViewContentModeScaleAspectFill;
        [boardView addSubview:img];
        UITextField *textfield    = [UITextField new];
        textfield.placeholder     = plArray[i];
        textfield.tag             = 1+i;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        [boardView addSubview:textfield];
        UILabel *linelabel        = [UILabel new];
        linelabel.backgroundColor = DYGrayColor(231);
        [boardView  addSubview:linelabel];
        
        // 获取验证码按钮
        if (i == 1) {
            codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            codeButton.titleLabel.font = DYNormalFont;
            [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [codeButton setTitleColor:HomeColor forState:UIControlStateNormal];
            [codeButton addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
            codeButton.layer.cornerRadius = 5;
            codeButton.clipsToBounds      = YES;
            [boardView addSubview:codeButton];
            [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(boardView.mas_right).offset(-15);
                make.centerY.equalTo(textfield.mas_centerY);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(90);
            }];
        } else if (i == 0) textfield.keyboardType = UIKeyboardTypeNumberPad;
        else textfield.secureTextEntry = YES;
        
        //布局
        [backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boardView).offset(15);
            make.top.equalTo(boardView).offset(40+(25+15*2)*i);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(17);
        }];
        [linelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boardView).offset(15);
            make.right.equalTo(boardView).offset(-15);
            make.height.mas_equalTo(1);
            make.top.equalTo(img.mas_bottom).offset(15);
        }];
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(img.mas_right).offset(10);
            
            make.centerY.equalTo(img.mas_centerY);
            make.height.mas_equalTo(40);
            if (i == 1) {
                make.right.equalTo(self->codeButton.mas_left);
            } else {
                make.right.equalTo(self.view).offset(-15);
            }
        }];
    }
    //协议
    selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setImage:[UIImage imageNamed:@"Login_unselect"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"Login_select"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:selectButton];
    
    // 阅读文字
    UITextView *readLabel        = [UITextView new];
    readLabel.attributedText     = [Helper setAttributedString:@"我已阅读并同意《注册协议》" selectStrings:@[@"《注册协议》"]];
    readLabel.linkTextAttributes = @{NSForegroundColorAttributeName:HomeColor};
    readLabel.scrollEnabled      = NO;
    readLabel.delegate           = self;
    readLabel.editable           = NO;
    readLabel.font               = [UIFont systemFontOfSize:14];
    readLabel.textColor          = DYGrayColor(161.0);
    [boardView addSubview:readLabel];
    
    // 注册按钮
    UIButton *registerButton          = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.layer.cornerRadius = 20;
    registerButton.clipsToBounds      = YES;
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:registerButton];
    
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.left.equalTo(boardView).offset(15);
        make.top.equalTo(boardView).offset(190);
    }];
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->selectButton);
        make.left.equalTo(self->selectButton.mas_right).offset(5);
    }];
    
    // 布局
    [boardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-DYCalculateHeigh(45));
        make.top.equalTo(self.view).offset(DYCalculateHeigh(45)+self->statusHeight);
    }];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(boardView).offset(25);
        make.right.equalTo(boardView).offset(-25);
        make.top.equalTo(readLabel.mas_bottom).offset(40);
    }];
}
-(void)selectClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
#pragma mark 注册
-(void)registerClick:(UIButton*)sender {
    UITextField *phoneText = [self.view viewWithTag:1];
    UITextField *codeText  = [self.view viewWithTag:2];
    UITextField *pswText   = [self.view viewWithTag:3];
    if (![Helper justMobile:phoneText.text]) {
        [Helper alertMessage:@"请输入正确手机号码" addToView:self.view];
        return;
    }
    if ([codeText.text length] == 0) {
        [Helper alertMessage:@"请输入验证码" addToView:self.view];
        return;
    }
    if ([codeText.text length] > 6) {
        [Helper alertMessage:@"请输入正确的验证码" addToView:self.view];
        return;
    }
    if ([pswText.text length] < 6||[pswText.text length] > 16) {
        [Helper alertMessage:@"请输入6-16字符串的密码" addToView:self.view];
        return;
    }
    if (!selectButton.isSelected) {
        [Helper alertMessage:@"必须勾选注册协议才可以注册" addToView:self.view];
        return;
    }
    if (!longitude||!latitude||[longitude isEqualToString:@""]||[latitude isEqualToString:@""]) {
        [Helper alertMessage:@"请允许授权定位权限" addToView:self.view];
        return;
    }
    [Helper resignTheFirstResponder];// 取消响应者
    sender.enabled = NO;
    //vCode：验证码； account：账号； password：密码
    // eventType:事件  equipNo：devcieId latitude:纬度 longitude:经度
    NSDictionary *parameters = @{@"vCode":codeText.text,
                                 @"account":phoneText.text,
                                 @"password":pswText.text,
                                 @"eventType":@"01",
                                 @"equipNo":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                 @"ip":ipAddress,
                                 @"longitude":longitude,
                                 @"latitude":latitude} ;
    [[RequestManager shareInstance]postWithURL:REGISTER_INTERFACE parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        NSDictionary *dic = model;
        if ([Helper justDictionary:dic]) {
            NSString *token = dic[@"token"];
            if (token.length != 0 ) {
                INPUTTOKEN(dic[@"token"]);
                INPUTLoginState(YES);
                INPUTUserPHONE(phoneText.text);
                
                self->appDele.window.rootViewController = [TabBarViewController new];
                return ;
            }
        }
        [Helper alertMessage:@"注册失败" addToView:self.view];
        sender.enabled = YES;
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        sender.enabled = YES;
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        sender.enabled = YES;
    } isCache:NO];
}
#pragma mark 获取验证码
-(void)getCodeClick:(UIButton*)sender {
    UITextField *phoneText = [self.view viewWithTag:1];
    if (![Helper justMobile:phoneText.text]) {
        [Helper alertMessage:@"请输入正确手机号码" addToView:self.view];
        return;
    }
    
    // type 2:注册 ， 1:登录  account：账号
    [[RequestManager shareInstance] postWithURL:GETCODE_INTERFACE parameters:@{@"account":phoneText.text,@"type":@2} isLoading:YES loadTitle:@"发送中..." addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [Helper alertMessage:@"发送成功" addToView:self.view];
        
        //置为第一响应
        UITextField *codeText = [self.view viewWithTag:2];
        [codeText becomeFirstResponder];
        
        // 开启倒计时
        self->_countDown = CodeNumer;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        
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
#pragma mark TextView Protocol
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"select0"]) {
        [self.navigationController pushViewController:[ProtocolWebViewVC new] animated:YES];
        return NO;
    }
    return YES;
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
