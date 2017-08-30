//
//  TLPriceHeaderView.m
//  CustomB
//
//  Created by  tianlei on 2017/8/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLPriceHeaderView.h"
#import "UIColor+theme.h"
#import "TLUIHeader.h"
#import "TLGroup.h"


@interface TLPriceHeaderView()


@end

@implementation TLPriceHeaderView


+ (NSString *)headerReuseIdentifier {
    
    return [NSString stringWithFormat:@"%@ID",NSStringFromClass(self)];
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
//        self.titleLbl.text = @"着装风格";

    }
    return self;
}

- (void)action {

    if (self.delegate) {
        
        [self.delegate didSelected:self.section];
        
    }

}


- (void)setGroup:(TLGroup *)group {

    _group = group;
    self.titleLbl.text = group.title;
    
    self.contentLbl.text = _group.content;
    self.titleLbl.text = _group.title;
    self.arrowImageView.hidden = !_group.canEdit;
}


- (void)setUpUI {
    
    self.backgroundColor = [UIColor backgroundColor];
    
    self.titleLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor clearColor]
                                       font:FONT(14)
                                  textColor:[UIColor themeColor]];
    
    [self addSubview:self.titleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(18);
        
    }];
    
    //
    self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor clearColor]
                                         font:FONT(14)
                                    textColor:[UIColor textColor]];
    
    [self addSubview:self.contentLbl];
    self.contentLbl.text = @"--";
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(90);
        
    }];
    
    //
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多"]];
    [self addSubview:self.arrowImageView];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-18);
    }];

    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#9f9f9f"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.right.equalTo(self.mas_right).offset(-18);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    //
    UIButton *btn = [[UIButton alloc] init];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
}



@end
