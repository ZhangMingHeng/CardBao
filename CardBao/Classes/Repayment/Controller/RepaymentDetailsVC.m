//
//  RepaymentDetailsVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//
#import "RepaymentModel.h"
#import "AdvanceEndAlert.h"
#import "RepaymentPlanVC.h"
#import "RepaymentDetailsVC.h"
#import "RepaymentDetailsCell.h"

@interface RepaymentDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    RepaymentDetailsModel *detailsModel;
    RepaymentStatementsModel *statementsModel;
}
@end

@implementation RepaymentDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
    [self requestData:YES];
}
-(void)requestData:(BOOL)loading {
    [[RequestManager shareInstance]postWithURL:GETREPAYMENTDETAILS_INTERFACE parameters:@{@"id":[NSNumber numberWithInteger:self.iId]} isLoading:loading loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        if ([Helper justDictionary:model]) {
            self->detailsModel = [RepaymentDetailsModel yy_modelWithJSON:model];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"没有还款数据" addToView:self.view];
            });
        }
        [self->listTableView reloadData];
        [self->listTableView.mj_header endRefreshing];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->listTableView.mj_header endRefreshing];
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->listTableView.mj_header endRefreshing];
    } isCache:NO];
}
#pragma mark GETUI
-(void)getUI {
    self.title = @"我要还款";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提前结清" style:UIBarButtonItemStyleDone target:self action:@selector(advanceEnd:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [listTableView registerClass:[RepaymentDetailsCell class] forCellReuseIdentifier:@"RepaymentDetailsCell"];
    listTableView.dataSource         = self;
    listTableView.delegate           = self;
    listTableView.estimatedRowHeight = 200;
    listTableView.backgroundColor    = DYGrayColor(243);
//    listTableView.scrollEnabled      = NO;
    listTableView.tableFooterView    = [UIView new];
    [self.view addSubview:listTableView];
    listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData:NO];
    }];
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
}
#pragma mark TableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([detailsModel.currentStatus isEqualToString:@"1"]) {
        return 3;
    }
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0;
    else return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view         = [UIView new];
    view.backgroundColor = DYGrayColor(243);
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idf = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idf];
    
    if (indexPath.section == 0) {
        cell.separatorInset = UIEdgeInsetsMake(0, screenWidth,0, -screenWidth);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSectionOne:cell];
        
        
    } else if (indexPath.section == 1&&[detailsModel.currentStatus isEqualToString:@"1"]) {
        RepaymentDetailsCell *cellA = [tableView dequeueReusableCellWithIdentifier:@"RepaymentDetailsCell"];
        cellA.separatorInset = UIEdgeInsetsMake(0, screenWidth,0, -screenWidth);
        
        // 赋值
        cellA.currentTotalLabel.attributedText = [self setAttributedStringColor:[NSString stringWithFormat:@"当前应还(元)\n¥ %@元",[Helper isNullToString:detailsModel.currentTotal returnString:@"0.00"]] range:NSMakeRange(0, 7)];
        cellA.billLabel.text         = [NSString stringWithFormat:@"第%@/%@期账单",detailsModel.totalTerm,detailsModel.currentTerm];
        cellA.moneyLabel.text        = [NSString stringWithFormat:@"应还本金：%@",[Helper isNullToString:detailsModel.principal returnString:@"0.00"]];
        cellA.interestLabel.text     = [NSString stringWithFormat:@"应还利息：%@",[Helper isNullToString:detailsModel.interest returnString:@"0.00"]];
        cellA.dateLabel.text         = [NSString stringWithFormat:@"应还日期：%@",[Helper isNullToString:detailsModel.date returnString:@"无"]];
        cellA.penaltyLabel.text      = [NSString stringWithFormat:@"应还罚息：%@",[Helper isNullToString:detailsModel.penaltyInterest returnString:@"0.00"]];
        
        [cellA.repaymentButton addTarget:self action:@selector(repaymentClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cellA.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellA;
        
    } else {
        cell.separatorInset = UIEdgeInsetsZero;
        cell.textLabel.text = @"还款计划";
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"查看";
    }
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2||(indexPath.section == 1&&[detailsModel.currentStatus isEqualToString:@"0"])) {
        RepaymentPlanVC *planVC = [RepaymentPlanVC new];
        planVC.iId              = self.iId;
        [self.navigationController pushViewController:planVC animated:YES];
    }
}
-(void)initSectionOne:(UITableViewCell*)cell {
    // 背景
    UIImageView *headerImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Common_backgroundHeader"]];
    headerImg.contentMode  = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:headerImg];
    
    // 文字
    UILabel *payLabel       = [UILabel new];
    payLabel.textColor      = [UIColor whiteColor];
    payLabel.textAlignment  = NSTextAlignmentCenter;
    payLabel.numberOfLines  = 0;
    payLabel.attributedText = [self setAttributeStringFont:[NSString stringWithFormat:@"当前应还(元)\n¥ %@",[Helper isNullToString:detailsModel.currentTotal returnString:@"0.00"]]];
    [headerImg addSubview:payLabel];
    
    NSArray *titleArray = @[[NSString stringWithFormat:@"借款金额\n%.2f元",[[Helper isNullToString:detailsModel.total returnString:@"0.00"] floatValue]],[NSString stringWithFormat:@"待还金额\n%.2f元",[[Helper isNullToString:detailsModel.repayMoney returnString:@"0.00"] floatValue]],[NSString stringWithFormat:@"借款期限\n%@个月",[Helper isNullToString:detailsModel.term returnString:@"0"]]];
    for (int i = 0; i<titleArray.count; i++) {
        
        UILabel *label       = [UILabel new];
        label.attributedText = [self setAttributedStringColor:titleArray[i] range:NSMakeRange(0, 4)];
        label.numberOfLines  = 0;
        label.textAlignment  = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerImg.mas_bottom).offset(15);
            make.bottom.equalTo(cell.contentView).offset(-15);
            make.left.equalTo(cell.contentView).offset(i*screenWidth/3.0);
            make.width.mas_equalTo(screenWidth/3.0);
        }];
    }
    // 布局
    [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(cell.contentView);
        make.height.mas_equalTo(DYCalculateHeigh(99));
    }];
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerImg);
    }];
}
#pragma mark 提前结束 和立即还款
-(void)advanceEnd:(UIBarButtonItem*)sender {
    // 获取提前结算单的数据
    // id: 还款Id
    [[RequestManager shareInstance]postWithURL:GETREPAYMENTSTATEMENTS_INTERFACE parameters:@{@"id":[NSNumber numberWithInteger:self.iId]} isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        if ([Helper justDictionary:model]) {
            self->statementsModel = [RepaymentStatementsModel yy_modelWithJSON:model];
            if (self->statementsModel) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI线程
                    [self getRepaymentAlertView:self->statementsModel];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI线程
                    [Helper alertMessage:@"没有结算单的数据" addToView:self.view];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"没有结算单的数据" addToView:self.view];
            });
        }
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
    
}
-(void)repaymentClick:(UIButton*)sender {
    
    // 立即还款
    // repaymentType:01-提前还款 02-立即还款   id: 还款Id   repayMoney: 还款金额
    // repayTerms: 还款期次

    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"02" forKey:@"repaymentType"];
    [parameters setValue:[Helper isNullToString:detailsModel.currentTotal returnString:@""] forKey:@"repayMoney"];
    [parameters setValue:[Helper isNullToString:detailsModel.totalTerm returnString:@""] forKey:@"repayTerms"];
    [self requestRepayment:parameters];
}
-(void)requestRepayment:(NSMutableDictionary*) parameters {
    // 提前和当期还款共同的参数
    [parameters setValue:[NSNumber numberWithInteger:self.iId] forKey:@"id"];
    
    [[RequestManager shareInstance]postWithURL:SUBMITREPAYMENT_INTERFACE parameters:parameters isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [Helper alertMessage:@"还款成功" addToView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
-(void) getRepaymentAlertView:(RepaymentStatementsModel*) model {
    
    AdvanceEndAlert *alert = [[AdvanceEndAlert alloc]init];
    alert.totalNum         = [NSString stringWithFormat:@"还款总额：%@元",model.total];
    alert.moneyNum         = [NSString stringWithFormat:@"剩余本金：%@元",model.principal];
    alert.interestNum      = [NSString stringWithFormat:@"剩余利息：%@元",model.interest];
    alert.feeNum           = [NSString stringWithFormat:@"手续费：%@元",model.serviceCharge];
    alert.damageNum        = [NSString stringWithFormat:@"违约金：%@元",model.damage];
    alert.event = ^(NSInteger index) {
        // index 1 取消， 2确定
        // 提前还款
        // repaymentType:01-提前还款 02-立即还款   id: 还款Id   repayMoney: 还款金额
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:@"01" forKey:@"repaymentType"];
        [parameters setValue:[Helper isNullToString:self->statementsModel.total returnString:@""] forKey:@"repayMoney"];
        if (index==2) [self requestRepayment:parameters];
    };
}
// 颜色、行距富文本
-(NSMutableAttributedString*)setAttributedStringColor:(NSString*) string range:(NSRange)range{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 8;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:DYGrayColor(161) range:range];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    return attributedString;
}
// 字体大小富文本
-(NSMutableAttributedString*)setAttributeStringFont:(NSString*)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:25];
    [attributedString addAttributes:dic range:NSMakeRange(7, string.length-7)];
    return attributedString;
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
