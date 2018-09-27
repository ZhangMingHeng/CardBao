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


@interface LoanVC ()<UITableViewDelegate,UITableViewDataSource>

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
    
    [[RequestManager shareInstance]postWithURL:BASEINFO_INTERFACE parameters:nil isLoading:loading loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        [self.tableView.mj_header endRefreshing];
        NSDictionary *dic = @{@"step":@1,@"maxCredit":@"50000",@"availableCredit":@"1099"};
        if ([Helper justDictionary:dic]) {
            self->_loanModel = [LoanModel yy_modelWithDictionary:dic];
        }
     
        [self.tableView reloadData];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:YES];
}
#pragma mark getUI
-(void)getUI {
    [self.navigationItem setTitle:@"卡宝"];
    //  viewcontroller 不会被tabbar遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    // 喇叭位置
    UIView *headView = [UIView new];
    [self.view addSubview:headView];
    UILabel *lineLabel        = [UILabel new];
    UIImageView *img          = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Loan_horn"]];
    lineLabel.backgroundColor = DYColor(173, 170, 244);
    [headView addSubview:lineLabel];
    [headView addSubview:img];
    TextLoopView *loopView = [TextLoopView textLoopViewWith:loopText loopInterval:5 initWithFrame:CGRectMake(35, 0, screenWidth-40, 44) selectBlock:^(NSString *selectString, NSInteger index) {
        
    }];
    [headView addSubview:loopView];
    
    
    // tableView
    _tableView    = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    
    // 布局
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(10);
        make.centerY.equalTo(headView).offset(-1);
        make.height.width.mas_equalTo(20);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView);
        make.height.mas_equalTo(1);
        make.left.equalTo(headView).offset(10);
        make.right.equalTo(headView).offset(-10);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
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
    return CGRectGetHeight(tableView.frame);
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *idF = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    cell.separatorInset   = UIEdgeInsetsZero;
    
    [self getCell:cell];// UI
    
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 禁止上滑
    CGPoint offset = scrollView.contentOffset;
    if (offset.y > 0) {
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
}
-(void)getCell:(UITableViewCell*)cell {
    
    // 额度状态
    UIButton *limitLabel                = [UIButton new];
    limitLabel.titleLabel.numberOfLines = 2;
    limitLabel.userInteractionEnabled   = NO;
    limitLabel.titleLabel.font          = DYNormalFont;
    limitLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [limitLabel setTitle:@"最高授信额度\n5000元" forState:UIControlStateNormal];
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
        make.width.height.mas_equalTo(DYCalculate(247));
        make.centerX.equalTo(cell.contentView);
        make.top.equalTo(cell.contentView).offset(DYCalculate(50));
    }];
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(limitLabel.mas_bottom).offset(20);
        make.centerX.equalTo(cell.contentView);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(25);
        make.right.equalTo(cell.contentView).offset(-25);
        make.height.mas_equalTo(40);
        make.top.equalTo(remarkLabel.mas_bottom).offset(DYCalculate(50));
    }];
    
    switch (self.loanModel.step) {
        case BusinessStateQuotaCalculation:
        {
            // 额度计算中
//            limitLabel.text  = @"额度计算中...";
            [limitLabel setTitle:@"额度计算中..." forState:UIControlStateNormal];
            remarkLabel.text = @"额度计算完成后，会短信通知您，请耐心等待。";
            button.enabled   = NO;
            [button setTitle:@"额度计算中" forState:UIControlStateNormal];
        }
            break;
        case BusinessStateScoreLess:
        {
            // 评分不足
//            limitLabel.text  = @"综合评分不足";
            [limitLabel setTitle:@"综合评分不足" forState:UIControlStateNormal];
            remarkLabel.text = @"请2018年10月11号后再来申请额度。";
            button.enabled   = NO;
            [button setTitle:@"综合评分不足" forState:UIControlStateNormal];
        }
            break;
        case BusinessStateAuthTimeout:
        {
            // 授权超时
//            limitLabel.text  = @"授信额度超时\n请重新获取";
            [limitLabel setTitle:@"授信额度超时\n请重新获取" forState:UIControlStateNormal];
            remarkLabel.text = @"";
            [button setTitle:@"重新获取额度" forState:UIControlStateNormal];
        }
            break;
        case BusinessStateAuthSuccess:
        {
            // 授权成功
//            limitLabel.text  = [NSString stringWithFormat:@"可用额度\n%@元",self.loanModel.availableCredit];
            [limitLabel setTitle:[NSString stringWithFormat:@"可用额度\n%@元",self.loanModel.availableCredit] forState:UIControlStateNormal];
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
    
    NSDictionary *parameters = @{@"prodSubNo":PRODUCTNO,@"openId":@""};
    [[RequestManager shareInstance]postWithURL:CREATECREDITORDER_INTERFACE parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        NSDictionary *dic = model;
        if ([Helper justDictionary:dic]) {
            
            // 存储授信编号
            INPUTCREDITNO(dic[@"creditNo"]);
            
            creditVC.creditNo = [Helper isNullToString:kCREDITNO returnString:@""];
            creditVC.viewPush = CreditViewPushIdentity;
            [self.navigationController pushViewController:creditVC animated:YES];
            
        }
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:nil];
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
