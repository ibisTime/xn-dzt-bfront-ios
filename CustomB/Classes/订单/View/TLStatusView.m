//
//  TLStatusView.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLStatusView.h"
#import "TLUIHeader.h"

@implementation TLStatusView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(12)
                                     textColor:[UIColor whiteColor]];
        [self addSubview:self.contentLbl];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(9);
            make.right.equalTo(self.mas_right).offset(-9);
            make.top.bottom.equalTo(self);
        }];
    
    }
    return self;
}

- (void)setType:(TLStatusViewType)type {

    if (type == TLStatusViewTypeYellow) {
        
//       self.backgroundColor = [UIColor colorWithHexString:@"#dab616"];
       self.backgroundColor = [UIColor customYellowColor];
        
    } else if (type == TLStatusViewTypeTheme) {
        
       self.backgroundColor = [UIColor themeColor];

    }
    

}

- (void)layoutSubviews {

    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.height/2.0;

}

- (void)setBackgroundColor:(UIColor *)backgroundColor {

    [super setBackgroundColor:backgroundColor];
    self.contentLbl.backgroundColor = backgroundColor;
}

@end
