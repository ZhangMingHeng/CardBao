//
//  FoldingTableView.m
//  QIJIALandlord
//
//  Created by zhangmingheng on 2018/1/27.
//  Copyright © 2018年 Shenzhen Feiben Technology Co., Ltd. All rights reserved.
//

#import "FoldingTableView.h"

static NSString *FoldingSectionHeaderID = @"FoldingSectionHeader";

@interface FoldingTableView () <FoldingSectionHeaderDelegate>

@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation FoldingTableView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
    
        [self setupDelegateAndDataSource];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDelegateAndDataSource];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - 创建数据源和代理

- (void)setupDelegateAndDataSource
{
    // 适配iOS 11
#ifdef __IPHONE_11_0
    
    if (@available(iOS 11.0, *)) {
        if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
#endif
    self.delegate = self;
    self.dataSource = self;
    if (self.style == UITableViewStylePlain) {
        self.tableFooterView = [[UIView alloc] init];
    }
    
    [self registerClass:[FoldingSectionHeader class] forHeaderFooterViewReuseIdentifier:FoldingSectionHeaderID];
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeStatusBarOrientationNotification:)  name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    
    if (!_foldingState) {
        _foldingState = FoldingSectionStateFlod;
    }
    
    if (_statusArray.count) {
        if (_statusArray.count > self.numberOfSections) {
            [_statusArray removeObjectsInRange:NSMakeRange(self.numberOfSections, _statusArray.count - self.numberOfSections)];
        }else if (_statusArray.count < self.numberOfSections) {
            NSInteger statusCount = _statusArray.count;
            for (NSInteger i = 0; i < self.numberOfSections - statusCount; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:_foldingState]];
            }
        }
    }else{
        for (NSInteger i = 0; i < self.numberOfSections; i++) {
            // 是否展开第一个
            if (i == 0 && self.isUnfoldSectionOne) [_statusArray addObject:[NSNumber numberWithInteger:FoldingSectionStateShow]];
            else [_statusArray addObject:[NSNumber numberWithInteger:_foldingState]];
            
            self.isUnfoldSectionOne = NO;
            
        }
    }
    return _statusArray;
}
-(void) setStatusArray {
    [self statusArray];
}
- (void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

#pragma mark - UI Configration

- (FoldingSectionHeaderArrowPosition )perferedArrowPosition
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(perferedArrowPositionForFoldingTableView:)]) {
        return [_foldingDelegate perferedArrowPositionForFoldingTableView:self];
    }
    return FoldingSectionHeaderArrowPositionRight;
}
- (UIColor *)backgroundColorForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:backgroundColorForHeaderInSection:)]) {
        return [_foldingDelegate foldingTableView:self backgroundColorForHeaderInSection:section];
    }
    return [UIColor whiteColor];
}
- (NSString *)titleForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:titleForHeaderInSection:)]) {
        return [_foldingDelegate foldingTableView:self titleForHeaderInSection:section];
    }
    return [NSString string];
}
- (UIFont *)titleFontForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:fontForTitleInSection:)]) {
        return [_foldingDelegate foldingTableView:self fontForTitleInSection:section];
    }
    return [UIFont systemFontOfSize:17];
}
- (UIColor *)titleColorForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:textColorForTitleInSection:)]) {
        return [_foldingDelegate foldingTableView:self textColorForTitleInSection:section];
    }
    return [UIColor blackColor];
}
- (NSString *)descriptionForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:descriptionForHeaderInSection:)]) {
        return [_foldingDelegate foldingTableView:self descriptionForHeaderInSection:section];
    }
    return [NSString string];
}
- (UIFont *)descriptionFontForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:fontForDescriptionInSection:)]) {
        return [_foldingDelegate foldingTableView:self fontForDescriptionInSection:section];
    }
    return [UIFont boldSystemFontOfSize:13];
}

- (UIColor *)descriptionColorForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:textColorForDescriptionInSection:)]) {
        return [_foldingDelegate foldingTableView:self textColorForDescriptionInSection:section];
    }
    return [UIColor whiteColor];
}

- (UIImage *)arrowImageForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:arrowImageForSection:)]) {
        return [_foldingDelegate foldingTableView:self arrowImageForSection:section];
    }
    return [UIImage imageNamed:@"My_right"];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(numberOfSectionForFoldingTableView:)]) {
        return [_foldingDelegate numberOfSectionForFoldingTableView:self];
    }else{
        return self.numberOfSections;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//     [self setStatusArray];
    if (((NSNumber *)self.statusArray[section]).integerValue == FoldingSectionStateShow) {
        if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:numberOfRowsInSection:)]) {
            return [_foldingDelegate foldingTableView:self numberOfRowsInSection:section];
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:heightForHeaderInSection:)]) {
        return [_foldingDelegate foldingTableView:self heightForHeaderInSection:section];
    }else{
        return self.sectionHeaderHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:heightForRowAtIndexPath:)]) {
        return [_foldingDelegate foldingTableView:self heightForRowAtIndexPath:indexPath];
    }else{
        return self.rowHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:heightForFooterInSection:)]) {
        return [_foldingDelegate foldingTableView:self heightForFooterInSection:section];
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FoldingSectionHeader *sectionHeaderView = [self dequeueReusableHeaderFooterViewWithIdentifier:FoldingSectionHeaderID];
    [sectionHeaderView configWithBackgroundColor:[self backgroundColorForSection:section]
                                     titleString:[self titleForSection:section]
                                      titleColor:[self titleColorForSection:section]
                                       titleFont:[self titleFontForSection:section]
                               descriptionString:[self descriptionForSection:section]
                                descriptionColor:[self descriptionColorForSection:section]
                                 descriptionFont:[self descriptionFontForSection:section]
                                      arrowImage:[self arrowImageForSection:section]
                                   arrowPosition:[self perferedArrowPosition]
                                    sectionState:((NSNumber *)self.statusArray[section]).integerValue
                                    sectionIndex:section];
    sectionHeaderView.tapDelegate = self;
//    sectionHeaderView.separatorLineColor = DYGrayColor(241);
//    sectionHeaderView.autoHiddenSeperatorLine = NO;
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:cellForRowAtIndexPath:)]) {
        return [_foldingDelegate foldingTableView:self cellForRowAtIndexPath:indexPath];
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCellIndentifier"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldingTableView:didSelectRowAtIndexPath:)]) {
        [_foldingDelegate foldingTableView:self didSelectRowAtIndexPath:indexPath];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];;
}
#pragma mark - FoldingSectionHeaderDelegate

- (void)FoldingSectionHeaderTappedAtIndex:(NSInteger)index
{
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index]).boolValue;
    
    [self.statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!currentIsOpen]];
    
    NSInteger numberOfRow = [_foldingDelegate foldingTableView:self numberOfRowsInSection:index];
    NSMutableArray *rowArray = [NSMutableArray array];
    if (numberOfRow) {
        for (NSInteger i = 0; i < numberOfRow; i++) {
            [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:index]];
        }
    }
    if (rowArray.count) {
        if (currentIsOpen) {
            // 合并
            [self deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            // 展开
            [self insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationNone];
            if (rowArray.count>0&&rowArray!=nil) {
                [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];//把最新的数据全部自动显示输出（自动滚出来的）
            }
        }
    }
}

@end
