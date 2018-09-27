//
//  AdvanceEndAlert.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvanceEndAlert : UIView
@property(nonatomic, strong) NSString *totalNum;
@property(nonatomic, strong) NSString *moneyNum;
@property(nonatomic, strong) NSString *interestNum;
@property(nonatomic, strong) NSString *feeNum;

@property(nonatomic) void (^event)(NSInteger index); // index 1 取消， 2确定
@end
