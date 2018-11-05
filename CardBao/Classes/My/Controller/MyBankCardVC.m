//
//  MyBankCardVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/19.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "MyBankCardVC.h"
#import "BankCardModel.h"

@interface MyBankCardVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    BankCardModel *bankModel; //卡数据
}
@end

@implementation MyBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
    [self requestData];
}
#pragma mark 请求数据
-(void)requestData {
    
    [[RequestManager shareInstance]postWithURL:GETBANKCARDINFO_INTERFACE parameters:nil isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        if ([Helper justDictionary:model]) {
            self->bankModel = [BankCardModel yy_modelWithJSON:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI线程
                [self->listTableView reloadData];
                
            });
        } else {
            [Helper alertMessage:@"还没有绑定银行卡" addToView:self.view];
        }
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:NO];
}
#pragma mark UI
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
    
    // 银行名称
    UILabel *bankName  = [UILabel new];
    bankName.text      = [self stringToInteger:bankModel.bankId];
    bankName.textColor = [UIColor whiteColor];
    [framework addSubview:bankName];
    // 银行卡号
    UILabel *bankNum  = [UILabel new];
    bankNum.text      = bankModel.bankCardNo;
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
-(NSString *)stringToInteger:(NSInteger) num {
    
    NSArray *stringArray = @[@"储蓄银行",@"工商银行",@"农业银行",@"中国银行",@"建设银行",@"交通银行",@"中信银行",@"光大银行",@"广发银行",@"招商银行",@"兴业银行",@"浦发银行",@"上海银行",@"宁波银行",@"平安银行",@"兰州银行",@"包商银行"];
    NSMutableString *string = [NSMutableString new];
    
    for (int i = 0; i<stringArray.count; i++) {
        if (num-1 == i) {
            string = stringArray[i];
        }
    }
    return string;
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
