//
//  FoldingSectionHeader.h
//  QIJIALandlord
//
//  Created by zhangmingheng on 2018/1/27.
//  Copyright © 2018年 Shenzhen Feiben Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FoldingSectionState) {
    
    FoldingSectionStateFlod, // 折叠
    FoldingSectionStateShow, // 打开
};

// 箭头的位置
typedef NS_ENUM(NSUInteger, FoldingSectionHeaderArrowPosition) {
    
    FoldingSectionHeaderArrowPositionLeft, // 左
    FoldingSectionHeaderArrowPositionRight, // 右
};

@protocol FoldingSectionHeaderDelegate <NSObject>

- (void)FoldingSectionHeaderTappedAtIndex:(NSInteger)index;

@end


@interface FoldingSectionHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id <FoldingSectionHeaderDelegate> tapDelegate;

@property (nonatomic, assign) BOOL autoHiddenSeperatorLine;

@property (nonatomic, strong) UIColor *separatorLineColor;

- (void)configWithBackgroundColor:(UIColor *)backgroundColor
                      titleString:(NSString *)titleString
                       titleColor:(UIColor *)titleColor
                        titleFont:(UIFont *)titleFont
                descriptionString:(NSString *)descriptionString
                 descriptionColor:(UIColor *)descriptionColor
                  descriptionFont:(UIFont *)descriptionFont
                       arrowImage:(UIImage *)arrowImage
                    arrowPosition:(FoldingSectionHeaderArrowPosition)arrowPosition
                     sectionState:(FoldingSectionState)sectionState
                     sectionIndex:(NSInteger)sectionIndex;



@end
