//
//  LoanVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/18.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "LoanVC.h"
#import "LoanModel.h"
#import "ApplyLoanVC.h"
#import <YJBannerView.h>
#import "TextLoopView.h"
#import "CreditExtensionMainVC.h"

#define loopText @[@"167****1028 成功借款20000元",@"170****1928 成功借款20000元",@"180****9128 成功借款50000元",@"171****1298 成功借款20000元",@"170****9218 成功借款21000元",@"180****1800 成功借款45000元"]

// 业务状态定义
static int const BusinessStateDefault          = 0; // 无授权
static int const BusinessStateIdentity         = 1; // 上传身份证
static int const BusinessStateBingBankCard     = 2; // 绑定银行卡
static int const BusinessStateBasicInfo        = 3; // 填写基本信息
static int const BusinessStateZHIMACredit      = 4; // 芝麻认证
static int const BusinessStateOperator         = 5; // 运营商认证
static int const BusinessStateQuotaCalculation = 6; // 计算中
static int const BusinessStateScoreLess        = 7; // 评分不足
static int const BusinessStateAuthTimeout      = 8; // 授权超时
static int const BusinessStateAuthSuccess      = 9; // 授权成功


@interface LoanVC ()<UITableViewDelegate,UITableViewDataSource,YJBannerViewDataSource, YJBannerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) LoanModel *loanModel;
@end

@implementation LoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
    [self requestData:YES];
}
#pragma mark requestData
-(void)requestData:(BOOL)loading {
    // account:用户账号\手机号码
    [[RequestManager shareInstance]postWithURL:BASEINFO_INTERFACE parameters:@{@"account":kUserPHONE} isLoading:loading loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        [self.tableView.mj_header endRefreshing];
        if ([Helper justDictionary:model]) {
            self->_loanModel = [LoanModel yy_modelWithDictionary:model];
        }
     
        [self.tableView reloadData];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self.tableView.mj_header endRefreshing];
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self.tableView.mj_header endRefreshing];
    } isCache:YES];
}
#pragma mark getUI
-(void)getUI {
    [self.navigationItem setTitle:@"卡宝"];
    //  viewcontroller 不会被tabbar遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // tableView
    _tableView    = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // 布局
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData:NO];
    }];
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 600-226+DYCalculate(226);
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *idF = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    // banner
    YJBannerView *bannerView = [YJBannerView bannerViewWithFrame:CGRectMake(0, 0, screenWidth, 86) dataSource:self delegate:self emptyImage:nil placeholderImage:nil selectorString:nil];
    [cell.contentView addSubview:bannerView];
    bannerView.pageControlHighlightColor = HomeColor;
    [bannerView reloadData];
    
    // 喇叭位置
    UIView *headView         = [UIView new];
    headView.backgroundColor = DYGrayColor(239);
    UIImageView *img         = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Loan_horn"]];
    [headView addSubview:img];
    [cell.contentView addSubview:headView];
    TextLoopView *loopView = [TextLoopView textLoopViewWith:loopText loopInterval:3 initWithFrame:CGRectMake(35, 0, screenWidth-40, 35) selectBlock:^(NSString *selectString, NSInteger index) {
        
    }];
    [headView addSubview:loopView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView);
        make.top.equalTo(cell.contentView).offset(86);
        make.height.mas_equalTo(35);
    }];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(10);
        make.centerY.equalTo(headView).offset(-1);
        make.height.width.mas_equalTo(20);
    }];
    [cell.contentView addSubview:headView];
    
    
    [self getCell:cell];// UI
    
    
    return cell;
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    // 禁止上滑
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y > 0) {
//        offset.y = 0;
//    }
//    scrollView.contentOffset = offset;
//}
-(void)getCell:(UITableViewCell*)cell {
    
    // 额度状态
    UIButton *limitLabel                = [UIButton new];
    limitLabel.titleLabel.numberOfLines = 3;
    limitLabel.userInteractionEnabled   = NO;
    limitLabel.titleLabel.font          = DYNormalFont;
    limitLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    limitLabel.titleLabel.font          = [UIFont systemFontOfSize:24.0 weight:0.9];
    [limitLabel setTitle:@"\n最高授信额度\n50,000元" forState:UIControlStateNormal];
    [limitLabel setTitleColor:DYColor(0.0, 145.0, 234.0) forState:UIControlStateNormal];
    [limitLabel setBackgroundImage:[UIImage imageNamed:@"Loan_Background"] forState:UIControlStateNormal];
    [cell.contentView addSubview:limitLabel];
    
    
    // 备注
    UILabel *remarkLabel      = [UILabel new];
    remarkLabel.text          = @"快速审批，超低利率";
    remarkLabel.numberOfLines = 0;
    remarkLabel.font          = DYNormalFont;
    [cell.contentView addSubview:remarkLabel];
    
    // 按钮 查看、借款按钮、计算、重新、评分不足(同一个，根据用户状态显示)
    UIButton *button          = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 20;
    button.clipsToBounds      = YES;
    [button setTitle:@"查看我的额度" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getLimitClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    
    // 布局
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView);
        make.width.mas_equalTo(DYCalculate(261));
        make.height.mas_equalTo(DYCalculate(226));
        make.top.equalTo(cell.contentView).offset(DYCalculate(35+86+20));
    }];
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView);
        make.top.equalTo(limitLabel.mas_bottom).offset(40);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(cell.contentView).offset(37);
        make.right.equalTo(cell.contentView).offset(-37);
        make.top.equalTo(remarkLabel.mas_bottom).offset(DYCalculate(40));
    }];
    
    switch (self.loanModel.step) {
        case BusinessStateQuotaCalculation:
        {
            // 额度计算中
//            limitLabel.text  = @"额度计算中...";
            [limitLabel setTitle:@"\n额度计算中..." forState:UIControlStateNormal];
            remarkLabel.text = @"额度计算完成后，会短信通知您，请耐心等待。";
            button.enabled   = NO;
            [button setTitle:@"额度计算中" forState:UIControlStateNormal];
        }
            break;
        case BusinessStateScoreLess:
        {
            // 评分不足
//            limitLabel.text  = @"综合评分不足";
            [limitLabel setTitle:@"\n综合评分不足" forState:UIControlStateNormal];
            remarkLabel.text = @"请2018年10月11号后再来申请额度。";
            button.enabled   = NO;
            [button setTitle:@"综合评分不足" forState:UIControlStateNormal];
        }
            break;
        case BusinessStateAuthTimeout:
        {
            // 授权超时
//            limitLabel.text  = @"授信额度超时\n请重新获取";
            [limitLabel setTitle:@"\n授信额度超时\n请重新获取" forState:UIControlStateNormal];
            remarkLabel.text = @"";
            [button setTitle:@"重新获取额度" forState:UIControlStateNormal];
        }
            break;
        case BusinessStateAuthSuccess:
        {
            // 授权成功
//            limitLabel.text  = [NSString stringWithFormat:@"可用额度\n%@元",self.loanModel.availableCredit];
            [limitLabel setTitle:[NSString stringWithFormat:@"\n可用额度\n%@元",self.loanModel.availableCredit] forState:UIControlStateNormal];
            remarkLabel.text = [NSString stringWithFormat:@"总额度%@元",self.loanModel.maxCredit];
            [button setTitle:@"立即借款" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark 获取额度、借款事件
-(void)getLimitClick:(UIButton*)sender {
    
    if (self.loanModel.step == BusinessStateAuthSuccess) {
        // 已授权成功
        
        // 小于1000元不给申请借款
        if ([[Helper isNullToString:self.loanModel.availableCredit returnString:@0] intValue] < 1000) {
            [Helper alertMessage:@"可用额度低于1000，暂无法申请借款" addToView:self.view];
            return;
        }
        
        // 申请借款
        ApplyLoanVC *applyVC = [ApplyLoanVC new];
        [self.navigationController pushViewController:applyVC animated:YES];
        
        return;
    }
    
    CreditExtensionMainVC *creditVC = [CreditExtensionMainVC new];
    creditVC.creditNo               = [Helper isNullToString:kCREDITNO returnString:@""];
    
    if (self.loanModel.step == BusinessStateAuthTimeout) {
        
        // 授信超时，跳转到信息确认页面
        creditVC.viewPush = CreditViewPushConfirmInfo;
        
    } else if (self.loanModel.step == BusinessStateDefault) {
        // 首次点击
        // 上传身份
        [self getCreditNo:creditVC];
    
        return;
        
    } else if (self.loanModel.step == BusinessStateIdentity) {
        
        // 非首次点击
        // 上传身份
        creditVC.viewPush = CreditViewPushIdentity;
        
    } else if (self.loanModel.step == BusinessStateBingBankCard) {
        
        // 绑定银行卡
        creditVC.viewPush = CreditViewPushBankCard;
        
    }else if (self.loanModel.step == BusinessStateBasicInfo) {
        
        // 基本信息
        creditVC.viewPush = CreditViewPushBasicInfo;
        
    } else if (self.loanModel.step == BusinessStateZHIMACredit) {
        
        // 芝麻信用
        creditVC.viewPush = CreditViewPushZHIMACredit;
        
    }  else if (self.loanModel.step == BusinessStateOperator) {
        
        // 运营商认证
        creditVC.viewPush = CreditViewPushOperator;
        
    }
    [self.navigationController pushViewController:creditVC animated:YES];

    
    
}
-(void)getCreditNo:(CreditExtensionMainVC*) creditVC{
    // 授信流程视图
    
//    NSDictionary *parameters = @{@"prodSubNo":PRODUCTNO,@"openId":@""};
//    [[RequestManager shareInstance]postWithURL:CREATECREDITORDER_INTERFACE parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
//        NSDictionary *dic = model;
//        if ([Helper justDictionary:dic]) {
    
            // 存储授信编号
//            INPUTCREDITNO(dic[@"creditNo"]);
    
            creditVC.creditNo = [Helper isNullToString:kCREDITNO returnString:@""];
            creditVC.viewPush = CreditViewPushIdentity;
            [self.navigationController pushViewController:creditVC animated:YES];
            
//        }
        
//    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
//
//    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
//
//    } isCache:NO];
}

#pragma mark @protocol YJBannerViewDataSource
- (NSArray *)bannerViewImages:(YJBannerView *)bannerView {
    
    return @[@"Loan_banner",@"Loan_banner1",@"Loan_banner2"];
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
