//
//  BingBankCardVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "BasicInfoVC.h"
#import "BingBankCardVC.h"
#import "CreditExtensionMainVC.h"
#define CodeNumer 120

@interface BingBankCardVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titleArray;
    UITableView *listTableView;
    NSArray *placeholder;
    UIButton *codeButton;
}
@property (nonatomic, assign) int countDown;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation BingBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self localData];
    [self getUI];
}
-(void)localData {
    titleArray = @[@"真实姓名",@"身份证号",@"银行卡号",@"开户银行",@"预留手机号",@"验证码"];
    placeholder = @[@"请输入姓名",@"请输入身份证号",@"请输入银行卡号",@"请选择开户行",@"请输入预留手机号",@"请输入验证码"];
}
#pragma mark getUI
-(void)getUI {
    CreditExtensionMainVC *viewC = self.navigationController.viewControllers.lastObject;
    viewC.title = @"绑定银行卡";
    viewC.stepLabel.text = @"2/5";
    
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.rowHeight       = 50;
    listTableView.tableFooterView = [UIView new];
    [self.view addSubview:listTableView];
    
    // FootView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 160)];
    // 上一步按钮
    UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lastButton.layer.cornerRadius = 20;
    lastButton.clipsToBounds      = YES;
    [lastButton setTitle:@"上一步" forState:UIControlStateNormal];
    [lastButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [lastButton addTarget:self action:@selector(lastClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:lastButton];
    // 下一步按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 20;
    nextButton.clipsToBounds      = YES;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
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
    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.equalTo(footView).offset(50);
        make.left.equalTo(footView).offset(25);
        make.right.equalTo(footView).offset(-25);
    }];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(footView).offset(25);
        make.right.equalTo(footView).offset(-25);
        make.top.equalTo(lastButton.mas_bottom).offset(20);
    }];
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF  = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.textLabel.text   = titleArray[indexPath.row];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    // 输入框
    UITextField *input = [UITextField new];
    input.placeholder  = placeholder[indexPath.row];
    [cell.contentView addSubview:input];
    if (indexPath.row == 5) {
        // 获取验证码
        codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeButton addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        [codeButton setBackgroundImage:[Helper imageWithColor:HomeColor withButonWidth:92 withButtonHeight:30] forState:UIControlStateNormal];
        codeButton.layer.cornerRadius = 5;
        codeButton.clipsToBounds      = YES;
        codeButton.titleLabel.font    = DYNormalFont;
        [cell.contentView addSubview:codeButton];
        
        
        // 布局
        [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-20);
            make.width.mas_equalTo(92);
        }];
        
        [input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(150);
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(self->codeButton.mas_left).offset(-5);
        }];
    } else {
        // 布局
        [input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(150);
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-20);
            
        }];
    }
    
    // 前两行不可编辑
    if (indexPath.row == 0||indexPath.row == 1) input.userInteractionEnabled = NO;
    return  cell;
}
#pragma mark 上一步、下一步
-(void)lastClick:(UIButton*)sender {
    [self.view removeFromSuperview];
    CreditExtensionMainVC *viewC = self.navigationController.viewControllers.lastObject;
    viewC.title = @"身份认证";
    viewC.stepLabel.text = @"1/5";
}
-(void)nextClick:(UIButton*)sender {
    BasicInfoVC *basicVC = [BasicInfoVC new];
    [self addChildViewController:basicVC];
    self.childViewControllers[0].view.frame = self.view.bounds;
    [self.view addSubview:basicVC.view];
 
}
#pragma mark 获取验证码
-(void)getCodeClick:(UIButton*)sender {
    //    if (phoneText.text.length == 0) {
    //        [Helper alertMessage:@"手机号码不能为空" addToView:self.view];
    //        return;
    //    }
    //    if (![Helper justMobile:phoneText.text]) {
    //        [Helper alertMessage:@"请输入正确手机号码" addToView:self.view];
    //        return;
    //    }
    _countDown = CodeNumer;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}
-(void)handleTimer{
    UIButton *button = codeButton;
    if (_countDown>0) {
        [button setEnabled:NO];
        [button setTitle:[NSString stringWithFormat:@"%d秒",self->_countDown] forState:UIControlStateNormal];
    } else {
        _countDown = CodeNumer;
        [self.timer invalidate];
        [button setEnabled:YES];
        [button setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
    }
    _countDown = _countDown-1;
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
