//
//  RequestUtils.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/31.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUtils : NSObject
/**
 将路径进行md5加密
 
 @param string 数据文件储存路径
 @return 加密后的文件路径
 */
+ (NSString *)md5StringFromString:(NSString *)string;
@end
