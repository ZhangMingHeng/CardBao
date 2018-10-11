//
//  ZHIMACreditVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "ZHIMACreditVC.h"
#import "OperatorCreditVC.h"
#import "CreditExtensionMainVC.h"
@interface ZHIMACreditVC ()

@end

@implementation ZHIMACreditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
-(void)getUI {
    CreditExtensionMainVC *viewC = self.navigationController.viewControllers.lastObject;
    viewC.title = @"芝麻授权";
    viewC.stepLabel.text = @"4/5";
    
    // icon
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Loan_zhima"]];
    [self.view addSubview:img];
    
    // detail
    UILabel *detailLabel      = [UILabel new];
    detailLabel.numberOfLines = 0;
    detailLabel.text          = @"获取您的芝麻信誉分仅供卡宝用户授权额度参考依据，我们将对您的信息予以严格保密。";
    [self.view addSubview:detailLabel];
    // 按钮
    UIButton *accessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accessButton.layer.cornerRadius = 20;
    accessButton.clipsToBounds      = YES;
    [accessButton setTitle:@"授权访问" forState:UIControlStateNormal];
    [accessButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [accessButton addTarget:self action:@selector(accessClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accessButton];

    // 布局
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(150);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
    }];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(img.mas_bottom).offset(80);
    }];
    [accessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(self.view).offset(37);
        make.right.equalTo(self.view).offset(-37);
        make.bottom.equalTo(self.view).offset(-60);
    }];
}
#pragma mark 授权访问
-(void)accessClick:(UIButton*)sender {
    OperatorCreditVC *operatorVC = [OperatorCreditVC new];
    [self addChildViewController:operatorVC];
    self.childViewControllers[0].view.frame = self.view.bounds;
    [self.view addSubview:operatorVC.view];
    
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
