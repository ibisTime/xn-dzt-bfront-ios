//
//  ZHCaptchaView.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHCaptchaView.h"
#import "ZHAccountTf.h"
#import "TLTimeButton.h"
#import "UIView+Frame.h"
#import "UIColor+Extension.h"

@implementation ZHCaptchaView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUIWith:frame];
        
    }
    return self;
}

- (void)setUpUIWith:(CGRect)frame
{
    
    self.captchaTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:self.captchaTf];
    self.captchaTf.rightViewMode = UITextFieldViewModeAlways;
    
    //获得验证码按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, frame.size.height)];
    
    TLTimeButton *captchaBtn = [[TLTimeButton alloc] initWithFrame:CGRectMake(0, 0, 100, frame.size.height - 15) totalTime:60.0];
    captchaBtn.backgroundColor = [UIColor orangeColor];
    self.captchaBtn = captchaBtn;
    [self.captchaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    UIColor *titleColor = [UIColor colorWithHexString:@"#b3b3b3"];

    
    self.captchaTf.keyboardType = UIKeyboardTypeNumberPad;
    captchaBtn.layer.borderColor = titleColor.CGColor;
    captchaBtn.layer.borderWidth = 1.0;
    captchaBtn.layer.cornerRadius = 4;
    captchaBtn.clipsToBounds = YES;
    captchaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    captchaBtn.backgroundColor = [UIColor clearColor];
    
    [captchaBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [captchaBtn setTitleColor:titleColor forState:UIControlStateDisabled];
    captchaBtn.centerY = rightView.height/2.0;
    [rightView addSubview:captchaBtn];
    
    self.captchaTf.rightView = rightView;

    
//    //2.1 添加分割线
//    UIView *sLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 20)];
//    sLine.centerY = captchaBtn.centerY;
//    sLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
//    [captchaBtn addSubview:sLine];
    
}

@end
