//
//  NULLView.h
//  QIJIALandlord
//
//  Created by zhangmingheng on 2018/1/25.
//  Copyright © 2018年 Shenzhen Feiben Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 事件回调
 */
typedef void (^ActionTapBlock)(void);

@interface NULLView : UIView

@property (nonatomic, strong) UIImageView *contentView;

@property (nonatomic, copy, readonly) ActionTapBlock btnClickBlock;


/**
 构造方法1 - 创建emptyView
 
 @param imageStr    占位图片名称
 @param titleStr    标题

 @return 返回一个emptyView
 */
+(instancetype) emptyViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr;

/**
 构造方法2 - 创建emptyView
 
 @param imageStr       占位图片名称
 @param titleStr       占位描述
 @param btnTitleStr    按钮的名称
 @param btnClickBlock  按钮点击事件回调
 @return 返回一个emptyView
 */
+ (instancetype)emptyActionViewWithImageStr:(NSString *)imageStr
                                   titleStr:(NSString *)titleStr
                                btnTitleStr:(NSString *)btnTitleStr
                              btnClickBlock:(ActionTapBlock)btnClickBlock;

@end
