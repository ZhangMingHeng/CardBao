//
//  TextLoopView.m
//  Telework
//
//  Created by zhangmingheng on 2017/9/25.
//  Copyright © 2017年 tsta. All rights reserved.
//

#import "TextLoopView.h"
@interface TextLoopView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *dataSource;
//@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, assign) NSInteger currentRowIndex;
@property (nonatomic, copy) selectTextBlock selectBlock;
@end
@implementation TextLoopView

#pragma mark - 初始化方法
+ (instancetype)textLoopViewWith:(NSArray *)dataSource loopInterval:(NSTimeInterval)timeInterval initWithFrame:(CGRect)frame selectBlock:(selectTextBlock)selectBlock {
    TextLoopView *loopView = [[TextLoopView alloc] initWithFrame:frame];
    loopView.dataSource = dataSource;
    loopView.selectBlock = selectBlock;
    loopView.interval = timeInterval ? timeInterval : 3.0;
    return loopView;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
//    NSString *timeStr = _dataSource[indexPath.row];
//
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, [Helper widthOfString:timeStr font:[UIFont systemFontOfSize:14] height:self.frame.size.height]+16, self.frame.size.height)];
//    timeLabel.text = timeStr;
//    timeLabel.textColor = [UIColor colorWithRed:1.0 green:141.0/255.0 blue:85.0/255 alpha:1];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    contentLabel.text   = _dataSource[indexPath.row];
    contentLabel.textColor = DYColor(160, 188, 240);
    contentLabel.backgroundColor = DYGrayColor(239);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell.contentView addSubview:timeLabel];
    [cell.contentView addSubview:contentLabel];
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectBlock) {
        NSArray *countArray = _dataSource;
        self.selectBlock(countArray[indexPath.row], indexPath.row);
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 以无动画的形式跳到第1组的第0行
    NSArray *countArray = _dataSource;
    if (_currentRowIndex == countArray.count) {
        _currentRowIndex = 0;
        [_tableView setContentOffset:CGPointZero];
    }
}

#pragma mark - priviate method
- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    
    // 定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timer) userInfo:nil repeats:YES];
    _myTimer = timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        // tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        _tableView = tableView;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        // 关闭 滚动效果
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = frame.size.height;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)timer {
    self.currentRowIndex++;
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI线程
        [self.tableView setContentOffset:CGPointMake(0, self.currentRowIndex * self.tableView.rowHeight) animated:YES];
    });
}
-(void)reloadDataWith:(NSArray *)dataSource {
    if (dataSource.count>0) {
        self.dataSource = dataSource;
        self.currentRowIndex = 0;
        [self.tableView setContentOffset:CGPointZero ];
        [self.tableView reloadData];
        
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
