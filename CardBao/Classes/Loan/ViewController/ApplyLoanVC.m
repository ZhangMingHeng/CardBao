//
//  ApplyLoanVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/23.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//


#import "LoanPlanVC.h"
#import "ApplyLoanVC.h"
#import "CodeAlertView.h"
#import "LoanSuccessVC.h"
#import "ApplyLoanModel.h"

@interface ApplyLoanVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *listTableView;
    NSArray *titleArray;
    NSArray *limitArray; // 期限数据
    NSArray *useArray; // 用途数据
    UIButton *selectButton; // 选中协议
    ApplyLoanModel *applyModel; // 数据
    BOOL showLimitPicker; // 是否显示期限的选择项， 默认Yes
}
@end

@implementation ApplyLoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self localData];
    [self getUI];
    
}
-(void)localData {
    titleArray = @[@[@"我的额度(元)",@"申请金额：",@"借款期限："],@[@"借款用途：",@"收款银行："],@[@"还款计划："]];
    limitArray = @[@"3个月",@"6个月",@"12个月",@"24个月",];
    useArray   = @[@"家电",@"数码",@"旅游",@"装修",@"教育",@"婚庆",@"租房",@"家居",@"医疗"];
    applyModel = [ApplyLoanModel new];
    showLimitPicker = YES;
}
#pragma mark GetUI
-(void)getUI {
    [self.navigationItem setTitle:@"借款申请"];
    // 导航栏的下划线置为空
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.rowHeight       = 50;
    listTableView.tableFooterView = [UIView new];
    listTableView.backgroundColor = DYGrayColor(239);
    [self.view addSubview:listTableView];
//    UIPickerView
    // FootView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 200)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->listTableView.tableFooterView = footView;
    });
    // 勾选框
    selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setImage:[UIImage imageNamed:@"Login_unselect"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"Login_select"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:selectButton];
    // 阅读文字
    UILabel *readLabel      = [UILabel new];
    readLabel.numberOfLines = 0;
    readLabel.text          = @"我已阅读并同意《个人消费借款》《账户委托扣款授权书》《包商银行个人征信查询授权协议》";
    [footView addSubview:readLabel];
    // 申请按钮
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.layer.cornerRadius = 20;
    applyButton.clipsToBounds      = YES;
    [applyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(applyClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:applyButton];
    
    
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
    [applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(25);
        make.right.equalTo(footView).offset(-25);
        make.height.mas_equalTo(45);
        make.top.equalTo(readLabel.mas_bottom).offset(80);
    }];
}
#pragma mark TableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [titleArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray= titleArray[section];
    return rowArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF  = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.textLabel.text   = titleArray[indexPath.section][indexPath.row];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 背景
            UIImageView *headerImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Common_backgroundHeader"]];
            headerImg.contentMode  = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:headerImg];
            // 文字
            UILabel *payLabel       = [UILabel new];
            payLabel.textColor      = [UIColor whiteColor];
            payLabel.textAlignment  = NSTextAlignmentCenter;
            payLabel.numberOfLines  = 0;
            payLabel.attributedText = [self setAttributeStringFont:[NSString stringWithFormat:@"%@\n¥ 5000",cell.textLabel.text]];
            [headerImg addSubview:payLabel];
            // 布局
            [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(cell.contentView);
                make.height.mas_equalTo(DYCalculateHeigh(99));
                make.bottom.equalTo(cell.contentView);
            }];
            [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(headerImg);
            }];
            // 隐藏分割线
            cell.separatorInset = UIEdgeInsetsMake(0, screenWidth, 0, -screenWidth);
        } else if (indexPath.row == 1) {
            UITextField *textInput = [UITextField new];
            textInput.keyboardType = UIKeyboardTypeNumberPad;
            textInput.placeholder  = @"请输入申请金额";
            textInput.text         = applyModel.creditMoney;
            textInput.delegate     = self;
            [cell.contentView addSubview:textInput];
            
            [textInput mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(40.0);
                make.top.equalTo(cell.contentView).offset(5);
                make.left.equalTo(cell.contentView).offset(110);
                make.right.equalTo(cell.contentView).offset(-15);
                make.bottom.equalTo(cell.contentView).offset(-5);
            }];
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = applyModel.creditTerm.length>0?applyModel.creditTerm:@"请选择期限";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = applyModel.loanOfUse.length>0?applyModel.loanOfUse:@"请选择用途";
        } else {
            cell.detailTextLabel.text = @"尾号(6789)招商银行";
        }
    
    } else {
        cell.detailTextLabel.text = @"查看还款计划";
        cell.selectionStyle       = UITableViewCellSelectionStyleDefault;
        cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        // 查看还款计划
        LoanPlanVC *planVC = [LoanPlanVC new];
        [self.navigationController pushViewController:planVC animated:YES];
    } else if (indexPath.section == 0&&indexPath.row == 2) {
        // 选择期限
        showLimitPicker = YES;
        [self showPickerViewWithDataList:limitArray tipLabelString:applyModel.creditTerm.length>0?applyModel.creditTerm:@"请选择期限"];
    } else if (indexPath.row == 0&&indexPath.section == 1) {
        // 选择用途
        showLimitPicker = NO;
        [self showPickerViewWithDataList:useArray tipLabelString:applyModel.loanOfUse.length>0?applyModel.loanOfUse:@"请选择用途"];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 禁止下滑
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
}
#pragma mark Apply Event
-(void)applyClick:(UIButton*) sender {
    if (!selectButton.isSelected) {
        [Helper alertMessage:@"请先阅读并同意协议" addToView:self.view];
        return;
    }
    typeof(self) weakSelf = self;
    CodeAlertView *codeView = [[CodeAlertView alloc]init];
    codeView.phoneNum       = kUserPHONE;
    codeView.submitEvent    = ^(NSInteger index, NSString *codeNum) {
        // index ' 1=验证码，9=取消，10=确定  codeNum:验证码
        
        if (index == 1) [weakSelf getCode]; // 获取验证码
        
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
    LoanSuccessVC *successVc = [LoanSuccessVC new];
    [self addChildViewController:successVc];
    self.childViewControllers[0].view.frame = self.view.bounds;
    [self.view addSubview:successVc.view];
}
-(void)selectClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
#pragma mark 显示选择控制器
- (void)showPickerViewWithDataList:(NSArray *)dataList tipLabelString:(NSString *)string{
    // Custom propery（自定义属性）
    NSDictionary *propertyDict = @{ZJPickerViewPropertySureBtnTitleColorKey     : HomeColor,
                                   ZJPickerViewPropertySelectRowTitleAttrKey    : @{NSForegroundColorAttributeName:HomeColor},
                                   ZJPickerViewPropertyTipLabelTextKey          : string,
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey   : @YES,
                                   ZJPickerViewPropertyIsScrollToSelectedRowKey : @YES,
                                   };
    [ZJPickerView zj_showWithDataList:dataList propertyDict:propertyDict completion:^(NSString *selectContent) {
        NSLog(@"ZJPickerView log tip：---> selectContent:%@", selectContent);
        
        // 赋值
        if (self->showLimitPicker) self->applyModel.creditTerm = selectContent;
        else self->applyModel.loanOfUse = selectContent;
        
        // 刷新
        [self->listTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self->showLimitPicker?2:0 inSection:self->showLimitPicker?0:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
#pragma mark textField protocol
-(void)textFieldDidEndEditing:(UITextField *)textField {
    applyModel.creditMoney = textField.text;
}
// 字体大小富文本
-(NSMutableAttributedString*)setAttributeStringFont:(NSString*)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:25];
    [attributedString addAttributes:dic range:NSMakeRange(7, string.length-7)];
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
