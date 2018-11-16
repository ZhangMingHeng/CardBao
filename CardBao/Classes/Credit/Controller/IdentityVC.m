//
//  IdentityVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#define GETFACEIDINFO_INTERFACE @"https://api.megvii.com/faceid/v3/sdk/verify"
#define GETFACEIDTOKEN_INTERFACE @"https://api.megvii.com/faceid/v3/sdk/get_biz_token"

#import "IdentityVC.h"
#import "BasicInfoVC.h"
#import "ContactData.h"
#import "CreditModel.h"
#import "BingBankCardVC.h"
#import <AdSupport/AdSupport.h>
#import "CreditExtensionMainVC.h"


@interface IdentityVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *listTableView;
    NSArray *titleArray;
    NSMutableArray <UIImage *> *photoArray;
    NSMutableDictionary *contactDic; // 通讯录数据
    
    NSString *latitude; // 纬度
    NSString *longitude; // 经度
    NSString *gpsProvince; // 省份
    NSString *gpsCity; // 城市
    NSString *ipAddress;
//    BOOL selectPortrait;
//    BOOL selectEmblem;

}
@property (nonatomic, strong) IdentityModel* identityModel; // 身份证数据

@end

@implementation IdentityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self localData];
    [self getUI];
    
}
-(void)localData {
    photoArray = [NSMutableArray arrayWithObjects:[UIImage new],[UIImage new],nil];
    titleArray = @[@"        请确认姓名、身份证信息是否正确",@"姓名",@"身份证号"];
    self.identityModel = [IdentityModel new];
    if (self.userName&&self.idCardNo) {
        self.identityModel.userIDCardName   = self.userName;
        self.identityModel.userIDCardNumber = self.idCardNo;
    }
    // 初始化通讯录数据
    contactDic = [[NSMutableDictionary alloc]init];
    
    // 调用通讯录类
    NSMutableArray *contactArray = [NSMutableArray new];
    [[ContactData shareInstance]requestContactAuthorAfter:self resultBlock:^(ContactData * _Nonnull manage, NSInteger code, NSDictionary * _Nonnull result) {
        BLYLogInfo(@"\n\nContactresult:%@\n\n",result);
        [contactArray addObject:result];
        if (!self->contactDic[@"data"]) [self->contactDic setValue:contactArray forKey:@"data"];
        
    }];
    
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
#pragma mark getUI
-(void)getUI {
    
    CreditExtensionMainVC *viewC = self.navigationController.viewControllers.lastObject;
    viewC.title = @"身份认证";
    viewC.stepLabel.text = @"2/4";
    
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.rowHeight       = 50;
    listTableView.tableFooterView = [UIView new];
    [self.view addSubview:listTableView];
    
    // FootView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
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
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(37);
        make.right.equalTo(footView).offset(-37);
        make.height.mas_equalTo(45);
        make.top.equalTo(footView).offset(20);
    }];
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 400;
    }
    return 50;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF  = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0 ){
//        CGFloat buttonW = 249;
//        CGFloat buttonH = 154;
//        NSArray *textArray = @[@"身份证正面",@"身份证反面",@"手持身份证",@"本人头像照"];

        // 生成附件
        NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
        textAttach.image = [UIImage imageNamed:@"Credit_tips"];
        textAttach.bounds = CGRectMake(20, -3, 15, 15);
        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:textAttach];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:titleArray[indexPath.row]];
        [attri insertAttributedString:imgAtt atIndex:0];
        
        UILabel *tipsLabel        = [UILabel new];
        tipsLabel.attributedText  = attri;
        tipsLabel.textColor       = [UIColor lightGrayColor];
        tipsLabel.font            = [UIFont systemFontOfSize:12.0];
        tipsLabel.backgroundColor = DYGrayColor(239.0);
        [cell.contentView addSubview:tipsLabel];
        
        CGFloat buttonW = (screenWidth-20*3)/2;
        CGFloat buttonH = 120;
        NSArray *textArray = @[@"身份证人像面",@"身份证国徽面",@"手持身份证",@"本人头像照"];
        NSArray *imgArray = @[@"Credit_ident",@"Credit_ident1",@"Credit_ident2",@"Credit_ident3"];
        for (int i = 0; i<textArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag       = 10+i;
            [button setTitle:textArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectImgClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(20+i%2*(buttonW+20));
                make.top.equalTo(tipsLabel.mas_bottom).offset(20+(int)i/2*(20+buttonH));
                make.width.mas_equalTo(buttonW);
                make.height.mas_equalTo(buttonH);
            }];
            button.layer.borderColor = [UIColor blackColor].CGColor;
            button.layer.borderWidth = 1.0;
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            if (i == 0&&self.identityModel.idcardPortraitImage) [button setImage:self.identityModel.idcardPortraitImage forState:UIControlStateNormal];
            else if (i == 1&&self.identityModel.idcardEmblemImage) [button setImage:self.identityModel.idcardEmblemImage forState:UIControlStateNormal];
            else if (i == 2&&self.identityModel.handheldImage) [button setImage:self.identityModel.handheldImage forState:UIControlStateNormal];
            else if (i == 3&&self.identityModel.userImage)[button setImage:self.identityModel.userImage forState:UIControlStateNormal];
        }
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(cell.contentView);
            make.height.mas_equalTo(30.0);
        }];
    } else {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text     = titleArray[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(20);
            make.centerY.equalTo(cell.contentView);
        }];
        UITextField *input = [UITextField new];
        input.delegate     = self;
        
        input.placeholder  = indexPath.row == 1?@"请输入真实姓名":@"请输入真实身份证号";
        input.text         = indexPath.row == 1?self.identityModel.userIDCardName:self.identityModel.userIDCardNumber;
        [cell.contentView addSubview:input];
        
        
        
        [input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(100);
            make.right.equalTo(cell.contentView).offset(-20);
            make.centerY.equalTo(cell.contentView);
        }];
    }
    return  cell;
}
#pragma mark TextField Protocol
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.placeholder isEqualToString:@"请输入真实姓名"]) {
        
        self.identityModel.userIDCardName = textField.text;
        
    } else {
        
        self.identityModel.userIDCardNumber = textField.text;
    }

    
}
#pragma mark 选择相册或相机
-(void)selectImgClick:(UIButton*)sender {
    
    
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount      = 1;
    ac.configuration.allowSelectVideo    = NO;
    ac.configuration.showSelectedMask    = YES;
    ac.configuration.allowRecordVideo    = NO;
    ac.configuration.allowSelectOriginal = NO;
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
//        [sender setImage:images[0] forState:UIControlStateNormal];
//        sender.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        if (sender.tag == 10){
            // 人像
            // 获取到图片后请求上传
            [self requestUploadFile:images[0] parameters:@{@"imageType":@"01"} fileType:@"png" source:sender.tag];
            
        } else if (sender.tag == 11) {
            // 国徽面
            // 获取到图片后请求上传
            [self requestUploadFile:images[0] parameters:@{@"imageType":@"02"} fileType:@"png" source:sender.tag];
            
        } else if (sender.tag == 12) {
            // 手持相
            [self requestUploadFile:images[0] parameters:@{@"imageType":@"03"} fileType:@"png" source:sender.tag];
        } else {
            // 本人头相
            [self requestUploadFile:images[0] parameters:@{@"imageType":@"17"} fileType:@"png" source:sender.tag];
        }
    }];
    //调用相册
    [ac showPreviewAnimated:YES];
    
}
#pragma mark 上传文件
-(void)requestUploadFile:(id ) file parameters:(id) parameters fileType:(NSString*) fileType source:(NSInteger) tag{

    // 上传文件请求
    [[RequestManager shareInstance]upLoadPostWithUR:FILEUPLOAD_INTERFACE file:@[file] fileType:fileType parameters:parameters isLoading:YES addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        if ([Helper justDictionary:model]) {
            if ([model[@"code"] integerValue] == 0) {
                // 人像面数据
                if (tag == 10) {
                    self.identityModel.idcardPortraitImage = file;
                } else if (tag == 11) {
                    // 国徽面
//                    self->selectEmblem = YES;
                    self.identityModel.idcardEmblemImage  = file;
                } else if (tag == 12) {
                    self.identityModel.handheldImage = file;
                } else if (tag == 13) {
                    self.identityModel.userImage = file;
                }
        
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI线程
                    [self->listTableView reloadData];
                    [Helper alertMessage:@"上传成功" addToView:self.view];
                });
            } else {
                if (tag == 10||tag == 11) {
                    self.identityModel.idcardPortraitImage = [UIImage new];
                    self.identityModel.idcardEmblemImage  = [UIImage new];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI线程
                    [self->listTableView reloadData];
                    [Helper alertMessage:model[@"msg"] addToView:self.view];
                });
                
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"上传失败，数据解析错误" addToView:self.view];
            });
            
        }
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    }];
}
#pragma mark 跳转到下一步
-(void)nextClick:(UIButton*)sender {
    
    if (!UIImagePNGRepresentation(self.identityModel.idcardEmblemImage)||!UIImagePNGRepresentation(self.identityModel.idcardPortraitImage)||!self.identityModel.userImage||!self.identityModel.handheldImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI线程
            [Helper alertMessage:@"请上传身份证、头像照片" addToView:self.view];
        });
        return;
    } else if (![Helper justIdentityCard:self.identityModel.userIDCardNumber]||![Helper justName: self.identityModel.userIDCardName]||self.identityModel.userIDCardName.length<2||self.identityModel.userIDCardName.length>30) {

        dispatch_async(dispatch_get_main_queue(), ^{
            // UI线程
            [Helper alertMessage:@"请输入正确的身份信息" addToView:self.view];
        });
        return;
    }
    [self requestIdCardInfoAndContactInfo:sender];
}
-(void)requestIdCardInfoAndContactInfo:(UIButton*)sender {
    // 上传身份证信息和通讯录信息
    sender.userInteractionEnabled = NO;
    // 创建组任务
    dispatch_group_t group = dispatch_group_create();
    // 并发执行异步任务（任务是并发执行的）
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 全局队列
//
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
//          imageType:类型 communication:通讯录数据
        if (self->contactDic.count==0) {
            [Helper alertMessage:@"获取通讯录失败" addToView:self.view];
            return ;
        }
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self->contactDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *parameters = @{@"imageType":@"12",
                                     @"communication":jsonString};
        [[RequestManager shareInstance] postWithURL:FILEUPLOAD_INTERFACE parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {

            dispatch_group_leave(group);

        } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
            sender.userInteractionEnabled = YES;
        } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
            sender.userInteractionEnabled = YES;
        } isCache:NO];

    });
//
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        // deviceId: 设备Id   IMEI：imei   ip：IP地址 longiTude:经度 latiTude: 纬度  gpsCity: 城市
        // wifiMac:  wifimac  phoneModel: 手机型号  operationSys:操作系统 gpsProvince: 省份
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"equipmentInfo":@{@"deviceId":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                                                                        @"IDFA":[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                                                                                        @"phoneModel":[UIDevice currentDevice].model,
                                                                                        @"operationSys":[UIDevice currentDevice].systemName,
                                                                                        @"longiTude":self->longitude,
                                                                                        @"latiTude":self->latitude,
                                                                                        @"ip":self->ipAddress,
                                                                                        @"gpsProvince":self->gpsProvince,
                                                                                        @"gpsCity":self->gpsCity}} options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        // 保存 idCardNo:身份号码 username：姓名  chanlRiskinfo: 设备信息
        NSDictionary *parameters = @{@"idCardNo":self.identityModel.userIDCardNumber,
                                     @"username":self.identityModel.userIDCardName,
                                     @"chanlRiskinfo":jsonString};
        [[RequestManager shareInstance] postWithURL:SAVEIDCARDINFO_INTERFACE parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
            dispatch_group_leave(group);
        } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
            sender.userInteractionEnabled = YES;
        } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
            sender.userInteractionEnabled = YES;
        } isCache:NO];

    });
//
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI线程
            sender.userInteractionEnabled = YES;
//            BingBankCardVC *basicVC = [BingBankCardVC new];
//            basicVC.userName        = self.identityModel.userIDCardName;
//            basicVC.idCardNo        = self.identityModel.userIDCardNumber;
//            [self addChildViewController:basicVC];
//            self.childViewControllers[0].view.frame = self.view.bounds;
//            [self.view addSubview:basicVC.view];
            
            BasicInfoVC *basicVC = [BasicInfoVC new];
            [self addChildViewController:basicVC];
            self.childViewControllers[0].view.frame = self.view.bounds;
            [self.view addSubview:basicVC.view];
        });
        
    });
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
