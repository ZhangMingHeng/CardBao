//
//  NSString+MD5.m
//  CardBao
//
//  Created by zhangmingheng on 2018/8/13.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "NSString+MD5.h"
#import<CommonCrypto/CommonDigest.h>

@implementation NSString(MD5)

 // 32位 小写
-(NSString*)MD5 {
    
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]]; // 十六进制整型
    }

    return outputString;
}

#pragma mark - 16位 小写
-(NSString *)MD5ForLower16Bate{
    
    NSString *md5Str = [self MD5];
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

@end
