//
//  FeebackViewController.m
//  QIJIALandlord
//
//  Created by zhangmingheng on 2017/12/20.
//  Copyright © 2017年 Shenzhen Feiben Technology Co., Ltd. All rights reserved.
//

#import "FeebackViewController.h"

@interface FeebackViewController ()<UITextViewDelegate>
{
    UILabel *placeholder;
    UITextView *feebackInput;
}

@end

@implementation FeebackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [feebackInput becomeFirstResponder];
}
#pragma mark initUI
-(void) initUI {
    self.title = @"意见反馈";
    
    feebackInput = [[UITextView alloc]initWithFrame:CGRectMake(20, 20, screenWidth-20*2, DYCalculateHeigh(200))];
    feebackInput.backgroundColor    = DYGrayColor(243);
    feebackInput.layer.cornerRadius = 3.0;
    feebackInput.layer.borderColor  = HomeColor.CGColor;
    feebackInput.layer.borderWidth  = 1.0;
    feebackInput.clipsToBounds      = YES;
    feebackInput.delegate           = self;
//    placeholder
    placeholder = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(feebackInput.frame), 30)];
    placeholder.text = @"  请描述您的问题";
    placeholder.textColor = DYColor(151, 149, 143);
    placeholder.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:feebackInput];
    [feebackInput addSubview:placeholder];

//    提交按钮
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.layer.cornerRadius = 20.0;
    submitButton.clipsToBounds      = YES;
    [submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"Common_SButton"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.top.equalTo(self->feebackInput.mas_bottom).offset(50);
    }];
}

#pragma mark TextView protocol
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        placeholder.hidden = NO;
    } else {
        placeholder.hidden = YES;
    }
}
#pragma mark 提交意见按钮事件
-(void)submitClick:(UIButton *) sender {
//    判断
    if (feebackInput.text.length == 0) {
        [Helper alertMessage:@"请描述您的问题" addToView:self.view];
        return;
    }
    if (feebackInput.text.length == 200) {
        [Helper alertMessage:@"不能超过200个文字" addToView:self.view];
        return;
    }
    sender.userInteractionEnabled = NO;
    [[RequestManager shareInstance]postWithURL:SUBMITFEEDBACK_INTERFACE parameters:@{@"suggest":feebackInput.text} isLoading:YES loadTitle:nil addLoadToView:self.view andWithSuccess:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        [Helper alertMessage:@"反馈成功" addToView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        sender.userInteractionEnabled = YES;
    } andWithWarn:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        sender.userInteractionEnabled = YES;
    } andWithFaile:^(RequestManager * _Nonnull manage, id  _Nonnull model) {
        sender.userInteractionEnabled = YES;
    } isCache:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
