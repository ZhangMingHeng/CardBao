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



@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    NSArray *localArray; // title and icon
    NSString *app_Version;
    NSMutableString *telePhone;
}
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadLocalData];
    [self getUI];
    [self requestData];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 用于下一个页面的导航栏
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark 请求电话
-(void)requestData {
    [[RequestManager shareInstance]postWithURL:GETCUSTOMERPHONE_INTERFACE parameters:nil isLoading:NO loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
        self->telePhone = [NSMutableString stringWithFormat:@"%@",model];
        [self->listTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        
    } isCache:YES];
}
-(void) loadLocalData {
    telePhone = [[NSMutableString alloc]initWithString:@"无"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    @[@"My_aboutUS",@"关于我们"]
    localArray = @[@[@[@"My_feedback",@"意见反馈"],@[@"My_changePsw",@"修改密码"]],
                   @[@[@"My_contact",@"联系我们"]],
                   @[@[@"My_versionUpdate",@"版本更新"]]];
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
    listTableView.backgroundColor = DYGrayColor(239);
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
        make.left.equalTo(self.view).offset(37);
        make.right.equalTo(self.view).offset(-37);
        make.height.mas_equalTo(45);
        make.bottom.equalTo(self.view).offset(-DYCalculate(100));
    }];
    
}
#pragma mark TableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return localArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray = localArray[section];
    return rowArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idF];
    cell.imageView.image  = [UIImage imageNamed:localArray[indexPath.section][indexPath.row][0]];
    cell.textLabel.text   = localArray[indexPath.section][indexPath.row][1];
    
    if (indexPath.section == 0) cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else {
        UILabel *label = [UILabel new];
        label.text     = indexPath.section==1?telePhone:[NSString stringWithFormat:@"V %@",app_Version];
        [cell.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-15);
        }];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            // 意见反馈
            [self.navigationController pushViewController:[FeebackViewController new] animated:YES];
        } else if (indexPath.row == 1) {
            
            // 修改密码
            [self.navigationController pushViewController:[ChangePasswordVC new] animated:YES];
        } else if (indexPath.row == 2) {
            
            // 关于我们
            [self.navigationController pushViewController:[AboutUSVC new] animated:YES];
        }
    } else if (indexPath.section == 1) {
        // 联系我们
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telePhone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    } else {
        // 版本更新
        [Helper alertMessage:@"已经是最新版本" addToView:self.view];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 禁止下滑
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
}
#pragma mark 退出事件
-(void)outClick:(UIButton*)sender {
    // 进入登录页面
    
    // 置为初始值
    INPUTLoginState(NO);
    INPUTUserPHONE(@"");
    INPUTTOKEN(@"");
    
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
