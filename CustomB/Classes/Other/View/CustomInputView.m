//
//  CustomInputView.m
//  CustomB
//
//  Created by  tianlei on 2017/8/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CustomInputView.h"
#import "UILable+convience.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

@implementation CustomInputView

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
        [self.leftTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.height.equalTo(self.mas_height);
            make.top.equalTo(self.mas_top);
            make.width.mas_equalTo(90);
        }];
        
        //
        UIView *textFieldBgView = [[UIView alloc] init];
        [self addSubview:textFieldBgView];
        textFieldBgView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        textFieldBgView.layer.borderColor = [UIColor colorWithHexString:@"#9d9d9d"].CGColor;
        textFieldBgView.layer.borderWidth = 0.7;
        textFieldBgView.layer.cornerRadius = 5;
        textFieldBgView.layer.masksToBounds = YES;
        [textFieldBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.height.equalTo(self);
            make.left.equalTo(self.leftTitleLbl.mas_right).offset(17);
            make.top.equalTo(self.mas_top).offset(2.5);
            make.bottom.equalTo(self.mas_bottom).offset(-2.5);
            make.right.equalTo(self.mas_right).offset(-18);
        }];
        
        
        self.textField = [[UITextField alloc] init];
        [textFieldBgView addSubview:self.textField];
        self.textField.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        self.textField.font = [UIFont systemFontOfSize:14];
//        self.textField.layer.borderColor = [UIColor colorWithHexString:@"#9d9d9d"].CGColor;
//        self.textField.layer.borderWidth = 0.7;
//        self.textField.layer.cornerRadius = 5;
//        self.textField.layer.masksToBounds = YES;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.leftTitleLbl.mas_right).offset(17);
//            make.top.equalTo(self.mas_top).offset(2.5);
//            make.bottom.equalTo(self.mas_bottom).offset(-2.5);
//            make.right.equalTo(self.mas_right).offset(-18);
//        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textFieldBgView.mas_left);
            make.top.equalTo(textFieldBgView.mas_top);
            make.bottom.equalTo(textFieldBgView.mas_bottom);
            make.right.equalTo(textFieldBgView.mas_right);
        }];
        
    }
    return self;
}

@end
