//
//  RepaymentPlanVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RepaymentPlanVC.h"
#import "RepaymentListCell.h"

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
    [listTableView registerClass:[RepaymentListCell class] forCellReuseIdentifier:@"RepaymentListCell"];
    listTableView.dataSource         = self;
    listTableView.delegate           = self;
    listTableView.estimatedRowHeight = 200;
    listTableView.tableFooterView    = [UIView new];
    listTableView.backgroundColor    = DYGrayColor(239.0);
    [self.view addSubview:listTableView];
    
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
}
#pragma mark TableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepaymentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepaymentListCell"];
    cell.selectionStyle           = UITableViewCellSelectionStyleNone;
    cell.moneyLabel.text          = @"¥ 500.00";
    cell.monthLabel.text          = @"应还款日期：2018-09-09"; //254,116,117（逾期未还款）black（已还款）
    cell.dateLabel.attributedText = [self setAttributedStringColor:@"还款状态：未还款" color:DYColor(0.0, 145.0, 234)];
    cell.codeLabel.text           = @"第一期";
    cell.iconImgView.image        = [UIImage imageNamed:@"Repayment_icon"];
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
// 颜色
-(NSMutableAttributedString*)setAttributedStringColor:(NSString*) string color:(UIColor*) color {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(5, string.length-5)];
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
