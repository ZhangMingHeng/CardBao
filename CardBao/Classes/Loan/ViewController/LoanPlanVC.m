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
    
    // 背景
    UIImageView *headerImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Common_backgroundHeader"]];
    headerImg.contentMode  = UIViewContentModeScaleAspectFill;
    [self.view addSubview:headerImg];
    // 文字
    UILabel *payLabel       = [UILabel new];
    payLabel.textColor      = [UIColor whiteColor];
    payLabel.textAlignment  = NSTextAlignmentCenter;
    payLabel.numberOfLines  = 0;
    payLabel.attributedText = [self setAttributeStringFont:@"还款总额(元)\n¥ 50000"];
    [headerImg addSubview:payLabel];
    
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
    [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(DYCalculateHeigh(99));
    }];
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerImg);
    }];
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(DYCalculateHeigh(99), 0, 0, 0));
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
    cell.moneyLabel.textColor    = DYColor(42.0, 113.0, 241.0);
    cell.describeLabel.text      = @"含本金3500.00+利息460.00";
    cell.describeLabel.textColor = DYGrayColor(161.0);
    cell.describeLabel.font      = DYNormalFont;
    
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 禁止下滑
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
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
