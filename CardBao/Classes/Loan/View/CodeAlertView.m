//
//  CodeAlertView.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/23.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "CodeAlertView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define VIEWHEIGHT 168
#define CodeNumer 120

@interface CodeAlertView ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *phoneText;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UITextField *codeInput;
@property (nonatomic, assign) int countDown;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *senderButton;

@end
@implementation CodeAlertView

- (instancetype)init {
    if (self = [super init]) {
        
        [self setupAlertView];
    }
    return self;
}
- (void)setupAlertView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self addSubview:self.backView];
    
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, WIDTH, CGRectGetHeight(self.superview.frame));
    _backView.frame = CGRectMake(30, (CGRectGetHeight(self.frame)-VIEWHEIGHT)/2-60, WIDTH-60, VIEWHEIGHT);
    
    // 手机号码
    [self.backView addSubview:self.phoneText];
    // 验证码
    [self.backView addSubview:self.codeLabel];
    [self.backView addSubview:self.codeInput];
    [self.backView addSubview:self.codeButton];
    //线条
    UILabel *lineA = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.codeButton.frame)+20, CGRectGetWidth(self.backView.frame), 1)];
    lineA.backgroundColor = [UIColor lightGrayColor];
    [self.backView addSubview:lineA];
    UILabel *lineB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.backView.frame)/2.0-0.5, CGRectGetMaxY(lineA.frame), 1, 50)];
    lineB.backgroundColor = [UIColor lightGrayColor];
    [self.backView addSubview:lineB];
    
    // 按钮
    for (int i = 0; i< 2; i++) {
        self.senderButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        self.senderButton.tag   = i+9;
        self.senderButton.frame = CGRectMake(0+i*CGRectGetWidth(self.backView.frame)/2.0, CGRectGetMaxY(lineA.frame), CGRectGetWidth(self.backView.frame)/2.0, 50);
        [self.senderButton setTitle:i==0?@"取消":@"确定" forState:UIControlStateNormal];
        [self.senderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.senderButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:self.senderButton];
        [self.senderButton setTitleColor:i==0?[UIColor lightGrayColor]:HomeColor forState:UIControlStateNormal];
    }
    
}

-(UIView*)backView {
    if (!_backView) {
        _backView                    = [UIView new];
        _backView.backgroundColor    = [UIColor whiteColor];
        _backView.layer.cornerRadius = 5.0;
        _backView.clipsToBounds      = YES;
    }
    return _backView;
}
-(UILabel*)phoneText {
    if (!_phoneText) {
        _phoneText = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, CGRectGetWidth(_backView.frame)-40, 15)];
        _phoneText.text = [NSString stringWithFormat:@"手机号码：%@",_phoneNum];
    }
    return _phoneText;
}
-(UILabel*)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_phoneText.frame)+30, 90, 15)];
        _codeLabel.text = @"    验证码：";
    }
    return _codeLabel;
}
-(UITextField*)codeInput {
    if (!_codeInput) {
        _codeInput = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_codeLabel.frame), CGRectGetMaxY(_phoneText.frame)+25, CGRectGetWidth(self.backView.frame)-92-5-CGRectGetMaxX(_codeLabel.frame), 25)];
        _codeInput.placeholder = @"请输入验证码";
    }
    return _codeInput;
}
-(UIButton*)codeButton {
    if (!_codeButton) {
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeButton.frame = CGRectMake(CGRectGetWidth(self.backView.frame)-92-5, CGRectGetMaxY(_phoneText.frame)+
                                       22.5, 92, 30);
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setBackgroundImage:[Helper imageWithColor:HomeColor withButonWidth:92 withButtonHeight:30] forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        _codeButton.layer.cornerRadius = 5;
        _codeButton.clipsToBounds      = YES;
        _codeButton.titleLabel.font    = DYNormalFont;
    }
    return _codeButton;
}
#pragma mark 获取验证码
-(void)getCodeClick:(UIButton*)sender {
    _countDown = CodeNumer;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    _submitEvent(1,nil);
}
-(void)handleTimer{
    UIButton *button = _codeButton;
    if (_countDown>0) {
        [button setEnabled:NO];
        [button setTitle:[NSString stringWithFormat:@"%d秒",self->_countDown] forState:UIControlStateNormal];
    } else {
        _countDown = CodeNumer;
        [self.timer invalidate];
        [button setEnabled:YES];
        [button setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
    }
    _countDown = _countDown-1;
}
-(void)submitClick:(UIButton*) sender {
    if (sender.tag == 9||(sender.tag == 10&&self.codeInput.text.length>0)) {
        [self removeFromSuperview];
        
    }
    _submitEvent(sender.tag,self.codeInput.text);
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self removeFromSuperview];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
