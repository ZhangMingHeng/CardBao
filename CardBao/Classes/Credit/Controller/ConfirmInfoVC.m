//
//  ConfirmInfoVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/25.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//
#import "CreditModel.h"
#import "BasicInfoVC.h"
#import "CodeAlertView.h"
#import "ConfirmInfoVC.h"
#import "CreditSuccessVC.h"
#import "ProtocolWebViewVC.h"
#import "ConfirmInfoOneCell.h"
#import "ConfirmInfoTwoCell.h"
#import <AdSupport/AdSupport.h>
#import "CreditExtensionMainVC.h"

@interface ConfirmInfoVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    BOOL isUpDate; // 是否刷新
    UITableView *listTableView;
    UIButton *selectButton;
    CreditExtensionMainVC *mainVC;
    BasicInfoModel *infoModel;
    NSString *userName; // 用户名
    NSString *bankName; // 开户行
    NSString *bandIdNo; // 银行卡号
    
    NSString *latitude; // 纬度
    NSString *longitude; // 经度
    NSString *gpsProvince; // 省份
    NSString *gpsCity; // 城市
    NSString *ipAddress;
}
@end

@implementation ConfirmInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self deviceInfo];
    [self getUI];
    [self requestData];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Helper resignTheFirstResponder];
    if (isUpDate) [self requestData];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self->isUpDate = YES;
    });
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
        }
    }];
}
-(void)requestData {
    [[RequestManager shareInstance]postWithURL:GETBASICINFO_INTERFACE parameters:nil isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        if ([Helper justDictionary:model]) {
            //银行信息
            self->userName = model[@"userName"];
            self->bankName = model[@"bankName"];
            self->bandIdNo = model[@"bandIdNo"];
            
            // 基本信息数据
            self->infoModel = [BasicInfoModel yy_modelWithJSON:model];
            if ([Helper justDictionary:model[@"degree"]]) {
                self->infoModel.degree     = model[@"degree"][@"typeId"];
                self->infoModel.degreeName = model[@"degree"][@"content"];
            }
            if ([Helper justDictionary:model[@"marrStatus"]]) {
                self->infoModel.marrStatus = model[@"marrStatus"][@"typeId"];
                self->infoModel.marrName   = model[@"marrStatus"][@"content"];
            }
            if ([Helper justDictionary:model[@"residentialStatus"]]) {
                self->infoModel.residentialStatus = model[@"residentialStatus"][@"typeId"];
                self->infoModel.residentialName   = model[@"residentialStatus"][@"content"];
            }
            //基本数据里面的公司信息
            NSDictionary *companyDic = model[@"companyInfo"];
            if ([Helper justDictionary:companyDic]) {
                self->infoModel.comyName             = companyDic[@"comyName"];
                self->infoModel.comyAddrs            = companyDic[@"comyAddrs"];
                self->infoModel.companyDetailAddress = companyDic[@"companyDetailAddress"];
                self->infoModel.officePhone          = companyDic[@"officePhone"];
                if ([Helper justDictionary:companyDic[@"industry"]]) {
                    self->infoModel.industry     = companyDic[@"industry"][@"typeId"];
                    self->infoModel.industryName = companyDic[@"industry"][@"content"];
                }
                if ([Helper justDictionary:companyDic[@"jobRank"]]) {
                    self->infoModel.jobRank     = companyDic[@"jobRank"][@"typeId"];
                    self->infoModel.jobRankName = companyDic[@"jobRank"][@"content"];
                }
            }
            //基本数据里面的联系人信息
            NSArray *userArray = model[@"userRelationInfo"];
            if ([Helper justArray:userArray]) {
                if (userArray.count==2) {
                    [userArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary *objDic = obj;
                        if ([Helper justDictionary:objDic]) {
                            if (idx == 0) {
                                self->infoModel.contactName     = objDic[@"contactName"];
                                self->infoModel.contactMobile   = objDic[@"contactMobile"];
                                if ([Helper justDictionary:objDic[@"contactRelation"]]) {
                                    self->infoModel.contactRelation = objDic[@"contactRelation"][@"typeId"];
                                    self->infoModel.contactRelationName = objDic[@"contactRelation"][@"content"];
                                }
                            } else {
                                self->infoModel.contactName1     = objDic[@"contactName"];
                                self->infoModel.contactMobile1   = objDic[@"contactMobile"];
                                if ([Helper justDictionary:objDic[@"contactRelation"]]) {
                                    self->infoModel.contactRelation1 = objDic[@"contactRelation"][@"typeId"];
                                    self->infoModel.contactRelationName1 = objDic[@"contactRelation"][@"content"];
                                }
                            }
                        }
                    }];
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"基本信息数据解析错误" addToView:self.view];
            });
        }
        [self->listTableView reloadData];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
#pragma mark getUI
-(void)getUI {
    mainVC = self.navigationController.viewControllers.lastObject;
    mainVC.title                  = @"信息确认";
    mainVC.stepLabel.text         = @"";
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource         = self;
    listTableView.delegate           = self;
    listTableView.estimatedRowHeight = 200;
    listTableView.estimatedSectionHeaderHeight = 10.0;
    listTableView.tableFooterView    = [UIView new];
    listTableView.backgroundColor    = DYGrayColor(243);
    [listTableView registerClass:[ConfirmInfoOneCell class] forCellReuseIdentifier:@"ConfirmInfoOneCell"];
    [listTableView registerClass:[ConfirmInfoTwoCell class] forCellReuseIdentifier:@"ConfirmInfoTwoCell"];
    [self.view addSubview:listTableView];
    
    // FootView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 230)];
    // 勾选框
    selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setImage:[UIImage imageNamed:@"Login_unselect"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"Login_select"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:selectButton];
    // 阅读文字
    UITextView *readLabel        = [UITextView new];
    readLabel.linkTextAttributes = @{NSForegroundColorAttributeName:HomeColor};
    readLabel.scrollEnabled      = NO;
    readLabel.delegate           = self;
    readLabel.editable           = NO;
    readLabel.attributedText     = [Helper setAttributedString:@"我已阅读并同意《包商银行个人信息查询协议》《个人信息使用及第三方机构数据授权查询书》"
                                                 selectStrings:@[@"《包商银行个人信息查询协议》",@"《个人信息使用及第三方机构数据授权查询书》"]];
    readLabel.font               = [UIFont systemFontOfSize:17.0];
    readLabel.backgroundColor    = [UIColor clearColor];
    [footView addSubview:readLabel];
    //  提交
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 20;
    nextButton.clipsToBounds      = YES;
    [nextButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextButton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->listTableView.tableFooterView = footView;
    });
    
    // 布局
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.top.equalTo(footView).offset(13);
        make.left.equalTo(footView).offset(12);
    }];
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->selectButton.mas_right).offset(5);
        make.top.equalTo(footView).offset(10);
        make.right.equalTo(footView);
    }];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(footView).offset(37);
        make.right.equalTo(footView).offset(-37);
        make.top.equalTo(readLabel.mas_bottom).offset(30);
    }];
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ConfirmInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmInfoOneCell"];
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text      = [Helper isNullToString:userName returnString:@" "];
        cell.bankLabel.text      = [Helper isNullToString:bankName returnString:@" "];
        cell.bankNumLabel.text   = [Helper isNullToString:bandIdNo returnString:@" "];
        
        return cell;
    } else {
        
        NSString *contactA = [NSString stringWithFormat:@"%@-%@-%@",[Helper isNullToString:infoModel.contactRelationName returnString:@" "],
                              [Helper isNullToString:infoModel.contactName returnString:@" "],[Helper isNullToString:infoModel.contactMobile returnString:@" "]];
        NSString *contactB = [NSString stringWithFormat:@"%@-%@-%@",[Helper isNullToString:infoModel.contactRelationName1 returnString:@" "],
                              [Helper isNullToString:infoModel.contactName1 returnString:@" "],[Helper isNullToString:infoModel.contactMobile1 returnString:@" "]];
        
        ConfirmInfoTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmInfoTwoCell"];
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
    
        
        [cell titleArray:@[@"居住地址",@"详细地址",@"学历信息",@"居住情况",@"婚姻状况",@"联系人1",@"联系人2",@"单位地址",@"详细地址",@"单位名称",@"单位电话",@"所属行业",@"单位职能"]
          withValueArray:@[[Helper isNullToString:infoModel.address returnString:@" "],
                           [Helper isNullToString:infoModel.detailAddress returnString:@" "],
                           [Helper isNullToString:infoModel.degreeName returnString:@" "],
                           [Helper isNullToString:infoModel.residentialName returnString:@" "],
                           [Helper isNullToString:infoModel.marrName returnString:@" "],
                           contactA,contactB,
                           [Helper isNullToString:infoModel.comyAddrs returnString:@" "],
                           [Helper isNullToString:infoModel.companyDetailAddress returnString:@" "],
                           [Helper isNullToString:infoModel.comyName returnString:@" "],
                           [Helper isNullToString:infoModel.officePhone returnString:@" "],
                           [Helper isNullToString:infoModel.industryName returnString:@" "],
                           [Helper isNullToString:infoModel.jobRankName returnString:@" "],]];
        [cell.changeInfo addTarget:self action:@selector(changeInfoClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

}
-(void)nextClick:(UIButton*)sender {
    if (!selectButton.isSelected) {
        [Helper alertMessage:@"请先阅读并同意协议" addToView:self.view];
        return;
    }
    typeof(self) weakSelf = self;
    CodeAlertView *codeView = [[CodeAlertView alloc]init];
    codeView.phoneNum       = kUserPHONE;
    codeView.submitEvent    = ^(NSInteger index, NSString *codeNum) {
        // index ' 1=验证码，9=取消，10=确定  codeNum:验证码
        
        if (index == 1) [weakSelf getCode];
        
        if (index == 10&&(codeNum.length == 0||codeNum.length > 6)) {
            [Helper alertMessage:@"请输入正确的验证码" addToView:self.view];
            return;
        }
        
        if (index == 10&&codeNum.length > 0) [weakSelf confirmApplyLoan:codeNum];
        
    };
    [self.view addSubview:codeView];
}
#pragma mark 获取验证码
-(void)getCode {
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
    // chanlRiskinfo: 风险信息
    NSDictionary *parameters = @{@"chanlRiskinfo":jsonString};
    [[RequestManager shareInstance]postWithURL:GETCREDITMSG_INTERFACE parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
#pragma mark 确认申请授权，并验证验证码
-(void)confirmApplyLoan:(NSString*) num {
    // 提交验证码
    [[RequestManager shareInstance]postWithURL:GETCREDITVALID_INTERFACE parameters:@{@"verificationCode":num} isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->mainVC.navigationController pushViewController:[CreditSuccessVC new] animated:YES];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
    
}
#pragma mark 修改信息
-(void)changeInfoClick:(UIButton*)sender {
    BasicInfoVC *infoVC     = [BasicInfoVC new];
    infoVC.baseViewPushType = NSBaseViewPushTypeChangeInfo;
    infoVC.basicModel       = infoModel;
    [mainVC.navigationController pushViewController:infoVC animated:YES];
}
-(void)selectClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
#pragma mark TextView Protocol
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    ProtocolWebViewVC *webVC = [ProtocolWebViewVC new];
    webVC.baseViewPushType   = NSprotocolViewPushTypeConfirm;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    if ([[URL scheme] isEqualToString:@"select0"]) {
        webVC.title = @"包商银行个人信息查询协议";
        return NO;
    } else if ([[URL scheme] isEqualToString:@"select1"]) {
        webVC.title = @"个人信息使用及第三方机构数据授权查询书";
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
