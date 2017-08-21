//
//  TLSearchView.h
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLSearchView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *searchBtn;
@end
