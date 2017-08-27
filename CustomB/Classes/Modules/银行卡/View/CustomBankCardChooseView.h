//
//  CustomBankCardChooseView.h
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLPickerTextField;

@interface CustomBankCardChooseView : UIView


@property (nonatomic, strong) UILabel *leftTitleLbl;
@property (nonatomic, strong) TLPickerTextField *textField;

- (instancetype)initWithFrame:(CGRect)frame;

@end
