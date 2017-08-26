//
//  CustomInputView.h
//  CustomB
//
//  Created by  tianlei on 2017/8/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInputView : UIView

@property (nonatomic, strong) UILabel *leftTitleLbl;
@property (nonatomic, strong) UITextField *textField;

- (instancetype)initWithFrame:(CGRect)frame;

@end
