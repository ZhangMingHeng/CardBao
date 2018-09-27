//
//  MyVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/18.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "MyVC.h"
#import "SettingVC.h"
#import "RepaymentVC.h"
#import "MyBankCardVC.h"
#import "ApplyRecordVC.h"
#import "HelperCenterVC.h"

@interface MyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    NSArray *localArray; // title
    NSArray *ViewCArray; // 视图控制器
    NSArray *iconArray; // 图标
}
@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getLocalData];
    [self getUI];
}
-(void)getLocalData {
    localArray = @[@"",@"",@"申请记录",@"我要还款",@"我的银行卡",@"帮助中心",@"设置"];
    ViewCArray = @[@"",@"",[ApplyRecordVC new],[RepaymentVC new],[MyBankCardVC new],[HelperCenterVC new],[SettingVC new],];
    iconArray = @[@"",@"",@"My_record",@"My_repayment",@"My_bankCard",@"My_help",@"My_setting"];
}
#pragma mark GetUI
-(void)getUI {
    [self.navigationItem setTitle:@"卡宝"];
    //  viewcontroller 不会被tabbar遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.tableFooterView = [UIView new];
    [self.view addSubview:listTableView];
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return 100;
    else if (indexPath.row == 1) return 60;
    else return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idF];
    if (indexPath.row == 0){
        // 头像
        UIImageView *headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"My_head"]];
        [cell.contentView addSubview:headImg];
        // 手机
        UILabel *phoneLabel      = [UILabel new];
        phoneLabel.text          =[NSString stringWithFormat:@"%@\n您好！",[self reviewPhone:kUserPHONE]];
        phoneLabel.numberOfLines = 2;
        [cell.contentView addSubview:phoneLabel];
        
        [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.width.height.mas_equalTo(60);
            make.left.equalTo(cell.contentView).offset(20);
        }];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImg.mas_right).offset(10);
            make.right.equalTo(cell.contentView).offset(-10);
            make.centerY.equalTo(cell.contentView);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.row == 1){
        for (int i=0; i<2; i++) {
            UILabel *textLabel      = [UILabel new];
            textLabel.numberOfLines = 2;
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.text          = i==0?@"本月待还\n¥0.00":@"待还总额\n¥0.00";
            [cell.contentView addSubview:textLabel];
            // 竖线
            UILabel *lineLabel        = [UILabel new];
            lineLabel.backgroundColor = DYGrayColor(231);
            [cell.contentView addSubview:lineLabel];
            
            //布局
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(15+i*screenWidth/2.0);
                make.right.equalTo(cell.contentView).offset(-15-screenWidth/2.0+i*screenWidth/2.0);
            }];
            [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(1.0);
                make.center.equalTo(cell.contentView);
                make.top.equalTo(cell.contentView).offset(5);
                make.bottom.equalTo(cell.contentView).offset(-5);
            }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        // 图标
        cell.imageView.image = [UIImage imageNamed:iconArray[indexPath.row]];
        // 文字
        cell.textLabel.text  = localArray[indexPath.row];
        // 样式
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 1) {
        //2 申请记录//3 我要还款//4 我的银行卡//5 帮助中心//6 设置
        [self.navigationController pushViewController:ViewCArray[indexPath.row] animated:YES];
    }
}
-(NSString*)reviewPhone:(NSString *)text {
    if (![Helper justMobile:text]) {
        return text;
    }
    return [text stringByReplacingOccurrencesOfString:[text substringWithRange:NSMakeRange(3, 4)] withString:@"****"];
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
