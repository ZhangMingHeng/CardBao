//
//  NSString+Base64.m
//  CardBao
//
//  Created by zhangmingheng on 2018/8/13.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)

// iOS7 正式推出
// 对一个字符串进行base64编码
-(NSString*)base64EncodeString {
    //1、 字符串转二进制
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
     //2.对二进制数据进行base64编码,完成之后返回字符串
    return [data base64EncodedStringWithOptions:0];
}

// 对base64编码之后的字符串解码
-(NSString *)base64DecodeString
{
    //注意:该字符串是base64编码后的字符串
    //1.转换为二进制数据(完成了解码的过程)
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    
    //2.把二进制数据在转换为字符串
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
@end
