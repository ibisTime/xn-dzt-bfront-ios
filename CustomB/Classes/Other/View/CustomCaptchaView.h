//
//  CustomCaptchaView.h
//  CustomB
//
//  Created by  tianlei on 2017/8/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTimeButton.h"

@interface CustomCaptchaView : UIView

@property (nonatomic, strong) UILabel *leftTitleLbl;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic,strong) TLTimeButton *captchaBtn;


- (instancetype)initWithFrame:(CGRect)frame;

@end
