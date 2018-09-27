//
//  NSString+Base64.h
//  CardBao
//
//  Created by zhangmingheng on 2018/8/13.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)
// 64编码
-(NSString*)base64EncodeString;
// 64解码
-(NSString *)base64DecodeString;
@end
