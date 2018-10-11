//
//  UIViewController+NavigationView.h
//  CardBao
//
//  Created by zhangmingheng on 2018/9/28.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NSObject)
-(void)setNavigationViewTitle:(NSString* _Nonnull) title hiddenBackButton:(BOOL) isHidden;

@end

NS_ASSUME_NONNULL_END
