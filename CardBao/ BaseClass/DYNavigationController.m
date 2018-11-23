//
//  DYNavigationController.m
//  QIJIALandlord
//
//  Created by zhangmingheng on 2018/7/16.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import "DYNavigationController.h"

@interface DYNavigationController ()

@end

@implementation DYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    //    导航栏返回按钮（根据iOS版本不同，设置的方法也不同）
//    if (@available(iOS 11, *)) {
//        UIImage *backButtonImage = [[UIImage imageNamed:@"Login_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        //系统返回按钮处的title偏移到可视范围之外
//        UIOffset offset = UIOffsetMake(-screenWidth,0);
//
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsCompact];
//
//        [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
//        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
//
//
//    } else{
//        UIImage *backButtonImage = [[UIImage imageNamed:@"Login_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
//        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-screenWidth, -100) forBarMetrics:UIBarMetricsDefault];
//
//    }

    [self.navigationBar setBarTintColor:[UIColor colorWithRed:42.0/255.0 green:113.0/255.0 blue:241.0/255.0 alpha:1]]; // 背景色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]; // title字體色
    self.navigationBar.translucent = NO; // 半透明色

}
//重写push方法 push的控制器隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断首页没有返回按钮
    NSArray *vc = self.viewControllers;
    if (vc.count > 0) {
        //     隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;

        //    1.添加后退按钮
        [self addBackButton:viewController];
    }
    [super pushViewController:viewController animated:animated];

}
//2 自定义后退按钮
- (void)addBackButton:(UIViewController *)viewController {
    
    
    //开启手势后退
        self.interactivePopGestureRecognizer.delegate = (id)self;
    //开启手势滑动后退
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Common_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    // 取消图片渲染问题
    back.image = [back.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.navigationItem.leftBarButtonItems =@[back];
}

//点击后退的时候执行的方法
- (void)backClick {
    [self popViewControllerAnimated:YES];
    
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
