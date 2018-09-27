//
//  RequestActivityIndicatorView.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/27.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RequestActivityIndicatorView.h"

@implementation RequestActivityIndicatorView

+(instancetype)showAIVAddedTo:(nonnull UIView*)view {
    RequestActivityIndicatorView *aIV = [[RequestActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aIV.frame = view.bounds;
    [view addSubview:aIV];
    [aIV setupView];
    return aIV;
}
-(void)setupView {
    // 位置
    CGRect rect      = self.frame;
    CGPoint point    = self.center;
    rect.size.height = rect.size.width = 100;
    self.frame       = rect;
    self.center      = point;
    
    // 样式
    self.backgroundColor    = [UIColor colorWithWhite:0.f alpha:0.7];
    self.color              = [UIColor whiteColor];
    self.layer.cornerRadius = 10.0;
    self.clipsToBounds      = YES;
}


@end
