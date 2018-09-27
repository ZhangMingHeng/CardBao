//
//  RequestUtils.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/31.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RequestUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RequestUtils
//md5加密
+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}
@end
