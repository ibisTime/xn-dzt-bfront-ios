//
//  TLOrderBGTitleHeader.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderBGTitleHeader.h"
#import "TLUIHeader.h"

@implementation TLOrderBGTitleHeader


+ (NSString *)headerReuseIdentifier {
    
    
    return @"TLOrderBGTitleHeaderID";
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor themeColor]
                                           font:FONT(14)
                                      textColor:[UIColor whiteColor]];
        
        [self addSubview:self.titleLbl];
        self.titleLbl.layer.cornerRadius = 5;
        self.titleLbl.layer.masksToBounds = YES;
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(15);
            make.left.equalTo(self.mas_left).offset(18);
            make.right.equalTo(self.mas_right).offset(-18);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
        
  
        
    }
    return self;
}

@end
