//
//  NULLView.m
//  QIJIALandlord
//
//  Created by zhangmingheng on 2018/1/25.
//  Copyright © 2018年 Shenzhen Feiben Technology Co., Ltd. All rights reserved.
//

#import "NULLView.h"

@interface NULLView()

@end

@implementation NULLView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.frame           = CGRectMake(0, 0, screenWidth, screenHeight);
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

+(instancetype) emptyViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr {
    NULLView *nullView = [[self alloc]init];
    
    [nullView creatEmptyViewWithImageStr:imageStr titleStr:titleStr btnTitleStr:nil btnClickBlock:nil];
    return nullView;
}
+ (instancetype)emptyActionViewWithImageStr:(NSString *)imageStr
                                   titleStr:(NSString *)titleStr
                                btnTitleStr:(NSString *)btnTitleStr
                              btnClickBlock:(ActionTapBlock)btnClickBlock {
    NULLView *nullView = [[self alloc]init];
    [nullView creatEmptyViewWithImageStr:imageStr titleStr:titleStr btnTitleStr:btnTitleStr btnClickBlock:btnClickBlock];
    return nullView;
}
- (void)creatEmptyViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr btnTitleStr:(NSString *)btnTitleStr btnClickBlock:(ActionTapBlock)btnClickBlock{
    if (!self.contentView ) {
        self.contentView = [[UIImageView alloc]initWithFrame:CGRectMake((screenWidth-DYCalculate(112))/2, DYCalculate(209), DYCalculate(112), DYCalculate(84))];
        
        self.contentView.image = [UIImage imageNamed:imageStr];
        
        [self addSubview:self.contentView];
        
    }
    // 文字
    UILabel *textLabel      = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentView.frame)+15, screenWidth, 25)];
    textLabel.text          = titleStr;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor     = DYColor(95, 96, 100);
    [self addSubview:textLabel];
    

    //按钮
    if (btnTitleStr) {
        UIButton *button          = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 15.5;
        button.clipsToBounds      = YES;
        button.layer.borderColor  = DYColor(95, 96, 100).CGColor;
        button.layer.borderWidth  = 1;
        button.frame              = CGRectMake(screenWidth/2-45, CGRectGetMaxY(textLabel.frame)+15, 90, 31);
        [button addTarget:self action:@selector(upDateClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:DYColor(95, 96, 100) forState:UIControlStateNormal];
        [button setTitle:btnTitleStr forState:UIControlStateNormal];
        
        [self addSubview:button];
        self.contentView.frame = CGRectMake((screenWidth-DYCalculate(159))/2, DYCalculate(209), DYCalculate(159), DYCalculate(95));
    }
//    self.btnClickBloc = btnClickBlock;
    _btnClickBlock = btnClickBlock;
}
-(void) upDateClick {
    self.btnClickBlock();
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
