//
//  CustomCaptchaView.m
//  CustomB
//
//  Created by  tianlei on 2017/8/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CustomCaptchaView.h"
#import "UILable+convience.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

@implementation CustomCaptchaView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.leftTitleLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentRight
                                    backgroundColor:[UIColor whiteColor]
                                               font:[UIFont systemFontOfSize:14]
                                          textColor:[UIColor colorWithHexString:@"#4d4d4d"]];
        [self addSubview:self.leftTitleLbl];
     
        self.leftTitleLbl.text = @"验证码";
        //
        self.captchaBtn = [[TLTimeButton alloc] initWithFrame:CGRectZero totalTime:60];
        [self addSubview:self.captchaBtn];
         self.captchaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
         self.captchaBtn.layer.borderColor = [UIColor colorWithHexString:@"#9d9d9d"].CGColor;
        self.captchaBtn.layer.borderWidth = 1.0;
        self.captchaBtn.layer.cornerRadius = 4;
        self.captchaBtn.clipsToBounds = YES;
        self.captchaBtn.backgroundColor = [UIColor colorWithHexString:@"#b2b2b2"];
        
        [self.captchaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //
        self.textField = [[UITextField alloc] init];
        [self addSubview:self.textField];
        
        self.textField.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.layer.borderColor = [UIColor colorWithHexString:@"#9d9d9d"].CGColor;
        self.textField.layer.borderWidth = 0.75;
        self.textField.layer.cornerRadius = 5;
        self.textField.layer.masksToBounds = YES;
        
        
        
        [self.leftTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.height.equalTo(self.mas_height);
            make.top.equalTo(self.mas_top);
            make.width.mas_equalTo(90);
        }];
        
        [self.captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset(2.5);
            make.bottom.equalTo(self.mas_bottom).offset(-2.5);
            make.right.equalTo(self.mas_right).offset(-18);
            make.width.mas_equalTo(110);

        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.height.equalTo(self);
            make.left.equalTo(self.leftTitleLbl.mas_right).offset(17);
            make.top.equalTo(self.mas_top).offset(2.5);
            make.bottom.equalTo(self.mas_bottom).offset(-2.5);
            make.right.equalTo(self.captchaBtn.mas_left).offset(-15);
        }];
        
        //
    }
    return self;
}

@end
