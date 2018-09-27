//
//  RepaymentPlanVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RepaymentPlanVC.h"

@interface RepaymentPlanVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
}
@end

@implementation RepaymentPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
#pragma mark GETUI
-(void)getUI {
    self.title = @"还款计划";
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//    [listTableView registerClass:[RepaymentDetailsCell class] forCellReuseIdentifier:@"RepaymentDetailsCell"];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.rowHeight       = 50;
    listTableView.tableFooterView = [UIView new];
    [self.view addSubview:listTableView];
    
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
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
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    [self initCellUI:headerView withData:@[@"应还款日期",@"应还款额",@"状态"]];
    
    return headerView;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idf = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idf];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    [self initCellUI:cell withData:@[@"2018年3月28号",@"¥5454.00",@"已还"]];
    return cell;
}
-(void)initCellUI:(id)obj withData:(NSArray*)array {
    UILabel *dateLable  = [UILabel new];
    UILabel *moneyLable = [UILabel new];
    UILabel *stateLabel = [UILabel new];
    dateLable.text      = array[0];
    moneyLable.text     = array[1];
    stateLabel.text     = array[2];
    [obj addSubview:dateLable];
    [obj addSubview:moneyLable];
    [obj addSubview:stateLabel];
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = DYGrayColor(243);
    [obj addSubview:lineLabel];
    
    // 布局
    [dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(obj).offset(15);
        make.centerY.equalTo(obj);
    }];
    [moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(obj).centerOffset(CGPointMake(20, 0));
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(obj);
        make.right.equalTo(obj).offset(-15);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(obj);
        make.height.mas_equalTo(1.0);
        make.bottom.equalTo(obj);
    }];
    
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
