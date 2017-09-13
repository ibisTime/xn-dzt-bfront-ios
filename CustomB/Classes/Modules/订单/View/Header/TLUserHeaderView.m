//
//  TLUserHeaderView.m
//  CustomB
//
//  Created by  tianlei on 2017/8/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUserHeaderView.h"
#import "UILable+convience.h"
#import "UIColor+theme.h"
#import <Masonry/Masonry.h>

@implementation TLUserHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentCenter
                                  backgroundColor:[UIColor themeColor]
                                             font:[UIFont systemFontOfSize:16]
                                        textColor:[UIColor whiteColor]];
        [self addSubview:self.contentLbl];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
    }
    
    return self;
    
}

+ (NSString *)headerReuseIdentifier {
    
    return [NSString stringWithFormat:@"%@ID",NSStringFromClass(self)];
    
}

- (void)setTitle:(NSString *)title {
    
    _title = [title copy];
    self.contentLbl.text = _title;
}

@end
