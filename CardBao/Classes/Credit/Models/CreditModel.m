//
//  CreditModel.m
//  CardBao
//
//  Created by zhangmingheng on 2018/10/17.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "CreditModel.h"

@implementation CreditModel

@end

@implementation IdentityModel


@end

@implementation BingBankCardModel

@end

@implementation BankCardListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"iId" : @"id"};
}

@end

@implementation BasicInfoModel


@end
