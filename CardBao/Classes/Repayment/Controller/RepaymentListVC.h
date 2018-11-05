//
//  RepaymentListVC.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/19.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "BaseViewController.h"

typedef  NS_ENUM(NSUInteger, NSRepaymentState){
    NSRepaymentStateInRepayment,
    NSRepaymentStateEnd,
};

@interface RepaymentListVC : BaseViewController

@property(nonatomic, assign) NSRepaymentState RepaymentState;

@end
