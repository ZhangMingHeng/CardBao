//
//  FoldingTableView.h
//  QIJIALandlord
//
//  Created by zhangmingheng on 2018/1/27.
//  Copyright © 2018年 Shenzhen Feiben Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldingSectionHeader.h"

@class FoldingTableView;

@protocol FoldingTableViewDelegate <NSObject>

@required
/**
 *  箭头的位置
 */
- (FoldingSectionHeaderArrowPosition)perferedArrowPositionForFoldingTableView:(FoldingTableView *)tableView;
/**
 *  返回section的个数
 */
- (NSInteger )numberOfSectionForFoldingTableView:(FoldingTableView *)tableView;
/**
 *  cell的个数
 */
- (NSInteger )foldingTableView:(FoldingTableView *)tableView numberOfRowsInSection:(NSInteger )section;
/**
 *  header的高度
 */
- (CGFloat )foldingTableView:(FoldingTableView *)tableView heightForHeaderInSection:(NSInteger )section;
/**
 *  cell的高度
 */
- (CGFloat )foldingTableView:(FoldingTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  header的标题
 */
- (NSString *)foldingTableView:(FoldingTableView *)tableView titleForHeaderInSection:(NSInteger )section;
/**
 *  返回cell
 */
- (UITableViewCell *)foldingTableView:(FoldingTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  点击cell
 */
- (void )foldingTableView:(FoldingTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 *  箭头图片
 */
- (UIImage *)foldingTableView:(FoldingTableView *)tableView arrowImageForSection:(NSInteger )section;

// 下面是一些属性的设置

- (NSString *)foldingTableView:(FoldingTableView *)tableView descriptionForHeaderInSection:(NSInteger )section;

- (UIColor *)foldingTableView:(FoldingTableView *)tableView backgroundColorForHeaderInSection:(NSInteger )section;

- (UIFont *)foldingTableView:(FoldingTableView *)tableView fontForTitleInSection:(NSInteger )section;

- (UIFont *)foldingTableView:(FoldingTableView *)tableView fontForDescriptionInSection:(NSInteger )section;

- (UIColor *)foldingTableView:(FoldingTableView *)tableView textColorForTitleInSection:(NSInteger )section;

- (UIColor *)foldingTableView:(FoldingTableView *)tableView textColorForDescriptionInSection:(NSInteger )section;

- (CGFloat)foldingTableView:(FoldingTableView *)tableView heightForFooterInSection:(NSInteger )section;

@end

@interface FoldingTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<FoldingTableViewDelegate> foldingDelegate;

@property (nonatomic, assign) FoldingSectionState foldingState;
@property (nonatomic, assign) BOOL isUnfoldSectionOne; // 默认不展开

@end
