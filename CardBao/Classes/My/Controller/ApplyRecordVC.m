//
//  ApplyRecordVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/19.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "ApplyRecordVC.h"
#import "ApplyRecordModel.h"
#import "RepaymentListCell.h"

@interface ApplyRecordVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    NSMutableArray *sourceArray; // 数据
}
@end

@implementation ApplyRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
    sourceArray = [NSMutableArray new];
    [self requestData:YES];
}
#pragma mark 请求借款申请记录
-(void)requestData:(BOOL) loading {

    [[RequestManager shareInstance]postWithURL:GETLOANRECORD_INTERFACE parameters:nil isLoading:loading loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        [self->sourceArray removeAllObjects];
        NSArray *array = model;
        if ([Helper justArray:array]) {
            for (NSDictionary *dic in array) {
                ApplyRecordModel *recordModel = [ApplyRecordModel yy_modelWithJSON:dic];
                [self->sourceArray addObject:recordModel];
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"还没有去借款咯" addToView:self.view];
            });
        }
        [self->listTableView reloadData];
        [self->listTableView.mj_header endRefreshing];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->listTableView.mj_header endRefreshing];
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [self->listTableView.mj_header endRefreshing];
    } isCache:YES];
}
#pragma mark GetUI
-(void)getUI {
    self.title = @"申请记录";
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
                [self requestData:NO];
    }];
    
}
#pragma mark TableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sourceArray.count;
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
    
    RepaymentListCell *cell    = [tableView dequeueReusableCellWithIdentifier:@"RepaymentListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ApplyRecordModel *model = sourceArray[indexPath.section];
    // 赋值
    cell.moneyLabel.attributedText  = [self setAttributedStringColor:[NSString stringWithFormat:@"申请金额(元)\n¥ %@",model.loanAmount] range:NSMakeRange(0, 7)];
    cell.monthLabel.text            = [NSString stringWithFormat:@"借款期限：%@个月",model.loanLimit];
    cell.dateLabel.text             = [NSString stringWithFormat:@"申请日期：%@",model.loanRecordTime];
    cell.codeLabel.text             = [Helper isNullToString:model.kaobaoId returnString:@""];
    cell.statusLabbel.attributedText = [self setAttributedStringColor:[NSString stringWithFormat:@"申请状态：%@",model.status] color:DYColor(254.0, 116.0, 117)];
    
    return cell;
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
