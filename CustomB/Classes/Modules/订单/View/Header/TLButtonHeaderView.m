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

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
//                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero
//                                                          title:@"确定"
//                                                backgroundColor:[UIColor themeColor]
//                                                   cornerRadius:10];
//                [self addSubview:btn];
//        
                [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
        self.btn = btn;
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = [UIColor themeColor];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.mas_left).offset(30);
                    make.right.equalTo(self.mas_right).offset(-30);
                    make.bottom.equalTo(self.mas_bottom).offset(-20);
                    make.height.mas_equalTo(35);
        
                }];
        
    }
    
    return self;
}

+ (NSString *)headerReuseIdentifier {
    
    
    return     [NSString stringWithFormat:@"%@ID",NSStringFromClass(self)];
    
}

- (void)setTitle:(NSString *)title {

    _title = [title copy];
    [self.btn setTitle:_title forState:UIControlStateNormal];
    
}

//
- (void)action {

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelected:section:)]) {
        
        [self.delegate didSelected:self section:self.section];
        
    }
    //
}

@end
