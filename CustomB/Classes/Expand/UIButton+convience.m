//
//  UIButton+convience.m
//  WeRide
//
//  Created by  tianlei on 2016/12/5.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "UIButton+convience.h"
#import "UIColor+theme.h"
#import "UIColor+Extension.h"


@implementation UIButton (convience)


- ( instancetype )initWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)color  cornerRadius:(CGFloat)cornerRadius  {

    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:color forState:UIControlStateNormal];
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
        [self setTitle:title forState:UIControlStateNormal];
    }
    
    return self;

}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state{

    [self setBackgroundImage:[color convertToImage] forState:state];

}

- ( instancetype )initWithFrame:(CGRect)frame
                title:(NSString *)title
      backgroundColor:(UIColor *)color {

    if(self = [super initWithFrame:frame]) {
    
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundColor:color forState:UIControlStateNormal];

    }
    
    return self;
    

}

+ (UIButton *)zhBtnWithFrame:(CGRect) frame title:(NSString *)title {

    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setBackgroundColor:[UIColor themeColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    return btn;

}

+ (UIButton *)borderBtnWithFrame:(CGRect)frame title:(NSString *)title borderColor:(UIColor *)borderColor {

    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = borderColor.CGColor;
    btn.clipsToBounds = YES;
    return btn;


}


@end
