//
//  FloatView.h
//  BleLock
//
//  Created by zhangmingheng on 16/9/12.
//  Copyright © 2016年 Newunity. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, UIFloatViewStyle) {
    UIFloatViewStyleNull, // 无图片
    UIFloatViewStyleSuccess, // 成功时的图片
    UIFloatViewStyleFaile, // 失败的图片
};

@interface FloatView : UIView
@property(nonatomic,strong,nonnull) NSString *message;
@property(nonatomic) UIFloatViewStyle * _Nonnull floatStyle;
@property(nonatomic,strong) UIImage * _Nullable imageView;
@property(nonatomic,assign) CGFloat time;
@property(nonatomic) BOOL isFullScreen;
//-(nonnull instancetype)initWithFloatContent:(nonnull NSString *)message andDisplayTime:(CGFloat) time isFullScreen:(BOOL)isFullScreen;
- (nonnull instancetype)initWithFloatContent:(nonnull NSString *)message andDisplayTime:(CGFloat) time andStyle:(UIFloatViewStyle) style;

@end
