//
//  TextLoopView.h
//  Telework
//
//  Created by zhangmingheng on 2017/9/25.
//  Copyright © 2017年 tsta. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectTextBlock)(NSString *selectString, NSInteger index);
@interface TextLoopView : UIView
@property (nonatomic, strong) UITableView *tableView;
/**
 直接调用这个方法
 
 @param dataSource 数据源
 @param timeInterval 时间间隔,默认是1.0秒
 @param frame 控件大小
 */
+ (instancetype)textLoopViewWith:(NSArray *)dataSource loopInterval:(NSTimeInterval)timeInterval initWithFrame:(CGRect)frame selectBlock:(selectTextBlock)selectBlock;
-(void)reloadDataWith:(NSArray *)dataSource;
@end
