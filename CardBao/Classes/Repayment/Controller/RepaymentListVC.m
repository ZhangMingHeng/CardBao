//
//  RepaymentListVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/19.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RepaymentModel.h"
#import "RepaymentListVC.h"
#import "RepaymentListCell.h"
#import "RepaymentDetailsVC.h"

@interface RepaymentListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    NSMutableArray *sourceRepaymentArray; // 还款中数据
    NSMutableArray *sourceEndArray; // 结束数据
    BOOL isUpDate; // 是否刷新
}
@end

@implementation RepaymentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_RepaymentState == NSRepaymentStateInRepayment) sourceRepaymentArray = [NSMutableArray new];
    else sourceEndArray = [NSMutableArray new];
    [self getUI];
    [self requestData:YES];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_RepaymentState == NSRepaymentStateInRepayment) {
        if (isUpDate) {
            [self requestData:NO];
        }
        isUpDate = YES; 
    }
}
#pragma mark requestData
-(void)requestData:(BOOL) loading {
    NSString *status = nil;
    NSString *msg    = nil;
    if (_RepaymentState == NSRepaymentStateInRepayment){
        status = @"3";
        msg    = @"还没有去借款咯";
    } else {
        status = @"4";
        msg    = @"还没有去还款咯";
    }
    // status: 3-还款中  4-已结清
    [[RequestManager shareInstance]postWithURL:GETREPAYMENTLIST_INTERFACE parameters:@{@"status":status} isLoading:loading loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        if (self.RepaymentState == NSRepaymentStateInRepayment) [self->sourceRepaymentArray removeAllObjects];
        else [self->sourceEndArray removeAllObjects];
        
        if ([Helper justArray:model]) {
            for (NSDictionary *dic in model) {
                RepaymentModel *reModel = [RepaymentModel yy_modelWithJSON:dic];
                if (self.RepaymentState == NSRepaymentStateInRepayment) [self->sourceRepaymentArray addObject:reModel];
                else [self->sourceEndArray addObject:reModel];
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:msg addToView:self.view];
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
#pragma mark GetUI
-(void)getUI {
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [listTableView registerClass:[RepaymentListCell class] forCellReuseIdentifier:@"RepaymentListCell"];
    listTableView.dataSource         = self;
    listTableView.delegate           = self;
    listTableView.estimatedRowHeight = 123.5;
    listTableView.backgroundColor    = DYGrayColor(243);
    listTableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    listTableView.tableFooterView    = [UIView new];
    [self.view addSubview:listTableView];
    
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
    listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData:NO];
    }];
    
}
#pragma mark TableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_RepaymentState == NSRepaymentStateInRepayment) return sourceRepaymentArray.count;
    else return sourceEndArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 10;
    else return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RepaymentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepaymentListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RepaymentModel *model = sourceRepaymentArray[indexPath.section];
    if (_RepaymentState == NSRepaymentStateInRepayment) {
        [cell.button addTarget:self action:@selector(repaymentClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button setBackgroundImage:[UIImage imageNamed:@"My_fullButton"] forState:UIControlStateNormal];
        [cell.button setTitle:@"立即还款" forState:UIControlStateNormal];
    } else {
        model = sourceEndArray[indexPath.section];
        [cell.button setTitle:@"已结清" forState:UIControlStateNormal];
        [cell.button setTitleColor:DYGrayColor(161.0) forState:UIControlStateNormal];
    }
    
    cell.moneyLabel.attributedText = [self setAttributedStringColor:[NSString stringWithFormat:@"本期应还(元)\n¥ %@",[Helper isNullToString:model.loanAmount returnString:@"0.00"]] range:NSMakeRange(0, 7)];
    cell.monthLabel.text           = [NSString stringWithFormat:@"借款期限：%@个月",model.loanLimit];
    cell.dateLabel.text            = [NSString stringWithFormat:@"最近还款日：%@",model.loanRecordTime];
    cell.codeLabel.text            = model.kaobaoId;
    cell.button.tag                = indexPath.section;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_RepaymentState == NSRepaymentStateInRepayment) {
        RepaymentModel *model = sourceRepaymentArray[indexPath.section];
        RepaymentDetailsVC *detailsVC = [RepaymentDetailsVC new];
        detailsVC.iId                 = model.iId;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
}
#pragma mark 进入详情页面
-(void)repaymentClick:(UIButton*)sender {
    RepaymentModel *model = sourceRepaymentArray[sender.tag];
    RepaymentDetailsVC *detailsVC = [RepaymentDetailsVC new];
    detailsVC.iId                 = model.iId;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
// 颜色、行距富文本、字体大小
-(NSMutableAttributedString*)setAttributedStringColor:(NSString*) string range:(NSRange)range{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 8;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:DYGrayColor(161) range:range];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:range];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
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
