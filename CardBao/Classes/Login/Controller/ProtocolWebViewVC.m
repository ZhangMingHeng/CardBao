//
//  ProtocolWebViewVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/11/5.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "ProtocolWebViewVC.h"

@interface ProtocolWebViewVC ()

{
    CGFloat statusHeight;
}
@property (nonatomic, strong) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end


@implementation ProtocolWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getStatusHeight];
    [self getUI];
}
-(void)getStatusHeight {
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    statusHeight = statusRect.size.height + navRect.size.height;
}
-(void)getUI {
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:[WKWebViewConfiguration new]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_webView];
//    _webView.navigationDelegate = self;
    
    // UIProgressView初始化
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, self.webView.frame.size.width, 1);
    self.progressView.trackTintColor = [UIColor clearColor];
    // 设置进度条的色彩
    self.progressView.progressTintColor = [UIColor orangeColor];
    // 设置初始的进度，防止用户进来就懵逼了（微信大概也是一开始设置的10%的默认值）
    [self.progressView setProgress:0.1 animated:YES];
    [self.webView addSubview:self.progressView];
    
    
    if(_baseViewPushType == NSprotocolViewPushTypeDefault) {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(self->statusHeight==88?88:64, 0, 0, 0));
        }];
        // 自定义导航栏
        [self setNavigationViewTitle:@"注册协议" hiddenBackButton:NO backgroundColor:HomeColor];
    } else {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
    }

    // KVO监听 监听进度、URL、标题的变化
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}
// 监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 监听“estimatedProgress”的值的变化
    
    if ([object isEqual:self.webView] && [keyPath isEqualToString:@"estimatedProgress"]) {
        // 进度条
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        
        if (newprogress == 1) {
            
            // 加载完成 // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES]
            ;
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                [self.refreshControl endRefreshing];
                
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
                
            });
            
        } else {
            // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
            
        }
        
    }
}
-(void)dealloc {
    // 移除监听者
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
