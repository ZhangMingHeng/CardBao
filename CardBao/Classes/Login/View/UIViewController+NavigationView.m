//
//  UIViewController+NavigationView.m
//  CardBao
//
//  Created by zhangmingheng on 2018/9/28.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "UIViewController+NavigationView.h"
@interface UIViewController (_NSObject)
{
    
}
@end

@implementation UIViewController (NSObject)

-(void)setNavigationViewTitle:(NSString* _Nonnull) title hiddenBackButton:(BOOL) isHidden backgroundColor:(UIColor*_Nullable)color{

    CGFloat stateHeight = [self statusHeight];
    
    // 隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    // 自定义导航
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    [self.view bringSubviewToFront:backView]; // 置为最上层
    backView.backgroundColor = color;
    
    // title
    UILabel *navigateTitle      = [UILabel new];
    navigateTitle.text          = title;
    navigateTitle.textColor     = [UIColor whiteColor];
    navigateTitle.font          = [UIFont systemFontOfSize:17.0 weight:0.5];
    navigateTitle.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:navigateTitle];
    
    
    [navigateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(backView).offset(stateHeight==88?44:20);
        make.height.mas_equalTo(44);
    }];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(stateHeight==88?88:64);
    }];
    
    if (isHidden) return; // 是否隐藏按钮
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Common_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.top.equalTo(navigateTitle);
        make.height.width.mas_equalTo(stateHeight==88?44:40);
    }];
    
}
-(CGFloat )statusHeight {
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    return statusRect.size.height + navRect.size.height;
}
-(void)backClick:(UIButton*) sender {
    sender.enabled = NO;
    // 如果是从登录页面过来的就直接设置rootViewController
    if ([self isKindOfClass:[LoginVC class]]) {
        AppDelegate *appDele = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDele.window.rootViewController = appDele.tabBarVC;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
