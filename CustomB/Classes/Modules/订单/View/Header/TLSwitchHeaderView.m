//
//  TLSwitchHeaderView.m
//  CustomB
//
//  Created by  tianlei on 2017/9/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLSwitchHeaderView.h"
#import "UIColor+theme.h"
#import "UIColor+Extension.h"

#define SELECTED_TITLE_COLOR [UIColor colorWithHexString:@"a89300"]
#define NORMAL_TITLE_COLOR [UIColor whiteColor]

@interface TLSwitchHeaderView ()

@property (nonatomic, strong) UIButton *lastBtn;

@end

@implementation TLSwitchHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor themeColor];
        [self data];
    }
    
    return self;
    
}

- (void)data {
    
    
    
    
    NSInteger num = 3;
    CGFloat width = self.frame.size.width/num;
    for (int i = 0; i <= num ; i ++) {
        
        CGFloat x = i*width;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, self.frame.size.height)];
        [self addSubview:btn];
        
        [btn setTitleColor:NORMAL_TITLE_COLOR forState:UIControlStateNormal];
        if (i == 0) {
            self.lastBtn = btn;
            [btn setTitleColor:SELECTED_TITLE_COLOR forState:UIControlStateNormal];
        }
        
        btn.tag = 100 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textColor = [UIColor whiteColor];
        [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        
    }

}

//
+ (NSString *)headerReuseIdentifier {
    
    return  [NSString stringWithFormat:@"%@ID",NSStringFromClass(self)];
    
}

//
- (void)action:(UIButton *)btn {

    [self.lastBtn setTitleColor:NORMAL_TITLE_COLOR forState:UIControlStateNormal];
    [btn setTitleColor:SELECTED_TITLE_COLOR forState:UIControlStateNormal];
    self.lastBtn = btn;

    //
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSwitchWith:selectedIdx:)]) {
        
        [self.delegate didSwitchWith:self selectedIdx:btn.tag - 100];
        
    }

}

@end
