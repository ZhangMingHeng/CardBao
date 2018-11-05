//
//  ApplyRecordModel.h
//  CardBao
//
//  Created by zhangmingheng on 2018/10/13.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplyRecordModel : NSObject

// 记录Id
@property (nonatomic, strong) NSString *iId;

// 申请金额
@property (nonatomic, strong) NSString *loanAmount;

// 借款期限
@property (nonatomic, strong) NSString *loanLimit;

// 申请状态
@property (nonatomic, strong) NSString *status;

// 申请时间
@property (nonatomic, strong) NSString *loanRecordTime;

// 编号
@property (nonatomic, strong) NSString *kaobaoId;

@end

NS_ASSUME_NONNULL_END
