//
//  ApplyLoanVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/23.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//


#import "LoanPlanVC.h"
#import "ApplyLoanVC.h"
#import "CodeAlertView.h"
#import "LoanSuccessVC.h"
#import "ApplyLoanModel.h"
#import <AdSupport/AdSupport.h>

@interface ApplyLoanVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *listTableView;
    NSArray *titleArray;
    NSArray *limitArray; // 期限数据
    NSMutableArray *useArray; // 用途数据
    UIButton *selectButton; // 选中协议
    ApplyLoanModel *applyModel; // 数据
    BOOL showLimitPicker; // 是否显示期限的选择项， 默认Yes
    
    NSString *latitude; // 纬度
    NSString *longitude; // 经度
    NSString *gpsProvince; // 省份
    NSString *gpsCity; // 城市
    NSString *ipAddress;
}
@end

@implementation ApplyLoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self localData];
    [self getUI];
    [self requestData];
    
}
#pragma mark 请求数据
-(void)requestData {
    // 借款数据
    [[RequestManager shareInstance]postWithURL:GETLOANDETAILS_INTERFACE parameters:nil isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        if ([Helper justDictionary:model]) {
            if ([Helper justArray:model[@"term"]]) self->applyModel.termList = model[@"term"]; // 期限
            self->applyModel.creditLimitAvailable = model[@"creditLimitAvailable"]; // 可用金额
            self->applyModel.bankName             = model[@"bankName"]; // 开户行
            self->applyModel.bankCardNo           = model[@"bankCardNo"]; // 卡号
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"获取失败" addToView:self.view];
            });
        }
        [self->listTableView reloadData];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void)requestOfuse {
    // 获取借款用途数据
    [[RequestManager shareInstance]postWithURL:GETLOANOFUSE_INTERFACE parameters:nil isLoading:nil loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->useArray removeAllObjects];
        if ([Helper justArray:model]) {
            [self->useArray addObjectsFromArray:model];
            NSMutableArray *namearray = [NSMutableArray new];
            [self->useArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [namearray addObject:obj[1]];
            }];
            if (namearray.count>0)
            [self showPickerViewWithDataList:namearray tipLabelString:self->applyModel.loanOfUse.length>0?self->applyModel.loanOfUse:@"请选择用途"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"没有配置借款用途数据" addToView:self.view];
            });
        }
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void)localData {
    titleArray = @[@[@"我的额度(元)",@"申请金额：",@"借款期限："],@[@"借款用途：",@"收款银行："],@[@"还款计划："]];
//    limitArray = @[@"3个月",@"6个月",@"12个月",@"24个月",];
    useArray   = [NSMutableArray new];
    applyModel = [ApplyLoanModel new];
    showLimitPicker = YES;
    
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
#pragma mark GetUI
-(void)getUI {
    [self.navigationItem setTitle:@"借款申请"];
    // 导航栏的下划线置为空
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.rowHeight       = 50;
    listTableView.tableFooterView = [UIView new];
    listTableView.backgroundColor = DYGrayColor(239);
    [self.view addSubview:listTableView];
//    UIPickerView
    // FootView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 200)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->listTableView.tableFooterView = footView;
    });
    // 勾选框
    selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setImage:[UIImage imageNamed:@"Login_unselect"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"Login_select"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:selectButton];
    // 阅读文字
    UILabel *readLabel      = [UILabel new];
    readLabel.numberOfLines = 0;
    readLabel.text          = @"我已阅读并同意《个人消费借款》《账户委托扣款授权书》《包商银行个人征信查询授权协议》";
    [footView addSubview:readLabel];
    // 申请按钮
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.layer.cornerRadius = 20;
    applyButton.clipsToBounds      = YES;
    [applyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(applyClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:applyButton];
    
    
    // 布局
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(12);
        make.top.equalTo(footView).offset(20);
        make.width.height.mas_equalTo(20);
    }];
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->selectButton.mas_right);
        make.top.equalTo(footView).offset(10);
        make.right.equalTo(footView).offset(-15);
    }];
    [applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(25);
        make.right.equalTo(footView).offset(-25);
        make.height.mas_equalTo(45);
        make.top.equalTo(readLabel.mas_bottom).offset(80);
    }];
}
#pragma mark TableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [titleArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray= titleArray[section];
    return rowArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF  = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.textLabel.text   = titleArray[indexPath.section][indexPath.row];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 背景
            UIImageView *headerImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Common_backgroundHeader"]];
            headerImg.contentMode  = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:headerImg];
            // 文字
            UILabel *payLabel       = [UILabel new];
            payLabel.textColor      = [UIColor whiteColor];
            payLabel.textAlignment  = NSTextAlignmentCenter;
            payLabel.numberOfLines  = 0;
            payLabel.attributedText = [self setAttributeStringFont:[NSString stringWithFormat:@"%@\n¥ %@",cell.textLabel.text,[Helper isNullToString:applyModel.creditLimitAvailable returnString:@"0"]]];
            [headerImg addSubview:payLabel];
            // 布局
            [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(cell.contentView);
                make.height.mas_equalTo(DYCalculateHeigh(99));
                make.bottom.equalTo(cell.contentView);
            }];
            [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(headerImg);
            }];
            // 隐藏分割线
            cell.separatorInset = UIEdgeInsetsMake(0, screenWidth, 0, -screenWidth);
        } else if (indexPath.row == 1) {
            UITextField *textInput  = [UITextField new];
            textInput.keyboardType  = UIKeyboardTypeNumberPad;
            textInput.placeholder   = @"请输入申请金额";
            textInput.text          = applyModel.creditMoney;
            textInput.delegate      = self;
            textInput.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:textInput];
            
            [textInput mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(40.0);
                make.top.equalTo(cell.contentView).offset(5);
                make.left.equalTo(cell.contentView).offset(110);
                make.right.equalTo(cell.contentView).offset(-33);
                make.bottom.equalTo(cell.contentView).offset(-5);
            }];
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = applyModel.creditTerm.length>0?[NSString stringWithFormat:@"%@个月",applyModel.creditTerm]:@"请选择期限";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = applyModel.loanOfUse.length>0?applyModel.loanOfUse:@"请选择用途";
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"尾号(%@)%@",[self substringFromString:[Helper isNullToString:applyModel.bankCardNo returnString:@""]],[Helper isNullToString:applyModel.bankName returnString:@""]];
        }
    
    } else {
        cell.detailTextLabel.text = @"查看还款计划";
        cell.selectionStyle       = UITableViewCellSelectionStyleDefault;
        cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (![self justMoneyString]) return; // 金额限制
        if (!applyModel.creditTerm) {
            [Helper alertMessage:@"请选择借款期限" addToView:self.view];
            return;
        }
        // 查看还款计划
        LoanPlanVC *planVC = [LoanPlanVC new];
        planVC.term        = [applyModel.creditTerm integerValue];
        planVC.money       = [applyModel.creditMoney integerValue];
        [self.navigationController pushViewController:planVC animated:YES];
    } else if (indexPath.section == 0&&indexPath.row == 2) {
        // 选择期限
        showLimitPicker = YES;
        [self showPickerViewWithDataList:applyModel.termList tipLabelString:applyModel.creditTerm.length>0?applyModel.creditTerm:@"请选择期限"];
    } else if (indexPath.row == 0&&indexPath.section == 1) {
        // 选择用途
        showLimitPicker = NO;
        [self requestOfuse];
    }
    [Helper resignTheFirstResponder];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 禁止下滑
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
}
-(NSString *)substringFromString:(NSString*)string {
    if (string.length<5) {
        return string;
    }
    return [string substringFromIndex:string.length-4];
}
#pragma mark Apply Event
-(void)applyClick:(UIButton*) sender {
    if (![self justMoneyString]) return;
    if (!applyModel.creditTerm) {
        [Helper alertMessage:@"请选择借款期限" addToView:self.view];
        return ;
    }
    if (!applyModel.loanOfUse) {
        [Helper alertMessage:@"请选择借款用途" addToView:self.view];
        return;
    }
    if (!selectButton.isSelected) {
        [Helper alertMessage:@"请先阅读并同意协议" addToView:self.view];
        return;
    }
    typeof(self) weakSelf = self;
    CodeAlertView *codeView = [[CodeAlertView alloc]init];
    codeView.phoneNum       = kUserPHONE;
    codeView.submitEvent    = ^(NSInteger index, NSString *codeNum) {
        // index ' 1=验证码，9=取消，10=确定  codeNum:验证码
        
        if (index == 1) [weakSelf getCode]; // 获取验证码
        
        if (index == 10&&codeNum.length == 0) {
            [Helper alertMessage:@"请输入验证码" addToView:self.view];
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
    // creditMoney: 申请金额  creditTerm: 期限 bankCardNo: 卡号
    // loanOfUse: 用途    chanlRiskinfo: 风险信息
    NSDictionary *parameters = @{@"creditMoney":[NSNumber numberWithInteger:[applyModel.creditMoney integerValue]],
                                 @"creditTerm":applyModel.creditTerm,
                                 @"bankCardNo":applyModel.bankCardNo,
                                 @"loanOfUse":applyModel.loanOfUseNum,
                                 @"chanlRiskinfo":jsonString};
    [[RequestManager shareInstance]postWithURL:LOANGETCODE_INTERFACE parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
#pragma mark 确认申请
-(void)confirmApplyLoan:(NSString*)code {
    // 验证短信码并提交申请
    if (!code||code.length>6) {
        [Helper alertMessage:@"请输入正确的验证码" addToView:self.view];
        return;
    }
    // verificationCode: 验证码  mobileNo: 用户手机号
    [[RequestManager shareInstance]postWithURL:LOANVALIDCODE_INTERFACE parameters:@{@"verificationCode":code,@"mobileNo":kUserPHONE} isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        LoanSuccessVC *successVc = [LoanSuccessVC new];
        [self addChildViewController:successVc];
        self.childViewControllers[0].view.frame = self.view.bounds;
        [self.view addSubview:successVc.view];

    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
    
}
-(void)selectClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
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
        
        // 赋值
        if (self->showLimitPicker) {
          self->applyModel.creditTerm = selectContent;
        } else {
          self->applyModel.loanOfUse = selectContent;
            [self->useArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([Helper justArray:obj]) {
                    NSArray *array = obj;
                    if (array.count==2) {
                        if ([array[1] isEqualToString:selectContent]) {
                            self->applyModel.loanOfUseNum = [NSString stringWithFormat:@"%@",array[0]];
                        }
                    }
                }
            }];
        }
        
        // 刷新
        [self->listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self->showLimitPicker?2:0 inSection:self->showLimitPicker?0:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
#pragma mark textField protocol
-(void)textFieldDidEndEditing:(UITextField *)textField {
    applyModel.creditMoney = textField.text;
}
// 字体大小富文本
-(NSMutableAttributedString*)setAttributeStringFont:(NSString*)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:25];
    [attributedString addAttributes:dic range:NSMakeRange(7, string.length-7)];
    return attributedString;
}
- (BOOL)justMoneyString {
    if (!applyModel.creditMoney) {
        [Helper alertMessage:@"请输入申请金额" addToView:self.view];
        return NO;
    }
    if ([applyModel.creditMoney integerValue]%100!=0) {
        [Helper alertMessage:@"申请金额必须是100的倍数" addToView:self.view];
        return NO;
    }
    if ([applyModel.creditMoney integerValue]==0) {
        [Helper alertMessage:@"申请金额不能为零" addToView:self.view];
        return NO;
    }
    NSInteger money = [[Helper isNullToString:applyModel.creditLimitAvailable returnString:@"0"] integerValue];
    if ([applyModel.creditMoney integerValue]>money) {
        [Helper alertMessage:[NSString stringWithFormat:@"申请金额最大限度为%ld",(long)money] addToView:self.view];
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
