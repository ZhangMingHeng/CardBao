//
//  RegisterVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/18.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RegisterVC.h"
#import "YJBannerView.h"
#import "TabBarViewController.h"

#define CodeNumer 120

@interface RegisterVC ()<YJBannerViewDataSource, YJBannerViewDelegate>
{
    UIButton *codeButton;
    UIButton *selectButton;
    AppDelegate *appDele;
}
@property (nonatomic, assign) int countDown;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) YJBannerView *normalBannerView; /**< 普通的banner */
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self getUI];
    
    [self loadLocalData];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.normalBannerView];
    [self.normalBannerView startTimerWhenAutoScroll];
    [self.normalBannerView adjustBannerViewWhenCardScreen];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITextField *phoneText = [self.view viewWithTag:1];
    [phoneText becomeFirstResponder];
}
-(void)loadLocalData {
    [self.normalBannerView reloadData];
}
#pragma mark GETUI
-(void)getUI {
    self.title = @"注 册";
    NSArray *plArray = @[@"请输入手机号码",@"请输入验证码",@"6-16数字、字母或符号组成"];
    
    // 背景图
    UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_ Background"]];
    backImg.contentMode  = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backImg];
    
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
            [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            codeButton.titleLabel.font = DYNormalFont;
            [codeButton setBackgroundImage:[Helper imageWithColor:HomeColor withButonWidth:90 withButtonHeight:30] forState:UIControlStateNormal];
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
        [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(boardView).offset(15);
            make.top.equalTo(boardView).offset(30+(25+15*2)*i);
            make.width.height.mas_equalTo(25);
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
    UILabel *readLabel = [UILabel new];
    readLabel.text     = @"我已阅读并同意《注册协议》";
    [boardView addSubview:readLabel];
    
    // 注册按钮
    UIButton *registerButton          = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.layer.cornerRadius = 20;
    registerButton.clipsToBounds      = YES;
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:HomeColor forState:UIControlStateNormal];
    [registerButton setBackgroundColor:[UIColor whiteColor]];
//    [registerButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boardView).offset(15);
        make.bottom.equalTo(boardView).offset(-10);
        make.width.height.mas_equalTo(30);
    }];
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->selectButton.mas_right).offset(5);
        make.centerY.equalTo(self->selectButton);
    }];
    
    // 布局
    [boardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(DYCalculateHeigh(245));
        make.height.mas_equalTo(230);
    }];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(40);
        make.top.equalTo(boardView.mas_bottom).offset(20);
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
    if ([pswText.text length] < 6||[pswText.text length] > 16) {
        [Helper alertMessage:@"请输入6-16字符串的密码" addToView:self.view];
        return;
    }
    if (!selectButton.isSelected) {
        [Helper alertMessage:@"必须勾选注册协议才可以注册" addToView:self.view];
        return;
    }
    
    [Helper resignTheFirstResponder];// 取消响应者
    
    //vCode：验证码； account：账号； password：密码
    [[RequestManager shareInstance]postWithURL:REGISTER_INTERFACE parameters:@{@"vCode":codeText.text,@"account":phoneText.text,@"password":pswText.text} isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
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
#pragma mark - DataSources
- (NSArray *)bannerViewImages:(YJBannerView *)bannerView{
    return @[@"http://img.zcool.cn/community/01430a572eaaf76ac7255f9ca95d2b.jpg",
             @"http://img.zcool.cn/community/0137e656cc5df16ac7252ce6828afb.jpg",
             @"http://img.zcool.cn/community/01e5445654513e32f87512f6f748f0.png@900w_1l_2o_100sh.jpg",
             @"http://www.aykj.net/front/images/subBanner/baiduV2.jpg"
             ];
}
- (void)bannerView:(YJBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"\n\nindex:%ld\n",(long)index);
}
-(YJBannerView *)normalBannerView{
    if (!_normalBannerView) {
        
        _normalBannerView = [YJBannerView bannerViewWithFrame:CGRectMake(0, 0, screenWidth, DYCalculateHeigh(115)) dataSource:self delegate:self emptyImage:[UIImage imageNamed:@"placeholder"] placeholderImage:[UIImage imageNamed:@"placeholder"] selectorString:@"sd_setImageWithURL:placeholderImage:"];
        _normalBannerView.autoDuration = 2.5f;
        
    }
    
    return _normalBannerView;
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
