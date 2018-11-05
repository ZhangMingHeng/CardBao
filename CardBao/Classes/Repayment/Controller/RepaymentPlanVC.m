//
//  RepaymentPlanVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RepaymentModel.h"
#import "RepaymentPlanVC.h"
#import "RepaymentListCell.h"

@interface RepaymentPlanVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    NSMutableArray *sourceArray;
}
@end

@implementation RepaymentPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
    [self requestData];
}
-(void)requestData {

    sourceArray = [NSMutableArray new];
    [[RequestManager shareInstance]postWithURL:GETREPAYMENTPLAN_INTERFACE parameters:@{@"id":[NSNumber numberWithInteger:self.iId]} isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        if ([Helper justDictionary:model]) {
            NSArray *list = model[@"repayDetailInfoVOList"];
            if ([Helper justArray:list]) {
                for (NSDictionary *dic in list) {
                    RepaymentPlanModel *planModel = [RepaymentPlanModel yy_modelWithJSON:dic];
                    [self->sourceArray addObject:planModel];
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [Helper alertMessage:@"没有还款计划数据" addToView:self.view];
            });
        }
        [self->listTableView reloadData];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
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
    return sourceArray.count;
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
    RepaymentPlanModel *planModel = sourceArray[indexPath.section];
    cell.moneyLabel.text          = [NSString stringWithFormat:@"¥ %@元",planModel.shouldMoney];
    cell.monthLabel.text          = [NSString stringWithFormat:@"应还款日期：%@",planModel.shouldDate]; //254,116,117（逾期未还款）black（已还款）
    cell.dateLabel.attributedText = [self setAttributedStringColor:[NSString stringWithFormat:@"还款状态：%@",planModel.status] color:DYColor(0.0, 145.0, 234)];
    cell.codeLabel.text           = [NSString stringWithFormat:@"第%@期",planModel.currentTerm];
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
