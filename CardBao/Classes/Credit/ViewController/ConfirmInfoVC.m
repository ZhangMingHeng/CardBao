//
//  ConfirmInfoVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/25.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "BasicInfoVC.h"
#import "CodeAlertView.h"
#import "ConfirmInfoVC.h"
#import "CreditSuccessVC.h"
#import "ConfirmInfoOneCell.h"
#import "ConfirmInfoTwoCell.h"
#import "CreditExtensionMainVC.h"

@interface ConfirmInfoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    UIButton *selectButton;
    CreditExtensionMainVC *mainVC;
}
@end

@implementation ConfirmInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getUI];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Helper resignTheFirstResponder];
}
#pragma mark getUI
-(void)getUI {
    mainVC = self.navigationController.viewControllers.lastObject;
    mainVC.title                  = @"信息确认";
    mainVC.stepLabel.text         = @"";
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource         = self;
    listTableView.delegate           = self;
    listTableView.estimatedRowHeight = 200;
    listTableView.tableFooterView    = [UIView new];
    [listTableView registerClass:[ConfirmInfoOneCell class] forCellReuseIdentifier:@"ConfirmInfoOneCell"];
    [listTableView registerClass:[ConfirmInfoTwoCell class] forCellReuseIdentifier:@"ConfirmInfoTwoCell"];
    [self.view addSubview:listTableView];
    
    // FootView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 230)];
    // 勾选框
    selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setImage:[UIImage imageNamed:@"Login_unselect"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"Login_select"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:selectButton];
    // 阅读文字
    UILabel *readLabel      = [UILabel new];
    readLabel.numberOfLines = 0;
    readLabel.text          = @"我已阅读并同意《包商银行个人信息查询协议》《个人信息使用及第三方机构数据授权查询书》";
    [footView addSubview:readLabel];
    //  提交
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 20;
    nextButton.clipsToBounds      = YES;
    [nextButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextButton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->listTableView.tableFooterView = footView;
    });
    
    // 布局
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(12);
        make.top.equalTo(footView).offset(20);
        make.width.height.mas_equalTo(20);
    }];
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->selectButton.mas_right);
        make.top.equalTo(footView).offset(10);
        make.right.equalTo(footView).offset(-15);
    }];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(footView).offset(37);
        make.right.equalTo(footView).offset(-37);
        make.bottom.equalTo(footView.mas_bottom).offset(-70);
    }];
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *sectionView =  [UIView new];
    sectionView.backgroundColor = DYGrayColor(243);
    return sectionView;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ConfirmInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmInfoOneCell"];
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text      = @"理事99999";
        cell.bankLabel.text      = @"中国银行中国银行中国银行中国银行中国银行中国银行中国银行";
        cell.bankNumLabel.text   = @"6222222222222222222222222222222222";
        
        return cell;
    } else {
        ConfirmInfoTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmInfoTwoCell"];
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        [cell titleArray:@[@"居住信息",@"详细信息",@"学历信息",@"单位地址"] withValueArray:@[@"wrrere",@"fd从 v 款女款 v 时刻 v 漱口水dddd",@"211",@"借款节省空间上看到发生的发生肯定会发生看精神科"]];
        [cell.changeInfo addTarget:self action:@selector(changeInfoClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

}
-(void)nextClick:(UIButton*)sender {
    if (!selectButton.isSelected) {
        [Helper alertMessage:@"请先阅读并同意协议" addToView:self.view];
        return;
    }
    
    typeof(self) weakSelf = self;
    CodeAlertView *codeView = [[CodeAlertView alloc]init];
    codeView.phoneNum       = @"13612345678";
    codeView.submitEvent    = ^(NSInteger index, NSString *codeNum) {
        // index ' 1=验证码，9=取消，10=确定  codeNum:验证码
        
        if (index == 1) [weakSelf getCode];
        
        
        if (index == 10&&codeNum.length == 0) {
            [Helper alertMessage:@"请输入验证码" addToView:self.view];
            return;
        }
        
        if (index == 10&&codeNum.length > 0) [weakSelf confirmApplyLoan];
        
    };
    [self.view addSubview:codeView];
}
#pragma mark 获取验证码
-(void)getCode {
    
}
#pragma mark 确认申请
-(void)confirmApplyLoan {
//
    [mainVC.navigationController pushViewController:[CreditSuccessVC new] animated:YES];
    
}
#pragma mark 修改信息
-(void)changeInfoClick:(UIButton*)sender {
    BasicInfoVC *infoVC     = [BasicInfoVC new];
    infoVC.baseViewPushType = NSBaseViewPushTypeChangeInfo;
    [mainVC.navigationController pushViewController:infoVC animated:YES];
}
-(void)selectClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
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
