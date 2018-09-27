//
//  TabBarViewController.m
//  DanYuSteward
//
//  Created by zhangmingheng on 2018/7/16.
//  Copyright © 2018 andy_zhang. All rights reserved.
//


#import "MyVC.h"
#import "LoanVC.h"
#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    // 导航栏
    DYNavigationController* loanNaVC      = [[DYNavigationController alloc]initWithRootViewController:[LoanVC new]];
    DYNavigationController* myNaVC = [[DYNavigationController alloc]initWithRootViewController:[MyVC new]];
    NSArray* titleAry = [NSArray array];
    NSArray* tabBarImageAry = [NSArray array];
    NSArray* tabBarSelectImageAry = [NSArray array];
    
    
    self.viewControllers=@[loanNaVC,myNaVC];
    titleAry = @[@"借款",@"我的",];
    tabBarImageAry = @[@"Loan_loan",@"My_my",];
    tabBarSelectImageAry = @[@"Loan_loanSelect",@"My_mySelect"];
   
    
   
    NSMutableArray* imageAry = [NSMutableArray array];
    NSMutableArray* selectImageAry = [NSMutableArray array];
    for (int i=0; i<tabBarImageAry.count; i++) {
        //UIImageRenderingModeAlwaysOriginal:防止图片渲染
        UIImage* tabBarImage = [[UIImage imageNamed:tabBarImageAry[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage* taBarSelectImage = [[UIImage imageNamed:tabBarSelectImageAry[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [imageAry addObject:tabBarImage];
        [selectImageAry addObject:taBarSelectImage];
    }
    for (int i=0; i<self.viewControllers.count; i++) {
        DYNavigationController* naVC = self.viewControllers[i];
        naVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:titleAry[i] image:imageAry[i] selectedImage:selectImageAry[i]];
       
        // 选中字体颜色
        [naVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HomeColor} forState:UIControlStateSelected];
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
