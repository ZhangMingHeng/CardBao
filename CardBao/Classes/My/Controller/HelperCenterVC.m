//
//  HelperCenterVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/19.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "HelperCenterVC.h"
#import "FoldingTableView.h"

@interface HelperCenterVC ()<FoldingTableViewDelegate>
{
    FoldingTableView *listTableView;
    NSArray *locaSection;
    NSArray *contentArray;
}
@end

@implementation HelperCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self localData];
    [self getUI];
}
#pragma mark 本地数据
-(void)localData {
    locaSection = @[@"在卡宝申请借款需要什么条件?",@"借款是否有前置收费?",@"额度多少，申请额度需要多久?",@"综合评分不足是什么意思?",@"借款后多久可以放款?",@"如果出现逾期有什么影响?"];
    contentArray = @[@"1、您有稳定的职业和收入来源，具备偿还能力；\n2、您的信用良好，无不良信贷记录。",@"借款无前期费用，借款多少到账多少。",@"借款根据您的资料完善程度，一般耗时1-30分钟，额度范围1000-50000元，具体的审核结果根据您的资料得出。",@"系统根据您提供的资料，通过大数据分析，如果不符合借款条件，被拒绝后会限制90天后才能重新发起授信流程。",@"用户提交借款审核后，一般当天可以放款到绑定的银行卡中",@"逾期后会产生罚息，并且逾期时间长会上传到征信。"];
}
#pragma mark getUI
-(void)getUI {
    self.title = @"帮助中心";
    
    //  foldingTableView
    listTableView = [[FoldingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.showsVerticalScrollIndicator = NO;
    listTableView.tableFooterView              = [UIView new];
    listTableView.foldingDelegate              = self;
    listTableView.separatorInset               = UIEdgeInsetsZero;
    listTableView.backgroundColor              = DYGrayColor(237);
    listTableView.estimatedRowHeight           = 200;
    [self.view addSubview:listTableView];
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
#pragma mark - FoldingTableViewDelegate / required（必须实现的代理）
-(FoldingSectionHeaderArrowPosition)perferedArrowPositionForFoldingTableView:(FoldingTableView *)tableView {
    // 箭头的位置
    return FoldingSectionHeaderArrowPositionRight;
}
-(NSInteger)numberOfSectionForFoldingTableView:(FoldingTableView *)tableView {
    // 区数
    return locaSection.count;
}
-(NSInteger)foldingTableView:(FoldingTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 行数
    return 1;
}
-(CGFloat)foldingTableView:(FoldingTableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  10.0;
}
-(CGFloat)foldingTableView:(FoldingTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 行高
    return UITableViewAutomaticDimension;
}
-(CGFloat)foldingTableView:(FoldingTableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // header 高
    return 49;
}
-(NSString *)foldingTableView:(FoldingTableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // header 文字
    return locaSection[section];
}
-(UITableViewCell*)foldingTableView:(FoldingTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF  = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    cell.textLabel.text   = contentArray[indexPath.section];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font          = DYNormalFont;
    return  cell;
}
- (void )foldingTableView:(FoldingTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击cell
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
