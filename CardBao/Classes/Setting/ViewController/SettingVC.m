//
//  SettingVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/19.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "LoginVC.h"
#import "SettingVC.h"
#import "AboutUSVC.h"
#import "ChangePasswordVC.h"
#import "FeebackViewController.h"

#define Telephone @"400-000-8686"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    NSArray *localArray; // title and icon
    NSString *app_Version;
}
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadLocalData];
    [self getUI];
    
}
-(void) loadLocalData {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    localArray = @[@[@"My_feedback",@"意见反馈"],
                   @[@"My_changePsw",@"修改密码"],
                   @[@"My_aboutUS",@"关于我们"],
                   @[@"My_contact",@"联系我们"],
                   @[@"My_versionUpdate",@"版本更新"]];
}
-(void)getUI {
    [self.navigationItem setTitle:@"设置"];
    //  viewcontroller 不会被tabbar遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.scrollEnabled   = NO;
    listTableView.tableFooterView = [UIView new];
    [self.view addSubview:listTableView];
    
    //退出按钮
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    outButton.layer.cornerRadius = 20.0;
    outButton.clipsToBounds      = YES;
    [outButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [outButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [outButton addTarget:self action:@selector(outClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outButton];
    
    //布局
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    [outButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view).offset(-DYCalculate(100));
    }];
    
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return localArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idF];
    cell.imageView.image  = [UIImage imageNamed:localArray[indexPath.row][0]];
    cell.textLabel.text   = localArray[indexPath.row][1];
    
    if (indexPath.row < 3) cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else {
        UILabel *label = [UILabel new];
        label.text     = indexPath.row==3?Telephone:[NSString stringWithFormat:@"V %@",app_Version];
        [cell.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-15);
        }];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        // 意见反馈
        [self.navigationController pushViewController:[FeebackViewController new] animated:YES];
    } else if (indexPath.row == 1) {
        
        // 修改密码
        [self.navigationController pushViewController:[ChangePasswordVC new] animated:YES];
    } else if (indexPath.row == 2) {
        
        // 关于我们
        [self.navigationController pushViewController:[AboutUSVC new] animated:YES];
    } else if (indexPath.row == 3) {
        
        // 联系我们
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",Telephone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    } else {
        
        // 版本更新
        [Helper alertMessage:@"已经是最新版本" addToView:self.view];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 禁止上滑
    CGPoint offset = scrollView.contentOffset;
    if (offset.y > 0) {
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
}
#pragma mark 退出事件
-(void)outClick:(UIButton*)sender {
    // 进入登录页面
    INPUTLoginState(NO);
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.navigationVC = [[DYNavigationController alloc]initWithRootViewController:[LoginVC new]];
    app.window.rootViewController = app.navigationVC;
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
