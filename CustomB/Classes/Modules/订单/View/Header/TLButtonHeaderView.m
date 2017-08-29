//
//  TLButtonHeaderView.m
//  CustomB
//
//  Created by  tianlei on 2017/8/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLButtonHeaderView.h"
#import "UIButton+convience.h"
#import "UIColor+theme.h"
#import <Masonry/Masonry.h>

@interface TLButtonHeaderView()

@property (nonatomic, strong) UIButton *btn;

@end


@implementation TLButtonHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero
                                                  title:@"确定"
                                        backgroundColor:[UIColor themeColor]
                                           cornerRadius:10];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {

    _title = [title copy];
    [self.btn setTitle:title forState:UIControlStateNormal];
    
}

- (void)action {

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelected:section:)]) {
        
        [self.delegate didSelected:self section:self.section];
        
    }
    //
}

@end
