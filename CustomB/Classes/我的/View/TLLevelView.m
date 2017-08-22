//
//  TLLevelView.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLLevelView.h"
#import "TLUIHeader.h"

@implementation TLLevelView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#dab616"];
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentRight
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(11)
                                        textColor:[UIColor whiteColor]];
        [self addSubview:self.contentLbl];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(3);
            make.right.equalTo(self.mas_right).offset(-3);
            make.top.bottom.equalTo(self);
        }];
        
    }
    return self;
}



- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    [super setBackgroundColor:backgroundColor];
    self.contentLbl.backgroundColor = backgroundColor;
}

@end
