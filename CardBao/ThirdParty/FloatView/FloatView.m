//
//  FloatView.m
//  BleLock
//
//  Created by zhangmingheng on 16/9/12.
//  Copyright © 2016年 Newunity. All rights reserved.
//

#import "FloatView.h"
#import "AppDelegate.h"
@implementation FloatView
//-(nonnull instancetype)initWithFloatContent:(nonnull NSString *)message andDisplayTime:(CGFloat) time isFullScreen:(BOOL)isFullScreen
//{
//    self=[super init];
//    if (self) {
//        if (message==nil) {
//            _message=@"";
//        } else {
//            _message=message;
//        }
//        if (time>0) {
//            _time=time;
//        } else {
//            _time=1;
//        }
//        _isFullScreen = isFullScreen;
//        [self initUI];
//    }
//    return self;
//}
-(nonnull instancetype)initWithFloatContent:(nonnull NSString *)message andDisplayTime:(CGFloat) time andStyle:(UIFloatViewStyle) style{
    self=[super init];
    if (self) {
        if (message==nil) {
            _message=@"加载中...";
        } else {
            _message=message;
        }
        if (time>0) {
            _time=time;
        } else {
            _time=1;
        }
//        
//        if(style == UIFloatViewStyleSuccess) {
//            _imageView = [UIImage imageNamed:@"alertSuccessIcon"];
//        }
//        if(style == UIFloatViewStyleFaile) {
//            _imageView = [UIImage imageNamed:@"alertErrorIcon"];
//        }
//        if (style == UIFloatViewStyleNull) {
//            _imageView = nil;
//        }
        [self initUI];
    }
    return self;
}
-(void)initUI {
//    self.frame=CGRectMake(80, screenHeight/2-75, screenWidth-160, 130);
    
    self.backgroundColor=[UIColor blackColor];
    self.layer.cornerRadius=6.0;
    self.clipsToBounds=YES;
    self.alpha=0.7;
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.textAlignment=NSTextAlignmentCenter;
    textLabel.font=[UIFont systemFontOfSize:14];
    textLabel.textColor=[UIColor whiteColor];
    textLabel.numberOfLines = 3;
    textLabel.text=_message;
//    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-30)/2, 32, 30, 30)];
//    icon.image = _imageView;
//    [self addSubview:icon];
    CGRect textLabelRect=[textLabel.text boundingRectWithSize:CGSizeMake(0,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textLabel.font} context:nil];//自适应宽度和高度
    // 计算文字和self 的布局
    CGFloat selfWidth = textLabelRect.size.width>(screenWidth*2/3)?(screenWidth*2/3)+20:textLabelRect.size.width+20;
    self.frame = CGRectMake((screenWidth-selfWidth)/2, (screenHeight-30)/2, selfWidth, 60);
    textLabel.frame=CGRectMake(3 ,0, self.frame.size.width-6, CGRectGetHeight(self.frame));
//    if (!_isFullScreen){
//        
//    }
    [self addSubview:textLabel];
    [self performSelector:@selector(timedAlpha) withObject:self afterDelay:_time-0.7];//延迟动画
    [self performSelector:@selector(timedOut) withObject:self afterDelay:_time];//延迟销毁SELF
}
-(void)timedAlpha
{
    [UIView animateWithDuration:0.7 animations:^{
        //动画
        self.alpha=0;
    }];
}
-(void)timedOut
{
    [self removeFromSuperview];
}
@end
