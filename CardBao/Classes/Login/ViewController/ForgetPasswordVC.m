//
//  ForgetPasswordVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/8/8.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "ForgetPasswordVC.h"


#define CodeNumer 120

@interface ForgetPasswordVC ()
{
    UIButton *codeButton;
    CGFloat statusHeight; // 状态栏高度
}
@property (nonatomic, assign) int countDown;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getStatusHeight];
    [self getUI];
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
-(void)getUI {
    
    self.title = @"忘记密码";
   NSArray *plArray    = @[@"请输入注册手机号码",@"请输入验证码",@"请设置新密码,6-16数字、字母或符号组成"];
    
    // 背景图
    UIImageView *backgroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Common_background"]];
    backgroundImg.contentMode  = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImg];
    
    // 自定义导航栏
    [self setNavigationViewTitle:@"忘记密码" hiddenBackButton:NO];
    
    // 背景框
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
        } else if (i == 0) {
            textfield.keyboardType = UIKeyboardTypeNumberPad;
        } else {
            textfield.secureTextEntry = YES;
        }
        
        //布局
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
    
    //  完成按钮
    UIButton *registerButton          = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.layer.cornerRadius = 20;
    registerButton.clipsToBounds      = YES;
    [registerButton setTitle:@"完 成" forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [boardView addSubview:registerButton];
    
    // 布局
    [backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    [boardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(DYCalculateHeigh(45)+self->statusHeight);
        make.bottom.equalTo(self.view).offset(-DYCalculateHeigh(45));
    }];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(boardView).offset(25);
        make.right.equalTo(boardView).offset(-25);
        make.top.equalTo(boardView).offset(220);
    }];
    
    
}
#pragma mark 提交
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
    if ([pswText.text length] < 6||[pswText.text length] > 16) {
        [Helper alertMessage:@"请输入6-16字符串" addToView:self.view];
        return;
    }
    
    [Helper resignTheFirstResponder];// 取消响应者
    
    //vCode：验证码； account：账号； password：密码
    [[RequestManager shareInstance]postWithURL:FORGET_INTERFACE parameters:@{@"vCode":codeText.text,@"account":phoneText.text,@"password":pswText.text} isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        [self.navigationController popViewControllerAnimated:YES];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
    
    
}
#pragma mark 获取验证码
-(void)getCodeClick:(UIButton*)sender {
    UITextField *phoneText = [self.view viewWithTag:1];
    if (![Helper justMobile:phoneText.text]) {
        [Helper alertMessage:@"请输入正确手机号码" addToView:self.view];
        return;
    }
    
    
    // type 2:注册 ， 1:登录 account：账号
    [[RequestManager shareInstance] postWithURL:GETCODE_INTERFACE parameters:@{@"account":phoneText.text,@"type":@2} isLoading:YES loadTitle:@"发送中..." addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [Helper alertMessage:@"发送成功" addToView:self.view];
        
        //置为第一响应
        UITextField *codeText = [self.view viewWithTag:2];
        [codeText becomeFirstResponder];
        
        // 开始倒计时
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
-(void)selectClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
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
