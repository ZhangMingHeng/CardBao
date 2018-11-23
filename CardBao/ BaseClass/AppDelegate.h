//
//  AppDelegate.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/16.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "DYNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TabBarViewController *tabBarVC;
@property (strong, nonatomic) DYNavigationController *navigationVC;
@property (strong, nonatomic) NSString *appURL;

@end

