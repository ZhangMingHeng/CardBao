//
//  CodeAlertView.h
//  CardBao
//
//  Created by zhangmingheng on 2018/7/23.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeAlertView : UIView
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic) void (^submitEvent)(NSInteger index,NSString *codeNum); // index ' 1=验证码，9=取消，10=确定
@end
