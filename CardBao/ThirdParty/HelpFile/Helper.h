//
//  Helper.h
//  PalmKitchen
//
//  Created by apple on 14-10-14.
//  Copyright (c) 2014年 apple. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define kJudgeLogin if ([Helper judgeLoginState]) return;

@interface Helper : NSObject

+(UIButton *)createButton:(CGRect)frame title:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector;

//字符串文字的长度
+(CGFloat)widthOfString:(NSString *)string font:(UIFont*)font height:(CGFloat)height;

//字符串文字的高度
+(CGFloat)heightOfString:(NSString *)string font:(UIFont*)font width:(CGFloat)width;

//获取今天的日期：年月日
+(NSDictionary *)getTodayDate;

//邮箱
+ (BOOL) justEmail:(NSString *)email;
//姓名
+(BOOL)justName:(NSString*)name;
//手机号码验证
+ (BOOL) justMobile:(NSString *)mobile;
// 香港手机验证
+ (BOOL) justMobileHK:(NSString *)mobile;
//车牌号验证
+ (BOOL) justCarNo:(NSString *)carNo;

//车型
+ (BOOL) justCarType:(NSString *)CarType;

//用户名
+ (BOOL) justUserName:(NSString *)name;

//密码
+ (BOOL) justPassword:(NSString *)passWord;

//昵称
+ (BOOL) justNickname:(NSString *)nickname;

//身份证号
+ (BOOL) justIdentityCard: (NSString *)identityCard;

// 检验银行卡
+ (BOOL) justBankCardNo:(NSString*) cardNo;

// 字典判断是否为空
+ (BOOL) justDictionary:(id)dictionary;

// 数组判断是否为空
+ (BOOL) justArray:(id)array;

// 通用正则删除
+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr;

// 通用正则判断
+ (BOOL)validateFormatByRegexForString:(NSString *)string Regex:(NSString *)regex;

//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color withButonWidth:(CGFloat) width withButtonHeight:(CGFloat) height;

// 获取 RootState.plist 数据
+ (NSString*)getLoadStorageData;

+ (void)loadStorageData:(NSString *)type data:(id) obj;
// 判断空字符串处理
+ (id)isNullToString:(id)string returnString:(id) rString;
// 提醒框
+ (void)alertMessage:( NSString*) msg addToView:(UIView*) view;
+(void)removeAlertMessage;

+(NSDictionary*)getAbnormalData;
// 获取外网ip
+(NSString *)deviceWANIPAddress;
// 行距设置
+ (void) setSpaceNum:(NSString *) contentText obj:(UILabel*)label;
// 取消 第一响应
+ (void)resignTheFirstResponder;
//比较时间
+ (NSDateComponents *)compareDateWithPastDate:(NSDate *)pastDate futureDate:(NSDate *)futureDate;
+ (NSDateComponents *)compareDateWithPastDateStr:(NSString *)pastDateStr futureDateStr:(NSString *)futureDateStr;

// 把文本生成链接
+ (NSMutableAttributedString*)setAttributedString:(NSString*) attrString  selectStrings:(NSArray<NSString*> * ) selectString;

@end


