//
//  AppDelegate.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/16.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import <AFNetworkActivityIndicatorManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 如果环境接口变了话也转入登录页面重新获取数据
    if (![kINTERFACE isEqualToString:[NSString stringWithFormat:@"%@",Host_And_Port]]) INPUTLoginState(NO);
    INPUTINTERFACE(Host_And_Port); //存储主接口
    
    //    判断登录状态
    if (kLoginStatus) {
        // 进入主页面
        self.window.rootViewController = [TabBarViewController new];
    } else {
        // 进入登录页面
        self.navigationVC = [[DYNavigationController alloc]initWithRootViewController: [LoginVC new]];
        self.window.rootViewController = self.navigationVC;
    }
    
    
    //***************    腾讯BuglySDK start    ***************//
    
    BuglyConfig *config = [[BuglyConfig alloc]init];
    config.reportLogLevel = BuglyLogLevelInfo; // 异常时上报的日志类型
    config.debugMode = YES; // debug模式 是否开启日志
    [Bugly startWithAppId:BUGLYAPPID developmentDevice:YES config:config];
    
    //***************    腾讯BuglySDK end    ***************//
    
    
    //***************    定位 start    ***************//
    [[LocationManager shareInstance] requestLocation:(UIViewController*)self.window resultBlock:^(LocationManager * _Nonnull manage, NSInteger code, NSDictionary * _Nonnull result) {
        if (code == 0) {
        }
    }];
    //***************    定位 end     ***************//

    // 设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    NSLog(@"url : %@", url.absoluteString);
    self.appURL = url.absoluteString;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
