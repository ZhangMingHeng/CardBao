//
//  BasicInfoVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//


#import "ContactData.h"
#import "BasicInfoVC.h"
#import "TabIndexView.h"
#import "ZHIMACreditVC.h"
#import "OperatorCreditVC.h"
#import <AdSupport/AdSupport.h>
#import "CreditExtensionMainVC.h"
@interface BasicInfoVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *titleArrayOther;
    NSMutableArray *placeholderOther;
    NSMutableArray *titleArray;
    NSMutableArray *placeholder;
    NSMutableArray *degreeArray; // 学历数据
    NSMutableArray *liveArray; // 居住数据
    NSMutableArray *marriageArray; // 婚姻状况数据
    NSMutableArray *contactrelationArray; // 联系人关系数据
    NSMutableArray *jobrankArray; // 单位职能数据
    NSMutableArray *industryArray; // 所属行业数据
    TabIndexView *tabView;
    NSInteger selectRow;// 选中了哪行
    
    NSString *latitude; // 纬度
    NSString *longitude; // 经度
    NSString *gpsProvince; // 省份
    NSString *gpsCity; // 城市
    NSString *ipAddress;
    
}

@end

@implementation BasicInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self localData];
    [self getUI];
}
-(void)localData {
    
    titleArray  = [NSMutableArray arrayWithObjects:@"居住地址",@"详细地址",@"学历信息",@"居住情况",@"婚姻状况",@"联系人1",@"真实姓名",@"手机号码",@"联系人2",@"真实姓名",@"手机号码", nil];
    placeholder = [NSMutableArray arrayWithObjects:@"请选择省、市、区",@"请输入详细地址",@"请选择学历信息",@"请选择居住情况",@"请选择婚姻状况",@"请选择关系",@"请输入联系人姓名",@"请选择手机号码",@"请选择关系",@"请输入联系人姓名",@"请选择手机号码",nil];
    
    degreeArray          = [NSMutableArray new];
    liveArray            = [NSMutableArray new];
    marriageArray        = [NSMutableArray new];
    contactrelationArray = [NSMutableArray new];
    industryArray        = [NSMutableArray new];
    jobrankArray         = [NSMutableArray new];
    
    if (self.baseViewPushType != NSBaseViewPushTypeChangeInfo){
        self.basicModel = [BasicInfoModel new];
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
    
    
}
#pragma mark 请求数据
-(void)requestDegree {
    // 请求学历数据
    [[RequestManager shareInstance]postWithURL:GETDEGREEINFO_INTERFACE parameters:nil isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->degreeArray removeAllObjects];
        if ([Helper justArray:model]) {
            [self->degreeArray addObjectsFromArray:model];
            NSMutableArray *nameArray = [NSMutableArray new];
            [self->degreeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *array = obj;
                if ([Helper justArray:array]&&array.count == 2) {
                    [nameArray addObject:array[1]];
                }
            }];
            [self showPickerViewWithDataList:nameArray tipLabelString:self.basicModel.degreeName?:@"请选择学历信息"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"没有配置学历数据" addToView:self.view];
            });
        }
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void)requestLive {
    // 请求居住情况数据
    [[RequestManager shareInstance]postWithURL:GETLIVEINFO_INTERFACE parameters:nil isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->liveArray removeAllObjects];
        if ([Helper justArray:model]) {
            [self->liveArray addObjectsFromArray:model];
            NSMutableArray *nameArray = [NSMutableArray new];
            [self->liveArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *array = obj;
                if ([Helper justArray:array]&&array.count == 2) {
                    [nameArray addObject:array[1]];
                }
            }];
            [self showPickerViewWithDataList:nameArray tipLabelString:self.basicModel.residentialName?:@"请选择居住情况"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"没有配置居住情况数据" addToView:self.view];
            });
        }
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void)requestMarriage {
    // 请求婚姻状况数据
    [[RequestManager shareInstance]postWithURL:GETMARRIAGEINFO_INTERFACE parameters:nil isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->marriageArray removeAllObjects];
        if ([Helper justArray:model]) {
            [self->marriageArray addObjectsFromArray:model];
            NSMutableArray *nameArray = [NSMutableArray new];
            [self->marriageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *array = obj;
                if ([Helper justArray:array]&&array.count == 2) {
                    [nameArray addObject:array[1]];
                }
            }];
            [self showPickerViewWithDataList:nameArray tipLabelString:self.basicModel.marrName?:@"请选择婚姻状况"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"没有配置婚姻状况数据" addToView:self.view];
            });
        }
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void)requestContactrelation:(NSInteger)tag {
    // 请求联系人关系数据
    [[RequestManager shareInstance]postWithURL:GETCONTACTRELATION_INTERFACE parameters:nil isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->contactrelationArray removeAllObjects];
        if ([Helper justArray:model]) {
            [self->contactrelationArray addObjectsFromArray:model];
            NSMutableArray *nameArray = [NSMutableArray new];
            [self->contactrelationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *array = obj;
                if ([Helper justArray:array]&&array.count == 2) {
                    [nameArray addObject:array[1]];
                }
            }];
            NSString *tipString = tag==0?self.basicModel.contactRelationName:self.basicModel.contactRelationName1;
            [self showPickerViewWithDataList:nameArray tipLabelString:tipString?:@"请选择关系"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"没有配置关系数据" addToView:self.view];
            });
        }
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void)requestJobrank {
    // 请求单位职能数据
    [[RequestManager shareInstance]postWithURL:GETJOBRANK_INTERFACE parameters:nil isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->jobrankArray removeAllObjects];
        if ([Helper justArray:model]) {
            [self->jobrankArray addObjectsFromArray:model];
            NSMutableArray *nameArray = [NSMutableArray new];
            [self->jobrankArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *array = obj;
                if ([Helper justArray:array]&&array.count == 2) {
                    [nameArray addObject:array[1]];
                }
            }];
            [self showPickerViewWithDataList:nameArray tipLabelString:self.basicModel.jobRankName?:@"请选择单位职能"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"没有配置单位职能数据" addToView:self.view];
            });
        }
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void)requestIndustry {
    // 请求所属行业数据
    [[RequestManager shareInstance]postWithURL:GETINDUSTRYINFO_INTERFACE parameters:nil isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->industryArray removeAllObjects];
        if ([Helper justArray:model]) {
            [self->industryArray addObjectsFromArray:model];
            NSMutableArray *nameArray = [NSMutableArray new];
            [self->industryArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *array = obj;
                if ([Helper justArray:array]&&array.count == 2) {
                    [nameArray addObject:array[1]];
                }
            }];
            [self showPickerViewWithDataList:nameArray tipLabelString:self.basicModel.industryName?:@"请选择所属行业"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"没有配置所属行业数据" addToView:self.view];
            });
        }
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void)requestContacts:(NSUInteger)tag {
    // 通过系统通讯录拿手机号码
    [[ContactData shareInstance]requestContactUI:self resultBlock:^(ContactData * _Nonnull manage, NSInteger code, NSString * _Nonnull result) {
        if (code == 0) {
            if (tag == 0) self.basicModel.contactMobile = result;
            else self.basicModel.contactMobile1 = result;
            
            UITableView *tableVIew = (UITableView *)[self.view viewWithTag:3+self->tabView.index];
            [tableVIew reloadData];
        } else {
            [Helper alertMessage:@"请选择手机号码" addToView:self.view];
        }
    }];
}
-(void)requestSubmitBasicInfo {
    NSMutableDictionary *jsonString = [NSMutableDictionary new];
    if (self.baseViewPushType != NSBaseViewPushTypeChangeInfo) {
        // deviceId: 设备Id   IMEI：imei   ip：IP地址 longiTude:经度 latiTude: 纬度  gpsCity: 城市
        // wifiMac:  wifimac  phoneModel: 手机型号  operationSys:操作系统 gpsProvince: 省份
        jsonString = [[NSMutableDictionary alloc]initWithDictionary:@{@"equipmentInfo":@{@"deviceId":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                                                                         @"IDFA":[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                                                                                         @"phoneModel":[UIDevice currentDevice].model,
                                                                                         @"operationSys":[UIDevice currentDevice].systemName,
                                                                                         @"longiTude":longitude,
                                                                                         @"latiTude":latitude,
                                                                                         @"ip":ipAddress,
                                                                                         @"gpsProvince":gpsProvince,
                                                                                         @"gpsCity":gpsCity}}];
    }
    
    // comyName:公司名称  industry: 所属行业  officePhone: 公司电话
    // jobRank: 单位职能  comyAddrs: 公司地址 companyDetailAddress: 公司详细地址
    NSDictionary *companyInfo = @{@"comyName":self.basicModel.comyName,
                                  @"industry":self.basicModel.industry,
                                  @"officePhone":self.basicModel.officePhone,
                                  @"jobRank":self.basicModel.jobRank,
                                  @"comyAddrs":self.basicModel.comyAddrs,
                                  @"companyDetailAddress":self.basicModel.companyDetailAddress};
    
    // contactMobile:联系人号码   contactName:联系人名称   contactRelation: 与联系人的关系
    NSArray *userRelationInfo = @[@{@"contactName":self.basicModel.contactName,
                                    @"contactMobile":self.basicModel.contactMobile,
                                    @"contactRelation":self.basicModel.contactRelation},
                                  @{@"contactName":self.basicModel.contactName1,
                                    @"contactMobile":self.basicModel.contactMobile1,
                                    @"contactRelation":self.basicModel.contactRelation1}];
    // marrStatus:婚姻状况   degree:学历  residentialStatus:居住状况  address:居住地
    // detailAddress: 居住详细地址  companyInfo:公司信息   userRelationInfo:联系人信息
    // chanlRiskinfo: 风控信息
    NSDictionary *parameters = @{@"marrStatus":self.basicModel.marrStatus,
                                 @"degree":self.basicModel.degree,
                                 @"residentialStatus":self.basicModel.residentialStatus,
                                 @"address":self.basicModel.address,
                                 @"detailAddress":self.basicModel.detailAddress,
                                 @"companyInfo":companyInfo,
                                 @"userRelationInfo":userRelationInfo,
                                 @"chanlRiskinfo":jsonString};
    
    NSString *url = self.baseViewPushType==NSBaseViewPushTypeDefault?SUBMITBAISCINFO_INTERFACE:UPDATEBASICINFO_INTERFACE;
    [[RequestManager shareInstance]postWithURL:url parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI线程
            if (NSBaseViewPushTypeDefault != self.baseViewPushType) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            OperatorCreditVC *operatorVC = [OperatorCreditVC new];
            [self addChildViewController:operatorVC];
            self.childViewControllers[0].view.frame = self.view.bounds;
            [self.view addSubview:operatorVC.view];
        });
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
#pragma mark getUI
-(void)getUI {
    
    if (NSBaseViewPushTypeDefault == _baseViewPushType) {
        
        CreditExtensionMainVC *viewC = self.navigationController.viewControllers.lastObject;
        viewC.title = @"基本信息";
        viewC.stepLabel.text = @"3/4";
    } else {
        self.title = @"基本信息";
    }
    
    
    // 选项卡
    tabView = [TabIndexView new];
    [self.view addSubview:tabView];
    
    for (int i = 0; i<2; i++) {
        // tableView // tag 3->个人信息， 4->单位信息
        UITableView *listTableView    = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        listTableView.dataSource      = self;
        listTableView.delegate        = self;
        listTableView.rowHeight       = 50;
        listTableView.tableFooterView = [UIView new];
        listTableView.tag             = i+3;
        listTableView.hidden          = i==0?NO:YES;
        listTableView.backgroundColor = DYGrayColor(243);
        listTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:listTableView];
        
        // FootView
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, i==0?110:180)];
//        footView.backgroundColor = DYGrayColor(231);
        // 上一步按钮
        UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        lastButton.layer.cornerRadius = 20;
        lastButton.clipsToBounds      = YES;
        lastButton.hidden             = i==0?YES:NO;
        [lastButton setTitle:@"上一步" forState:UIControlStateNormal];
        [lastButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
        [lastButton addTarget:self action:@selector(lastClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:lastButton];
        // 下一步按钮
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.layer.cornerRadius = 20;
        nextButton.clipsToBounds      = YES;
        nextButton.tag                = 5+i;
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:nextButton];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            listTableView.tableFooterView = footView;
        });
        
        // 布局
        [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(130, 0, 0, 0));
        }];
        [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.top.equalTo(footView).offset(50);
            make.left.equalTo(footView).offset(25);
            make.right.equalTo(footView).offset(-25);
        }];
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.equalTo(footView).offset(25);
            make.right.equalTo(footView).offset(-25);
            make.bottom.equalTo(footView).offset(-25);
        }];
    }
    
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UITableView *listTableView = [self.view viewWithTag:4];
    if (tableView == listTableView) return titleArrayOther.count;
    else return titleArray.count;
    
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *listTableView = [self.view viewWithTag:4];
    
    static NSString *idF  = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;

    if (tableView == listTableView) {
        cell.textLabel.text       = titleArrayOther[indexPath.row];
        // 输入框
        UITextField *input  = [UITextField new];
        input.placeholder   = placeholderOther[indexPath.row];
        input.tag           = indexPath.row+40;
        input.delegate      = self;
        input.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:input];
        // 布局
        [input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(150);
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            
        }];
        
        switch (indexPath.row) {
            case 0:
            {
                input.userInteractionEnabled = NO;
                input.text = self.basicModel.comyAddrs;
            }
                break;
            case 1:
                input.text = self.basicModel.companyDetailAddress;
                break;
            case 2:
                input.text = self.basicModel.comyName;
                break;
            case 3:
            {
                input.text         = self.basicModel.officePhone;
                input.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;
            case 4:
            {
                input.userInteractionEnabled = NO;
                input.text = self.basicModel.industryName;
            }
                break;
            case 5:
            {
                input.userInteractionEnabled = NO;
                input.text = self.basicModel.jobRankName;
            }
                break;
            default:
                break;
        }
    } else {
        cell.textLabel.text       = titleArray[indexPath.row];
        
        // 输入框
        UITextField *input  = [UITextField new];
        input.placeholder   = placeholder[indexPath.row];
        input.tag           = indexPath.row+20;
        input.delegate      = self;
        input.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:input];
        // 布局
        [input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(150);
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            
        }];
        
        input.userInteractionEnabled = NO;
        switch (indexPath.row) {
            case 0:
                input.text = self.basicModel.address;
                break;
            case 1:
            {
                input.userInteractionEnabled = YES;
                input.text = self.basicModel.detailAddress;
            }
                break;
            case 2:
                input.text = self.basicModel.degreeName;
                break;
            case 3:
                input.text = self.basicModel.residentialName;
                break;
            case 4:
                input.text = self.basicModel.marrName;
                break;
            case 5:
                input.text = self.basicModel.contactRelationName;
                break;
            case 6:
            {
                input.userInteractionEnabled = YES;
                input.text = self.basicModel.contactName;
            }
                break;
            case 7:
                input.text = self.basicModel.contactMobile;
                break;
            case 8:
                input.text = self.basicModel.contactRelationName1;
                break;
            case 9:
            {
                input.userInteractionEnabled = YES;
                input.text = self.basicModel.contactName1;
            }
                break;
            case 10:
                input.text = self.basicModel.contactMobile1;
                break;
            default:
                break;
        }
        if (indexPath.row == 1||indexPath.row == 6||indexPath.row == 9) {
            
        } else {
            
        }
        
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectRow = indexPath.row;
    UITableView *listTableView = [self.view viewWithTag:4];
    if (tableView == listTableView) {
        if (indexPath.row == 0) {
            [self showPickerViewWithDataList:[self getCityData] tipLabelString:self.basicModel.comyAddrs?:@"请选择省、市、区"];
        } else if (indexPath.row == 4) [self requestIndustry];
        else if (indexPath.row == 5) [self requestJobrank];
    } else {
        if (indexPath.row == 0) {
            [self showPickerViewWithDataList:[self getCityData] tipLabelString:self.basicModel.address?:@"请选择省、市、区"];
        } else if (indexPath.row == 2) [self requestDegree];
        else if (indexPath.row == 3) [self requestLive];
        else if (indexPath.row == 4) [self requestMarriage];
        else if (indexPath.row == 5) [self requestContactrelation:0];
        else if (indexPath.row == 8) [self requestContactrelation:1];
        else if (indexPath.row == 7) [self requestContacts:0];
        else if (indexPath.row == 10) [self requestContacts:1];
    }
    
    [Helper resignTheFirstResponder];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 禁止下滑
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
}
-(void)nextClick:(UIButton*)sender {
    if (sender.tag == 5) {
        if (![self justInfo:YES]) return;
        // 切换到单位信息
        tabView.index = 1;
        UITableView *listTableView = [self.view viewWithTag:4];
        listTableView.hidden = NO;
        titleArrayOther  = [NSMutableArray arrayWithArray:@[@"单位地址",@"详细地址",@"单位名称",@"单位电话",@"所属行业",@"单位职能"]];
        placeholderOther = [NSMutableArray arrayWithArray:@[@"请选择省、市、区",@"请输入详细地址",@"请输入单位名称",@"请输入单位电话",@"请选择所属行业",@"请选择单位职能"]];
        [listTableView reloadData];
        if (_baseViewPushType == NSBaseViewPushTypeChangeInfo) {
            UIButton *button = (UIButton*)[self.view viewWithTag:6];
            [button setTitle:@"完成" forState:UIControlStateNormal];
        }
        
    } else {
        if (![self justInfo:NO]) return;
        
//        // 跳转 芝麻信用页面
//        ZHIMACreditVC *zhimaVC = [ZHIMACreditVC new];
//        [self addChildViewController: zhimaVC];
//        self.childViewControllers[0].view.frame = self.view.bounds;
//        [self.view addSubview:zhimaVC.view];
        [self requestSubmitBasicInfo];
        
    }
    
}

-(void)lastClick:(UIButton*)sender {
    tabView.index = 0;
    UITableView *listTableView = [self.view viewWithTag:4];
    listTableView.hidden = YES;
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
        // 赋值并刷新数据
        UITableView *tableVIew = (UITableView *)[self.view viewWithTag:3+self->tabView.index];
        if (self->tabView.index == 0) {
            switch (self->selectRow) {
                case 0:
                    self.basicModel.address = [selectContent stringByReplacingOccurrencesOfString:@"," withString:@""];
                    break;
                case 2:
                {
                    self.basicModel.degreeName = selectContent;
                    [self->degreeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([Helper justArray:obj]) {
                            NSArray *array = obj;
                            if (array.count==2) {
                                if ([array[1] isEqualToString:self.basicModel.degreeName]) {
                                    self.basicModel.degree = array[0];
                                    *stop = YES;
                                }
                            }
                        }
                    }];
                }
                    break;
                case 3:
                {
                    self.basicModel.residentialName = selectContent;
                    [self->liveArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([Helper justArray:obj]) {
                            NSArray *array = obj;
                            if (array.count==2) {
                                if ([array[1] isEqualToString:self.basicModel.residentialName]) {
                                    self.basicModel.residentialStatus = array[0];
                                    *stop = YES;
                                }
                            }
                        }
                    }];
                }
                    break;
                case 4:
                {
                    self.basicModel.marrName = selectContent;
                    [self->marriageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([Helper justArray:obj]) {
                            NSArray *array = obj;
                            if (array.count==2) {
                                if ([array[1] isEqualToString:self.basicModel.marrName]) {
                                    self.basicModel.marrStatus = array[0];
                                    *stop = YES;
                                }
                            }
                        }
                    }];
                }
                    
                    break;
                case 5:
                {
                    self.basicModel.contactRelationName = selectContent;
                    [self->contactrelationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([Helper justArray:obj]) {
                            NSArray *array = obj;
                            if (array.count==2) {
                                if ([array[1] isEqualToString:self.basicModel.contactRelationName]) {
                                    self.basicModel.contactRelation = array[0];
                                    *stop = YES;
                                }
                            }
                        }
                    }];
                }
                    break;
                case 8:
                {
                    self.basicModel.contactRelationName1 = selectContent;
                    [self->contactrelationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([Helper justArray:obj]) {
                            NSArray *array = obj;
                            if (array.count==2) {
                                if ([array[1] isEqualToString:self.basicModel.contactRelationName1]) {
                                    self.basicModel.contactRelation1 = array[0];
                                    *stop = YES;
                                }
                            }
                        }
                    }];
                }
                    break;
                default:
                    break;
            }
        } else {
            switch (self->selectRow) {
                case 0:
                    self.basicModel.comyAddrs = [selectContent stringByReplacingOccurrencesOfString:@"," withString:@""];
                    break;
                case 4:
                {
                    self.basicModel.industryName = selectContent;
                    [self->industryArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([Helper justArray:obj]) {
                            NSArray *array = obj;
                            if (array.count==2) {
                                if ([array[1] isEqualToString:self.basicModel.industryName]) {
                                    self.basicModel.industry = array[0];
                                    *stop = YES;
                                }
                            }
                        }
                    }];
                }
                    break;
                case 5:
                {
                    self.basicModel.jobRankName = selectContent;
                    [self->jobrankArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([Helper justArray:obj]) {
                            NSArray *array = obj;
                            if (array.count==2) {
                                if ([array[1] isEqualToString:self.basicModel.jobRankName]) {
                                    self.basicModel.jobRank = array[0];
                                    *stop = YES;
                                }
                            }
                        }
                    }];
                }
                    break;
                default:
                    break;
            }
            
        }
        
        [tableVIew reloadData];
    }];
}
- (NSMutableArray *)getCityData
{
    NSMutableArray *areaDataArray = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"txt"];
    NSString *areaString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (areaString && ![areaString isEqualToString:@""]) {
        NSError *error = nil;
        NSArray *areaStringArray = [NSJSONSerialization JSONObjectWithData:[areaString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if (areaStringArray && areaStringArray.count) {
            [areaStringArray enumerateObjectsUsingBlock:^(NSDictionary *currentProviceDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *proviceDict = [NSMutableDictionary dictionary];
                NSString *proviceName = currentProviceDict[@"name"];
                NSArray *cityArray = currentProviceDict[@"childs"];
                
                NSMutableArray *tempCityArray = [NSMutableArray arrayWithCapacity:cityArray.count];
                [cityArray enumerateObjectsUsingBlock:^(NSDictionary *currentCityDict, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
                    NSString *cityName = currentCityDict[@"name"];
                    NSArray *countryArray = currentCityDict[@"childs"];
                    
                    NSMutableArray *tempCountryArray = [NSMutableArray arrayWithCapacity:countryArray.count];
                    if (countryArray) {
                        [countryArray enumerateObjectsUsingBlock:^(NSDictionary *currentCountryDict, NSUInteger idx, BOOL * _Nonnull stop) {
                            [tempCountryArray addObject:currentCountryDict[@"name"]];
                        }];
                        
                        if (cityName) {
                            [cityDict setObject:tempCountryArray forKey:cityName];
                            [tempCityArray addObject:cityDict];
                        }
                    } else {
                        [tempCityArray addObject:cityName];
                    }
                }];
                
                if (proviceName && cityArray) {
                    [proviceDict setObject:tempCityArray forKey:proviceName];
                    [areaDataArray addObject:proviceDict];
                }
            }];
        } else {
            NSLog(@"解析错误");
        }
    }
    return areaDataArray;
}
#pragma mark TextField Protocol
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 21) self.basicModel.detailAddress             = textField.text;
    else if (textField.tag == 26) self.basicModel.contactName          = textField.text;
    else if (textField.tag == 29) self.basicModel.contactName1         = textField.text;
    else if (textField.tag == 41) self.basicModel.companyDetailAddress = textField.text;
    else if (textField.tag == 42) self.basicModel.comyName             = textField.text;
    else if (textField.tag == 43) self.basicModel.officePhone          = textField.text;
}
-(BOOL)justInfo:(BOOL) isMy {
    if (!self.basicModel.address) {
        [Helper alertMessage:@"请选择居住地址" addToView:self.view];
        return NO;
    } else if (self.basicModel.detailAddress.length<2||self.basicModel.detailAddress.length>50){
        [Helper alertMessage:@"请输入详细地址,2-50个字符" addToView:self.view];
        return NO;
    } else if (!self.basicModel.degreeName) {
        [Helper alertMessage:@"请选择学历信息" addToView:self.view];
        return NO;
    } else if (!self.basicModel.residentialName) {
        [Helper alertMessage:@"请选择居住情况" addToView:self.view];
        return NO;
    } else if (!self.basicModel.marrName) {
        [Helper alertMessage:@"请选择婚姻状况" addToView:self.view];
        return NO;
    } else if (!self.basicModel.contactRelationName||!self.basicModel.contactRelationName1) {
        [Helper alertMessage:@"请选择关系" addToView:self.view];
        return NO;
    } else if (!self.basicModel.contactName||!self.basicModel.contactName1) {
        [Helper alertMessage:@"请输入联系人姓名" addToView:self.view];
        return NO;
    } else if (!self.basicModel.contactMobile||!self.basicModel.contactMobile1) {
        [Helper alertMessage:@"请选择手机号码" addToView:self.view];
        return NO;
    } else if ([self.basicModel.contactName isEqualToString:self.basicModel.contactName1]) {
        [Helper alertMessage:@"联系人的名字不能一样" addToView:self.view];
        return NO;
    } else if ([self.basicModel.contactMobile isEqualToString:self.basicModel.contactMobile1]) {
        [Helper alertMessage:@"联系人的手机号码不能一样" addToView:self.view];
        return NO;
    }
    // 如果婚姻状况是已婚，提交时判断联系人1.2关系是否有配偶选项，如果没有则提示用户：“婚姻状态是已婚，联系人1或者联系人2关系必须是配偶，请重新选择关系”
    if ([self.basicModel.marrStatus isEqualToString:@"20"]) {
        if ([self.basicModel.contactRelation isEqualToString:@"4"]||[self.basicModel.contactRelation1 isEqualToString:@"4"]) {
            return YES;
        } else {
            [Helper alertMessage:@"婚姻状况是已婚,其中一个联系人关系必须是配偶" addToView:self.view];
            return NO;
        }
    }
    if (!isMy) {
        if (!self.basicModel.comyAddrs) {
            [Helper alertMessage:@"请选择单位地址" addToView:self.view];
            return NO;
        } else if (self.basicModel.companyDetailAddress.length<2||self.basicModel.companyDetailAddress.length>50) {
            [Helper alertMessage:@"请输入详细地址,不能超过50个字符" addToView:self.view];
            return NO;
        } else if (self.basicModel.comyName.length<2||self.basicModel.comyName.length>100) {
            [Helper alertMessage:@"请输入公司名称,不能超过100个字符" addToView:self.view];
            return NO;
        } else if (self.basicModel.officePhone.length<6||self.basicModel.officePhone.length>20) {
            [Helper alertMessage:@"请输入正确的电话号码" addToView:self.view];
            return NO;
        } else if (!self.basicModel.industryName) {
            [Helper alertMessage:@"请选择所属行业" addToView:self.view];
            return NO;
        } else if (!self.basicModel.jobRankName) {
            [Helper alertMessage:@"请选择单位职能" addToView:self.view];
            return NO;
        }
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
