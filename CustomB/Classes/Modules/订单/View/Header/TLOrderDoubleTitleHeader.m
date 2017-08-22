//
//  TLOrderDoubleTitleHeader.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderDoubleTitleHeader.h"
#import "TLUIHeader.h"

@interface TLOrderDoubleTitleHeader()


@property (nonatomic, strong) UILabel *topLbl;
@property (nonatomic, strong) UILabel *bottomLbl;

@end

@implementation TLOrderDoubleTitleHeader

+ (NSString *)headerReuseIdentifier {
    
    
    return @"TLOrderDoubleTitleHeaderID";
    
}

- (void)setTitle:(NSString *)title {

    _title  = [title copy];
    
    self.topLbl.text = title;
    self.bottomLbl.text = title;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.topLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(14)
                                      textColor:[UIColor themeColor]];
        
        [self addSubview:self.topLbl];
        
        [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(14);
            make.left.equalTo(self.mas_left).offset(34);
            
        }];
        //
        self.bottomLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor themeColor]
                                           font:FONT(14)
                                      textColor:[UIColor whiteColor]];
        
        [self addSubview:self.bottomLbl];
        self.bottomLbl.layer.cornerRadius = 5;
        self.bottomLbl.layer.masksToBounds = YES;
        
        [self.bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topLbl.mas_bottom).offset(14);
            make.height.mas_equalTo(30);
            make.bottom.equalTo(self.mas_bottom);

            make.left.equalTo(self.mas_left).offset(18);
            make.right.equalTo(self.mas_right).offset(-18);
            
        }];
        
        
        
        
        
    }
    return self;
}

@end
