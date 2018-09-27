//
//  LoanPlanVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/23.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "LoanPlanVC.h"
#import "LoanPlanCell.h"
#import "PlanHeaderView.h"

@interface LoanPlanVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    UILabel *moneyLabel;
}
@end

@implementation LoanPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
-(void)getUI {
    [self.navigationItem setTitle:@"还款计划"];
    
    // 还款总额
    moneyLabel           = [UILabel new];
    moneyLabel.text      = [NSString stringWithFormat:@"还款总额：¥54000.00"];
    moneyLabel.textColor = HomeColor;
    moneyLabel.font      = [UIFont systemFontOfSize:18];
    [self.view addSubview:moneyLabel];
    UILabel *lineLabel        = [UILabel new];
    lineLabel.backgroundColor = DYGrayColor(243);
    [self.view addSubview:lineLabel];
    
    
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource         = self;
    listTableView.delegate           = self;
    listTableView.estimatedRowHeight = 200;
    listTableView.tableFooterView    = [UIView new];
    [listTableView registerClass:[LoanPlanCell class] forCellReuseIdentifier:@"LoanPlanCell"];
    [listTableView registerClass:[PlanHeaderView class] forHeaderFooterViewReuseIdentifier:@"PlanHeaderView"];
    [self.view addSubview:listTableView];
    
    //布局
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(50);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self->moneyLabel);
        make.height.mas_equalTo(1);
    }];
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
    
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PlanHeaderView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PlanHeaderView"];
    return sectionView;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoanPlanCell *cell           = [tableView dequeueReusableCellWithIdentifier:@"LoanPlanCell"];
    cell.selectionStyle          = UITableViewCellSelectionStyleNone;
    cell.dataLabel.text          = @"2018年3月26号";
    cell.moneyLabel.text         = @"¥347794.00";
    cell.describeLabel.text      = @"含本金3500.00+利息460.00";
    cell.describeLabel.textColor = HomeColor;
    cell.describeLabel.font      = DYNormalFont;
    
    return cell;
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
