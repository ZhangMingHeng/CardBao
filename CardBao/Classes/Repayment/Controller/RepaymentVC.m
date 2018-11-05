//
//  RepaymentVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/19.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RepaymentVC.h"
#import "RepaymentListVC.h"
#import "FSScrollContentView.h"

@interface RepaymentVC ()<FSSegmentTitleViewDelegate, FSPageContentViewDelegate>
{
    FSSegmentTitleView *segmentView;
    FSPageContentView *contentView;
}
@end

@implementation RepaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
-(void)getUI {
    self.title = @"我要还款";
    
    //设置标题视图
    segmentView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 45) titles:@[@"还款中",@"已结清"] delegate:self indicatorType:FSIndicatorTypeDefault];
    
    //设置标题样式
    segmentView.backgroundColor = [UIColor clearColor];
    segmentView.titleSelectColor = HomeColor;
    segmentView.titleNormalColor = [UIColor blackColor];
    segmentView.titleFont = [UIFont systemFontOfSize:16];
    segmentView.titleSelectFont = [UIFont systemFontOfSize:16];
    segmentView.indicatorColor = HomeColor;
    segmentView.indicatorView.layer.cornerRadius = 1;
    segmentView.indicatorView.clipsToBounds = YES;
    //默认选取
    segmentView.selectIndex = 0;
    [self.view addSubview:segmentView];
    
    //     横线
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, screenWidth, 1)];
    lineLabel.backgroundColor = DYGrayColor(229);
    [self.view addSubview:lineLabel];
    
    // 设置内容视图
    RepaymentListVC *reing = [RepaymentListVC new];
    RepaymentListVC *repay = [RepaymentListVC new];
    reing.RepaymentState   = NSRepaymentStateInRepayment;
    repay.RepaymentState   = NSRepaymentStateEnd;
    
    contentView = [[FSPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentView.frame), screenWidth,screenHeight-self.navigationController.navigationBar.frame.size.height-self.navigationController.navigationBar.frame.origin.y-45) childVCs:@[reing,repay] parentVC:self delegate:self];
    
    contentView.contentViewCurrentIndex = 0;
    contentView.contentViewCanScroll = YES;
    [self.view addSubview:contentView];
    
}
#pragma mark - FSSegmentTitleViewDelegate
/**
 切换标题
 
 @param titleView FSSegmentTitleView
 @param startIndex 切换前标题索引
 @param endIndex 切换后标题索引
 */
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    contentView.contentViewCurrentIndex = endIndex;
}
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    segmentView.selectIndex = endIndex;
    contentView.contentViewCurrentIndex = endIndex;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
