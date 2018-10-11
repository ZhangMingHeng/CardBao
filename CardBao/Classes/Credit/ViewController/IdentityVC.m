//
//  IdentityVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "IdentityVC.h"
#import "BingBankCardVC.h"
#import "CreditExtensionMainVC.h"
@interface IdentityVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    NSArray *titleArray;
    NSMutableArray <UIImage *> *photoArray;
}
@end

@implementation IdentityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self localData];
    [self getUI];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
-(void)localData {
    photoArray = [NSMutableArray arrayWithObjects:[UIImage new],[UIImage new],nil];
    titleArray = @[@"        请确认姓名、身份证信息是否正确",@"姓名",@"身份证号"];
}
#pragma mark getUI
-(void)getUI {
    
    CreditExtensionMainVC *viewC = self.navigationController.viewControllers.lastObject;
    viewC.title = @"身份认证";
    viewC.stepLabel.text = @"1/5";
    
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.rowHeight       = 50;
    listTableView.tableFooterView = [UIView new];
    [self.view addSubview:listTableView];
    
    // FootView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 100)];
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
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(37);
        make.right.equalTo(footView).offset(-37);
        make.height.mas_equalTo(45);
        make.top.equalTo(footView).offset(20);
    }];
}
#pragma mark TableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 400;
    }
    return 50;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF  = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idF];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0 ){
        CGFloat buttonW = 249;
        CGFloat buttonH = 154;
//        NSArray *textArray = @[@"身份证正面",@"身份证反面",@"手持身份证",@"本人头像照"];

        // 生成附件
        NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
        textAttach.image = [UIImage imageNamed:@"Credit_tips"];
        textAttach.bounds = CGRectMake(20, -3, 15, 15);
        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:textAttach];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:titleArray[indexPath.row]];
        [attri insertAttributedString:imgAtt atIndex:0];
        
        UILabel *tipsLabel        = [UILabel new];
        tipsLabel.attributedText  = attri;
        tipsLabel.textColor       = [UIColor lightGrayColor];
        tipsLabel.font            = [UIFont systemFontOfSize:12.0];
        tipsLabel.backgroundColor = DYGrayColor(239.0);
        [cell.contentView addSubview:tipsLabel];
        
        for (int i = 0; i<2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag       = 10+i;
            //            [button setTitle:textArray[i] forState:UIControlStateNormal];
            //            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:i==0?@"Credit_ident":@"Credit_ident1"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectImgClick:) forControlEvents:UIControlEventTouchUpInside];
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.contentView);
                make.top.equalTo(tipsLabel.mas_bottom).offset(20+i*(buttonH+15));
                make.width.mas_equalTo(buttonW);
                make.height.mas_equalTo(buttonH);
            }];
        }
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(cell.contentView);
            make.height.mas_equalTo(30.0);
        }];
    } else {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text     = titleArray[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(20);
            make.centerY.equalTo(cell.contentView);
        }];
        UITextField *input = [UITextField new];
        input.placeholder  = indexPath.row == 1?@"请输入姓名":@"请输入身份证号";
        [cell.contentView addSubview:input];
        
        
        [input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(100);
            make.right.equalTo(cell.contentView).offset(-20);
            make.centerY.equalTo(cell.contentView);
        }];
    }
    return  cell;
}
-(void)nextClick:(UIButton*)sender {
    BingBankCardVC *bingVC = [BingBankCardVC new];
    [self addChildViewController:bingVC];
    self.childViewControllers[0].view.frame = self.view.bounds;
    [self.view addSubview:bingVC.view];
    
}
-(void)selectImgClick:(UIButton*)sender {
    
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount   = 1;
    ac.configuration.allowSelectVideo = NO;
    ac.configuration.showSelectedMask = YES;
    ac.configuration.allowRecordVideo = NO;
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        
        // 上传文件类型
        if (sender.tag == 10) INPUTIMAGETYPE(@"01");
        else INPUTIMAGETYPE(@"02");
        
        // 上传文件请求
        [[RequestManager shareInstance]upLoadPostWithUR:FILEUPLOAD_INTERFACE parameters:@[images[0]] andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
            if ([Helper justDictionary:model]) {
                if ([model[@"code"] integerValue] == 0) {
                    [sender setImage:images[0] forState:UIControlStateNormal];
                    [self->photoArray replaceObjectAtIndex:11-sender.tag withObject:images[0]];
                    sender.imageView.contentMode = UIViewContentModeScaleAspectFill;
                } else {
                    [Helper alertMessage:model[@"msg"] addToView:self.view];
                }
            } else {
                [Helper alertMessage:@"上传失败，解析错误" addToView:self.view];
            }
        } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
            [Helper alertMessage:@"网络异常，请求失败" addToView:self.view];
        }];
    }];
    //调用相册
    [ac showPreviewAnimated:YES];
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
