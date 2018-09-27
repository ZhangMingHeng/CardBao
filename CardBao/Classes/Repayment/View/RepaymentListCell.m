//
//  RepaymentListCell.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "RepaymentListCell.h"

#define LabelW (screenWidth-10)/3.0

@implementation RepaymentListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI {
    
    //框架
//    UILabel *framework          = [UILabel new];
//    framework.layer.borderWidth = 1;
//    framework.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    [self.contentView addSubview:framework];
    
    _codeLabel = [UILabel new];
    [self.contentView addSubview:_codeLabel];
    
    // 虚线
//    UIImageView *lineLabel = [[UIImageView alloc]initWithFrame:CGRectMake(5, 40, LabelW*3, 1)];
//    lineLabel.backgroundColor = [UIColor lightGrayColor];
//    [self drawLineByImageView:lineLabel];
//    [self.contentView addSubview:lineLabel];
    
    UILabel *moneyTitle = [UILabel new];
    _moneyLabel         = [UILabel new];
    moneyTitle.text     = @"本期应还";
    [self.contentView addSubview:moneyTitle];
    [self.contentView addSubview:_moneyLabel];
    _moneyLabel.textAlignment = moneyTitle.textAlignment = NSTextAlignmentCenter;
    
    UILabel *monthTitle = [UILabel new];
    _monthLabel         = [UILabel new];
    monthTitle.text     = @"借款期限";
    [self.contentView addSubview:monthTitle];
    [self.contentView addSubview:_monthLabel];
    _monthLabel.textAlignment = monthTitle.textAlignment = NSTextAlignmentCenter;
    
    UILabel *dateTitle = [UILabel new];
    _dateLabel         = [UILabel new];
    dateTitle.text     = @"最近还款日";
    [self.contentView addSubview:dateTitle];
    [self.contentView addSubview:_dateLabel];
    _dateLabel.textAlignment = dateTitle.textAlignment = NSTextAlignmentCenter;
    
//    UILabel *lineL        = [UILabel new];
//    lineL.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:lineL];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_button setBackgroundImage:[UIImage imageNamed:@"My_fullButton"] forState:UIControlStateNormal];
    [self.contentView addSubview:_button];
    
    // 布局
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(15);
    }];
    [moneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(self->_codeLabel.mas_bottom).offset(30);
        make.width.mas_equalTo(LabelW);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyTitle);
        make.top.equalTo(moneyTitle.mas_bottom).offset(10);
        make.width.mas_equalTo(LabelW);
    }];
    [monthTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyTitle.mas_right);
        make.top.equalTo(moneyTitle);
        make.width.mas_equalTo(LabelW);
    }];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthTitle);
        make.top.equalTo(self->_moneyLabel);
        make.width.mas_equalTo(LabelW);
    }];
    [dateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthTitle.mas_right);
        make.top.equalTo(moneyTitle);
        make.width.mas_equalTo(LabelW);
    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateTitle);
        make.top.equalTo(self->_moneyLabel);
        make.width.mas_equalTo(LabelW);
    }];
//    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self->_moneyLabel.mas_bottom).offset(10);
//        make.left.equalTo(self.contentView).offset(5);
//        make.width.mas_equalTo(LabelW*3);
//        make.height.mas_equalTo(1.0);
//    }];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(40);
        make.top.equalTo(self->_moneyLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView);
    }];
//    [framework mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(5);
//        make.right.equalTo(self.contentView).offset(-5);
//        make.top.bottom.equalTo(self.contentView);
//    }];
    
    
}


- (void)drawLineByImageView:(UIImageView *)imageView {
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor darkGrayColor].CGColor);
    
    
    CGFloat lengths[] = {5,2};//先画4个点再画2个点
    CGContextSetLineDash(line,0, lengths,2);//注意2(count)的值等于lengths数组的长度
    
    CGContextMoveToPoint(line, 0.0, 2.0);    //开始画线
    CGContextAddLineToPoint(line,imageView.frame.size.width,2.0);
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    UIImage *image =   UIGraphicsGetImageFromCurrentImageContext();
    imageView.image = image;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
