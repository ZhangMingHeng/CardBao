//
//  RepaymentListVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/19.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RepaymentListVC.h"
#import "RepaymentListCell.h"
#import "RepaymentDetailsVC.h"

@interface RepaymentListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
}
@end

@implementation RepaymentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
#pragma mark GetUI
-(void)getUI {
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [listTableView registerClass:[RepaymentListCell class] forCellReuseIdentifier:@"RepaymentListCell"];
    listTableView.dataSource         = self;
    listTableView.delegate           = self;
    listTableView.estimatedRowHeight = 200;
    listTableView.backgroundColor    = DYGrayColor(243);
    listTableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    listTableView.tableFooterView    = [UIView new];
    [self.view addSubview:listTableView];
    
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
    listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        [self requestData:NO];
    }];
    
}
#pragma mark TableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 10;
    else return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
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
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    cell.moneyLabel.text    = @"¥500.00";
    cell.monthLabel.text    = @"4个月";
    cell.dateLabel.text     = @"2018-09-09";
    cell.codeLabel.text     = @"卡宝1254531";
    cell.button.tag         = indexPath.row;
    
    if (_RepaymentState == NSRepaymentStateInRepayment) {
        [cell.button addTarget:self action:@selector(repaymentClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button setBackgroundImage:[UIImage imageNamed:@"My_fullButton"] forState:UIControlStateNormal];
        [cell.button setTitle:@"立即还款" forState:UIControlStateNormal];
    } else {
        [cell.button setTitle:@"已结清" forState:UIControlStateNormal];
        [cell.button setBackgroundColor:[UIColor lightGrayColor]];
    }
    return cell;
}
#pragma mark 进入详情页面
-(void)repaymentClick:(UIButton*)sender {
    RepaymentDetailsVC *detailsVC = [RepaymentDetailsVC new];
    [self.navigationController pushViewController:detailsVC animated:YES];
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
