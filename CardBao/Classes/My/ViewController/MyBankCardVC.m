//
//  MyBankCardVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/19.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "MyBankCardVC.h"

@interface MyBankCardVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
}
@end

@implementation MyBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
-(void)getUI {
    self.title = @"我的银行卡";
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.rowHeight       = 130.0;
    listTableView.tableFooterView = [UIView new];
    listTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:listTableView];
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    // 框架
    UIImageView *framework       = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"My_BCBackground"]];
    framework.contentMode        = UIViewContentModeScaleAspectFill;
    framework.clipsToBounds      = YES;
    framework.layer.cornerRadius = 10.0;
    [cell.contentView addSubview:framework];

    
//    // 框架的渐变色彩
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors           = @[(__bridge id)DYColor(156, 152, 240).CGColor,(__bridge id)DYColor(62, 57, 198).CGColor];
//    gradientLayer.startPoint       = CGPointMake(0, 0); // 方向.起点
//    gradientLayer.endPoint         = CGPointMake(0, 1.0); // 方向.止点
////    gradientLayer.locations        = @[@0,@1];
//    gradientLayer.frame            = CGRectMake(0, 0, screenWidth-30, 150);
//    [framework.layer addSublayer:gradientLayer];
    
    // 银行名称
    UILabel *bankName  = [UILabel new];
    bankName.text      = @"招商银行";
    bankName.textColor = [UIColor whiteColor];
    [framework addSubview:bankName];
    // 银行卡号
    UILabel *bankNum  = [UILabel new];
    bankNum.text      = @"1234567890";
    bankNum.textColor = [UIColor whiteColor];
    [framework addSubview:bankNum];
    
    //布局
    [framework mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView);
        make.width.mas_equalTo(screenWidth-30);
        make.top.equalTo(cell.contentView).offset(10);
        make.height.mas_equalTo(116);
    }];
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(framework).offset(30);
        make.left.equalTo(framework).offset(20);
        make.right.equalTo(framework).offset(-20);
    }];
    [bankNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankName.mas_bottom).offset(26);
        make.left.equalTo(framework).offset(20);
        make.right.equalTo(framework).offset(-20);
    }];
    
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
