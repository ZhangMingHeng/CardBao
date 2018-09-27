//
//  ConfirmInfoTwoCell.h
//  CardBao
//
//  Created by zhangmingheng on 2018/8/11.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmInfoTwoCell : UITableViewCell
@property (nonatomic, strong) UIButton *changeInfo; // 修改信息
-(void)titleArray:(NSArray <NSString*>*) titleS withValueArray:(NSArray <NSString*>*) valueS ;
@end
