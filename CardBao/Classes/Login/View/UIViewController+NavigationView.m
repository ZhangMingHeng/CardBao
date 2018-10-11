//
//  UIViewController+NavigationView.m
//  CardBao
//
//  Created by zhangmingheng on 2018/9/28.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "UIViewController+NavigationView.h"

@interface UIViewController (_NSObject)

@end

@implementation UIViewController (NSObject)

-(void)setNavigationViewTitle:(NSString* _Nonnull) title hiddenBackButton:(BOOL) isHidden {

    CGFloat stateHeight = [self statusHeight];
    
    // 隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    // 自定义导航
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    [self.view bringSubviewToFront:backView]; // 置为最上层
    
    // title
    UILabel *navigateTitle      = [UILabel new];
    navigateTitle.text          = title;
    navigateTitle.textColor     = [UIColor whiteColor];
    navigateTitle.font          = [UIFont systemFontOfSize:17.0 weight:0.5];
    navigateTitle.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:navigateTitle];
    
    
    [navigateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(backView);
        make.height.mas_equalTo(stateHeight==88?44:40);
    }];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(stateHeight==88?44:20);
        make.height.mas_equalTo(stateHeight==88?44:40);
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
