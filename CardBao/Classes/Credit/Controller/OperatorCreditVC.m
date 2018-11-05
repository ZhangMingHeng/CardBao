//
//  OperatorCreditVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/25.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "ConfirmInfoVC.h"
#import "OperatorCreditVC.h"
#import <AdSupport/AdSupport.h>
#import "CreditExtensionMainVC.h"

@interface OperatorCreditVC ()
{
    UITextField *pswInput;
    NSString *callbackUrl;
    AppDelegate *app;
    UIButton *nextButton;
    NSInteger code;
    
    NSString *latitude; // 纬度
    NSString *longitude; // 经度
    NSString *gpsProvince; // 省份
    NSString *gpsCity; // 城市
    NSString *ipAddress;
}
@end

@implementation OperatorCreditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self deviceInfo];
    code = 0;
    [self getUI];
    
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    // 添加监听事件
    [self addObserver:self forKeyPath:@"app.appURL" options:NSKeyValueObservingOptionNew context:nil];
    
}
-(void)deviceInfo {
    // IP数据
    ipAddress = [Helper isNullToString:[Helper deviceWANIPAddress] returnString:@"192.168.1.1"];
    // 位置数据
    [[LocationManager shareInstance] requestLocation:self resultBlock:^(LocationManager * _Nonnull manage, NSInteger code, NSDictionary * _Nonnull result) {
        if (code == 0) {
            self->longitude   = result[@"longitude"]; // 经度
            self->latitude    = result[@"latitude"]; // 纬度
            self->gpsCity     = [Helper isNullToString:result[@"gpsCity"] returnString:@"未知"]; // 城市
            self->gpsProvince = [Helper isNullToString:result[@"gpsProvince"] returnString:@"未知"];// 省份
            [self requestData:0];
        }
    }];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"app.appURL"]) {
        if ([app.appURL isEqualToString:URLSCHEMES]) {
            [self requestSuccess];
        }
    }
}
#pragma mark 请求数据
-(void)requestData:(NSInteger) tag {
    // 获取跳转页面的网址，如果授权成功了会返回code==5
    // deviceId: 设备Id   IMEI：imei   ip：IP地址 longiTude:经度 latiTude: 纬度  gpsCity: 城市
    // wifiMac:  wifimac  phoneModel: 手机型号  operationSys:操作系统 gpsProvince: 省份
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"equipmentInfo":@{@"deviceId":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                                                                    @"IDFA":[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                                                                                    @"phoneModel":[UIDevice currentDevice].model,
                                                                                    @"operationSys":[UIDevice currentDevice].systemName,
                                                                                    @"longiTude":longitude,
                                                                                    @"latiTude":latitude,
                                                                                    @"ip":ipAddress,
                                                                                    @"gpsProvince":gpsProvince,
                                                                                    @"gpsCity":gpsCity}} options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[RequestManager shareInstance]postWithURL:OPERATOCRH5_INTERFACE parameters:@{@"successUrl":URLSCHEMES,@"chanlRiskinfo":jsonString} isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        if ([Helper justDictionary:model]) {
            self->callbackUrl = model[@"callbackUrl"];
            if (tag == 1) [self requestSafari];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"数据解析错误" addToView:self.view];
            });
        }
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        // 授权成功了直接下一步，不需要再去运营商授权了
        if ([Helper justDictionary:model]) {
            if ([[Helper isNullToString:model[@"code"] returnString:@"0"] integerValue] == 5) {
                self->code = [[Helper isNullToString:model[@"code"] returnString:@"0"] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI线程
                    [self->nextButton setTitle:@"已授权成功,下一步" forState:UIControlStateNormal];
                });
                [self requestSuccess];
            }
        }
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void)requestSafari {
    NSURL *url = [NSURL URLWithString:[callbackUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    if (@available(iOS 10.0, *)) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url options:@{}
                                     completionHandler:^(BOOL success) {
                                         NSLog(@"Open %d",success);
                                     }];
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            NSLog(@"Open  %d",success);
        }
        
    } else{
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
-(void)requestSuccess {
    // 提交授权成功
    [[RequestManager shareInstance] postWithURL:SUBMITOPERATOCRSUCCESS_INTERFACE parameters:nil isLoading:self loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
//        if ([Helper justDictionary:model]) {
//
//        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                ConfirmInfoVC *infoVC = [ConfirmInfoVC new];
                [self addChildViewController:infoVC];
                self.childViewControllers[0].view.frame = self.view.bounds;
                [self.view addSubview:infoVC.view];
            });
//        }
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void)getUI {
    CreditExtensionMainVC *mainVC = self.navigationController.viewControllers.lastObject;
    mainVC.title                  = @"运营商授权";
    mainVC.stepLabel.text         = @"4/4";
    
//    // 手机号码
//    UILabel *phoneLabel = [UILabel new];
//    phoneLabel.text     = @"手机号码：13570435050";
//    [self.view addSubview:phoneLabel];
//
//    // 服务密码
//    UILabel *labelpsw        = [UILabel new];
//    labelpsw.text            = @"服务密码";
//    pswInput                 = [UITextField new];
//    pswInput.placeholder     = @"请输入手机服务密码";
//    pswInput.secureTextEntry = YES;
//    pswInput.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [self.view addSubview:labelpsw];
//    [self.view addSubview:pswInput];
    
    // 下一步按钮
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 20;
    nextButton.clipsToBounds      = YES;
    [nextButton setTitle:@"去运营商授权" forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
    // 布局
//    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(20);
//        make.right.equalTo(self.view).offset(-20);
//        make.top.equalTo(self.view).offset(50);
//    }];
//    [labelpsw mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(phoneLabel);
//        make.top.equalTo(phoneLabel.mas_bottom).offset(30);
//
//    }];
//    [pswInput mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(screenWidth/2.0);
//        make.left.equalTo(labelpsw.mas_right).offset(20);
//        make.top.equalTo(labelpsw);
//    }];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.top.equalTo(self.view).offset(DYCalculateHeigh(200));
        make.left.equalTo(self.view).offset(37);
        make.right.equalTo(self.view).offset(-37);
    }];
}
-(void)nextClick:(UIButton*)sender {
    // 如果已经有了appurl或者code==5 说明运营商授权成功
    if ([app.appURL isEqualToString:URLSCHEMES]||code == 5) {
        [self requestSuccess];
        return;
    }
    if (callbackUrl.length == 0) {
        [self requestData:1];
    } else {
        [self requestSafari];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 释放监听者
-(void)dealloc {
    [self removeObserver:self forKeyPath:@"app.appURL"];
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
