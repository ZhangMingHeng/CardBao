//
//  BingBankCardVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "IdentityVC.h"
#import "CreditModel.h"
#import "BingBankCardVC.h"
#import <AdSupport/AdSupport.h>
#import "CreditExtensionMainVC.h"
#define CodeNumer 120

@interface BingBankCardVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSArray *titleArray;
    UITableView *listTableView;
    NSArray *placeholder;
    UIButton *codeButton;
    NSMutableArray *bankCardList;
    NSInteger bankType;
    NSString *latitude; // 纬度
    NSString *longitude; // 经度
    NSString *gpsProvince; // 省份
    NSString *gpsCity; // 城市
    NSString *ipAddress;
    
}
@property (nonatomic, assign) int countDown;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) BingBankCardModel *bankCardModel; // 绑卡数据

@end

@implementation BingBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self localData];
    [self getUI];
}
-(void)localData {
    // 初始化数据
    _bankCardModel            = [BingBankCardModel new];
    _bankCardModel.userTel    = kUserPHONE;
    _bankCardModel.idCardType = @"01";
//    if (_userName&&_idCardNo) {
//        _bankCardModel.userName = _userName;
//        _bankCardModel.idCardNo = _idCardNo;
//    }
    titleArray     = @[@"真实姓名",@"身份证号",@"银行卡号",@"开户银行",@"预留手机号"];
    placeholder    = @[@"请输入姓名",@"请输入身份证号",@"请输入银行卡号",@"请选择开户行",@"请输入预留手机号"];
    // 银行列表
    bankCardList   = [NSMutableArray new];
    
    // IP数据
    ipAddress = [Helper isNullToString:[Helper deviceWANIPAddress] returnString:@"192.168.1.1"];
    // 位置数据
    longitude = @"";
    latitude  = @"";
    [[LocationManager shareInstance] requestLocation:self resultBlock:^(LocationManager * _Nonnull manage, NSInteger code, NSDictionary * _Nonnull result) {
        if (code == 0) {
            self->longitude   = result[@"longitude"]; // 经度
            self->latitude    = result[@"latitude"]; // 纬度
            self->gpsCity     = [Helper isNullToString:result[@"gpsCity"] returnString:@"未知"]; // 城市
            self->gpsProvince = [Helper isNullToString:result[@"gpsProvince"] returnString:@"未知"];// 省份
        }
    }];
}
#pragma mark getUI
-(void)getUI {
    CreditExtensionMainVC *viewC = self.navigationController.viewControllers.lastObject;
    viewC.title = @"绑定银行卡";
    viewC.stepLabel.text = @"1/4";
    
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.rowHeight       = 50;
    listTableView.tableFooterView = [UIView new];
    listTableView.backgroundColor = DYGrayColor(239.0);
    [self.view addSubview:listTableView];
    
    // FootView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 160)];
//    // 上一步按钮
//    UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    lastButton.layer.cornerRadius = 20;
//    lastButton.clipsToBounds      = YES;
//    [lastButton setTitle:@"上一步" forState:UIControlStateNormal];
//    [lastButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
//    [lastButton addTarget:self action:@selector(lastClick:) forControlEvents:UIControlEventTouchUpInside];
//    [footView addSubview:lastButton];
    // 下一步按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 20;
    nextButton.clipsToBounds      = YES;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
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
//    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(45);
//        make.top.equalTo(footView).offset(50);
//        make.left.equalTo(footView).offset(37);
//        make.right.equalTo(footView).offset(-37);
//    }];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(footView).offset(37);
        make.right.equalTo(footView).offset(-37);
        make.bottom.equalTo(footView.mas_bottom).offset(-20);
    }];
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF  = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.textLabel.text   = titleArray[indexPath.row];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    // 输入框
    UITextField *input = [UITextField new];
    input.placeholder  = placeholder[indexPath.row];
    input.tag          = indexPath.row+20;
    input.delegate     = self;
    [cell.contentView addSubview:input];
    if (indexPath.row == 5) {
        // 获取验证码
        codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeButton addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        [codeButton setBackgroundImage:[Helper imageWithColor:HomeColor withButonWidth:92 withButtonHeight:30] forState:UIControlStateNormal];
        codeButton.layer.cornerRadius = 5;
        codeButton.clipsToBounds      = YES;
        codeButton.titleLabel.font    = DYNormalFont;
        [cell.contentView addSubview:codeButton];
        
        
        // 布局
        [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-20);
            make.width.mas_equalTo(92);
        }];
        
        [input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(150);
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(self->codeButton.mas_left).offset(-5);
        }];
    } else {
        // 布局
        [input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(150);
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-20);
            
        }];
        // 不可编辑
        if (indexPath.row == 3) {
            // 开户行
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            input.userInteractionEnabled = NO;
            input.text = _bankCardModel.bankTypeName;
        } else if (indexPath.row == 0) {
            // 姓名
            input.text = _bankCardModel.userName;
        } else if (indexPath.row == 1) {
            // 身份证
            input.text = _bankCardModel.idCardNo;
        } else if (indexPath.row == 2) {
            // 银行卡号
            input.text = _bankCardModel.bankCardNo;
            input.keyboardType = UIKeyboardTypeNumberPad;
        } else if (indexPath.row == 4) {
            // 预留手机号
            input.text = _bankCardModel.bankCardTel;
            input.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        // 先获取银行数据 再选择
        [self requestBankCardList];
        [Helper resignTheFirstResponder];
    }
}
#pragma mark 下一步
//-(void)lastClick:(UIButton*)sender {
//    [self.view removeFromSuperview];
//    CreditExtensionMainVC *viewC = self.navigationController.viewControllers.lastObject;
//    viewC.title = @"身份认证";
//    viewC.stepLabel.text = @"1/4";
//
//}
-(void)nextClick:(UIButton*)sender {
    // 验证数据
    if (![self justInfo:YES]) return;
    if (!longitude||!latitude||[longitude isEqualToString:@""]||[latitude isEqualToString:@""]) {
        // 定位
        [[LocationManager shareInstance] requestLocation:self resultBlock:^(LocationManager * _Nonnull manage, NSInteger code, NSDictionary * _Nonnull result) {
            if (code == 0) {
                self->longitude   = result[@"longitude"]; // 经度
                self->latitude    = result[@"latitude"]; // 纬度
                self->gpsCity     = [Helper isNullToString:result[@"gpsCity"] returnString:@"未知"]; // 城市
                self->gpsProvince = [Helper isNullToString:result[@"gpsProvince"] returnString:@"未知"];// 省份
            }
        }];
        return;
    }
    
    sender.enabled = NO;
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
    
    // userName:真实姓名  idCardNo：身份证号码 bankCardNo:银行卡号
    //bankCardTel: 预留手机  bankType：开户行  chanlRiskinfo: 风险信息
    NSDictionary *parameters = @{@"userName":_bankCardModel.userName,
                                 @"idCardNo":_bankCardModel.idCardNo,
                                 @"bankCardNo":_bankCardModel.bankCardNo,
                                 @"bankType":[NSNumber numberWithInteger:bankType],
                                 @"bankCardTel":_bankCardModel.bankCardTel,
                                 @"chanlRiskinfo":jsonString};
    [[RequestManager shareInstance]postWithURL:BINDBANKCARDNO_INTERFACE parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI线程
            sender.enabled = YES;
            IdentityVC *idVC = [IdentityVC new];
            idVC.userName    = self.bankCardModel.userName;
            idVC.idCardNo    = self.bankCardModel.idCardNo;
            [self addChildViewController:idVC];
            self.childViewControllers[0].view.frame = self.view.bounds;
            [self.view addSubview:idVC.view];
        });
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        sender.enabled = YES;
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        sender.enabled = YES;
    } isCache:NO];
    
    
 
}
#pragma mark 获取验证码
-(void)getCodeClick:(UIButton*)sender {

    // 验证数据
    if (![self justInfo:NO]) return;
    sender.enabled = NO;
    
    // 获取开户银行
    NSInteger bankType = 0;
    for (BankCardListModel *list in bankCardList) {
        if ([list.bankName isEqualToString:_bankCardModel.bankTypeName]) {
            bankType = list.iId;
            break;
        }
    }
    // userName:真实姓名  idCardNo：身份证号码 bankCardNo:银行卡号
    //bankCardTel: 预留手机  bankType：开户行
    NSDictionary *parameters = @{@"userName":_bankCardModel.userName,
                                 @"idCardNo":_bankCardModel.idCardNo,
                                 @"bankCardNo":_bankCardModel.bankCardNo,
                                 @"bankType":[NSNumber numberWithInteger:bankType],
                                 @"bankCardTel":_bankCardModel.bankCardTel};
    [[RequestManager shareInstance]postWithURL:GETBANKCARDMSG_INTERFACE parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        self->_countDown = CodeNumer;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        
        sender.enabled = YES;
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        sender.enabled = YES;
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        sender.enabled = YES;
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
-(BOOL)justInfo:(BOOL) value {
    if (_bankCardModel.userName.length<2||![Helper justName:_bankCardModel.userName]||_bankCardModel.userName.length>30) {
        [Helper alertMessage:@"请输入真实姓名" addToView:self.view];
        return NO;
    } else if (![Helper justIdentityCard:_bankCardModel.idCardNo]){
        [Helper alertMessage:@"请输入正确的身份证号" addToView:self.view];
        return NO;
    } else if (_bankCardModel.idCardNo.length<11||_bankCardModel.idCardNo.length>30){
        [Helper alertMessage:@"请输入正确的银行卡号" addToView:self.view];
        return NO;
    } else if (!_bankCardModel.bankTypeName) {
        [Helper alertMessage:@"请选择开户银行卡" addToView:self.view];
        return NO;
    } else if (![Helper justMobile:_bankCardModel.bankCardTel]) {
        [Helper alertMessage:@"请输入正确的手机号码" addToView:self.view];
        return NO;
    }
    // 暂时不支持验证码
//    else if (value&&(!_bankCardModel.verificationCode||_bankCardModel.verificationCode.length>7)) {
//        [Helper alertMessage:@"请输入正确的验证码" addToView:self.view];
//        return NO;
//    }
    return YES;
}
#pragma mark 显示选择控制器
- (void)showPickerViewWithDataList:(NSArray *)dataList tipLabelString:(NSString *)string{
    // Custom propery（自定义属性）
    
    
    NSDictionary *propertyDict = @{ZJPickerViewPropertySureBtnTitleColorKey     : HomeColor,
                                   ZJPickerViewPropertySelectRowTitleAttrKey    : @{NSForegroundColorAttributeName:HomeColor},
                                   ZJPickerViewPropertyTipLabelTextKey          : string,
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey   : @YES,
                                   ZJPickerViewPropertyIsScrollToSelectedRowKey : @YES,
                                   };
    [ZJPickerView zj_showWithDataList:dataList propertyDict:propertyDict completion:^(NSString *selectContent) {
        NSLog(@"ZJPickerView log tip：---> selectContent:%@", selectContent);
        self.bankCardModel.bankTypeName = selectContent;
        [self->listTableView reloadData];
        // 获取开户银行
        self->bankType = 0;
        for (BankCardListModel *list in self->bankCardList) {
            if ([list.bankName isEqualToString:self->_bankCardModel.bankTypeName]) {
                self->bankType = list.iId;
                break;
            }
        }
    }];
}
#pragma mark TextField Protocol
-(void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 20:
            self.bankCardModel.userName         = textField.text;
            break;
        case 21:
            self.bankCardModel.idCardNo         = textField.text;
            break;
        case 22:
            self.bankCardModel.bankCardNo       = textField.text;
            break;
        case 24:
            self.bankCardModel.bankCardTel      = textField.text;
            break;
        case 25:
            self.bankCardModel.verificationCode = textField.text;
            break;
        default:
            break;
    }
}
#pragma mark 请求支持银行卡
-(void)requestBankCardList {
    
    [[RequestManager shareInstance]postWithURL:GETBANKCARDLIST_INTERFACE parameters:nil isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        [self->bankCardList removeAllObjects];
        if ([Helper justArray:model]) {
            NSArray * array = model;
            NSMutableArray *bankName = [NSMutableArray new];
            for (NSDictionary *dic in array) {
                BankCardListModel *list = [BankCardListModel yy_modelWithJSON:dic];
                [self->bankCardList addObject:list];
                [bankName addObject:list.bankName];
            }
            [self showPickerViewWithDataList:bankName
                              tipLabelString:self.bankCardModel.bankTypeName?:@"请选择开户行"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"暂时没有支持的银行" addToView:self.view];
            });
        }
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
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
