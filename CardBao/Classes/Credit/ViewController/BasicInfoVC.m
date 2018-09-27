//
//  BasicInfoVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//


#import "BasicInfoVC.h"
#import "TabIndexView.h"
#import "ZHIMACreditVC.h"
#import "CreditExtensionMainVC.h"

@interface BasicInfoVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *titleArrayOther;
    NSMutableArray *placeholderOther;
    NSMutableArray *titleArray;
    NSMutableArray *placeholder;
    TabIndexView *tabView;
}
@end

@implementation BasicInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self localData];
    [self getUI];
}
-(void)localData {
    titleArray  = [NSMutableArray arrayWithObjects:@"居住地址",@"详细地址",@"学历信息",@"居住情况",@"婚姻状况",@"联系人1",@"联系人2", nil];
    placeholder = [NSMutableArray arrayWithObjects:@"请选择省、市、显",@"请输入详情地址",@"请选择学历信息",@"请选择居住情况",@"请选择婚姻状态",@"请选择联系人",@"请选择联系人",nil];
}
#pragma mark getUI
-(void)getUI {
    
    if (NSBaseViewPushTypeDefault == _baseViewPushType) {
        
        CreditExtensionMainVC *viewC = self.navigationController.viewControllers.lastObject;
        viewC.title = @"基本信息";
        viewC.stepLabel.text = @"3/5";
    } else {
        self.title = @"基本信息";
    }
    
    
    // 选项卡
    tabView = [TabIndexView new];
    [self.view addSubview:tabView];
    
    for (int i = 0; i<2; i++) {
        // tableView // tag 3->个人信息， 4->单位信息
        UITableView *listTableView    = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        listTableView.dataSource      = self;
        listTableView.delegate        = self;
        listTableView.rowHeight       = 50;
        listTableView.tableFooterView = [UIView new];
        listTableView.tag             = i+3;
        listTableView.hidden          = i==0?NO:YES;
        [self.view addSubview:listTableView];
        
        // FootView
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, i==0?100:160)];
        // 上一步按钮
        UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        lastButton.layer.cornerRadius = 20;
        lastButton.clipsToBounds      = YES;
        lastButton.hidden             = i==0?YES:NO;
        [lastButton setTitle:@"上一步" forState:UIControlStateNormal];
        [lastButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
        [lastButton addTarget:self action:@selector(lastClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:lastButton];
        // 下一步按钮
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.layer.cornerRadius = 20;
        nextButton.clipsToBounds      = YES;
        nextButton.tag                = 5+i;
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:nextButton];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            listTableView.tableFooterView = footView;
        });
        
        // 布局
        [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(100, 0, 0, 0));
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
            make.bottom.equalTo(footView).offset(-5);
        }];
        
    }
    
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UITableView *listTableView = [self.view viewWithTag:4];
    if (tableView == listTableView) return titleArrayOther.count;
    else return titleArray.count;
    
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *listTableView = [self.view viewWithTag:4];
    
    static NSString *idF  = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if (tableView == listTableView) {
        cell.textLabel.text       = titleArrayOther[indexPath.row];
        cell.detailTextLabel.text = placeholderOther[indexPath.row];
    } else {
        cell.textLabel.text       = titleArray[indexPath.row];
        cell.detailTextLabel.text = placeholder[indexPath.row];
    }
    
    return cell;
}

-(void)nextClick:(UIButton*)sender {
    if (sender.tag == 5) {
        // 切换到单位信息
        tabView.index = 1;
        UITableView *listTableView = [self.view viewWithTag:4];
        listTableView.hidden = NO;
        titleArrayOther  = [NSMutableArray arrayWithArray:@[@"单位地址",@"详细地址",@"单位名称",@"单位电话",@"所属行业",@"单位职能"]];
        placeholderOther = [NSMutableArray arrayWithArray:@[@"请选择省、市、显",@"请输入详细地址",@"请输入单位名称",@"请输入单位电话",@"请选择所属行业",@"请选择单位职能"]];
        [listTableView reloadData];
    } else {
        
        if (NSBaseViewPushTypeDefault != _baseViewPushType) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        // 跳转 芝麻信用页面
        ZHIMACreditVC *zhimaVC = [ZHIMACreditVC new];
        [self addChildViewController: zhimaVC];
        self.childViewControllers[0].view.frame = self.view.bounds;
        [self.view addSubview:zhimaVC.view];
    }
    
}
-(void)lastClick:(UIButton*)sender {
    tabView.index = 0;
    UITableView *listTableView = [self.view viewWithTag:4];
    listTableView.hidden = YES;
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
