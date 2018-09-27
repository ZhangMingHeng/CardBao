//
//  CreditExtensionMainVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/24.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "IdentityVC.h"
#import "BasicInfoVC.h"
#import "ZHIMACreditVC.h"
#import "ConfirmInfoVC.h"
#import "BingBankCardVC.h"
#import "OperatorCreditVC.h"
#import "CreditExtensionMainVC.h"

@interface CreditExtensionMainVC ()
{
    
}
@end

@implementation CreditExtensionMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
-(void)getUI {
    [self.navigationItem setTitle:@"身份认证"];
    
    _stepLabel           = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 45)];
    _stepLabel.text      = @"1/5";
    _stepLabel.textColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_stepLabel];
    
    switch (_viewPush) {
        case CreditViewPushIdentity:
        {
            IdentityVC *vc = [IdentityVC new];
            [self addChildViewController:vc];
            self.childViewControllers[0].view.frame = self.view.bounds;
            [self.view addSubview:vc.view];
        }
            break;
        case CreditViewPushBankCard:
        {
            BingBankCardVC *vc = [BingBankCardVC new];
            [self addChildViewController:vc];
            self.childViewControllers[0].view.frame = self.view.bounds;
            [self.view addSubview:vc.view];
        }
            break;
        case CreditViewPushBasicInfo:
        {
            BasicInfoVC *vc = [BasicInfoVC new];
            [self addChildViewController:vc];
            self.childViewControllers[0].view.frame = self.view.bounds;
            [self.view addSubview:vc.view];
        }
            break;
        case CreditViewPushZHIMACredit:
        {
            ZHIMACreditVC *vc = [ZHIMACreditVC new];
            [self addChildViewController:vc];
            self.childViewControllers[0].view.frame = self.view.bounds;
            [self.view addSubview:vc.view];
        }
            break;
        case CreditViewPushOperator:
        {
            OperatorCreditVC *vc = [OperatorCreditVC new];
            [self addChildViewController:vc];
            self.childViewControllers[0].view.frame = self.view.bounds;
            [self.view addSubview:vc.view];
        }
            break;
        case CreditViewPushConfirmInfo:
        {
            ConfirmInfoVC *vc = [ConfirmInfoVC new];
            [self addChildViewController:vc];
            self.childViewControllers[0].view.frame = self.view.bounds;
            [self.view addSubview:vc.view];
        }
            break;
        default:
            break;
    }
    
    
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
