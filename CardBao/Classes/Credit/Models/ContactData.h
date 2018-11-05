//
//  ContactData.h
//  CardBao
//
//  Created by zhangmingheng on 2018/10/15.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ContactData;

// manage:self  code:0成功\1失败  result:结果
typedef void (^requestContact)(ContactData * _Nonnull manage, NSInteger code ,NSDictionary *_Nonnull result);
typedef void (^requestPhoneNum)(ContactData * _Nonnull manage, NSInteger code ,NSString *_Nonnull result);

@interface ContactData : NSObject



// 初始化通讯录类
+(instancetype)shareInstance;

// 获取通讯数据
- (void)requestContactAuthorAfter:(UIViewController* _Nonnull) viewController resultBlock:(requestContact _Nonnull) requestContact;

- (void)requestContactUI:(UIViewController* _Nonnull) viewController resultBlock:(requestPhoneNum _Nonnull) requestPhoneNum;
@end

NS_ASSUME_NONNULL_END
