//
//  TLHomeTableHeaderView.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLHomeTableHeaderView.h"
#import "TLUIHeader.h"

@implementation TLHomeTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor themeColor]];
        [self.contentView addSubview:self.titleLbl];
        
        UILabel *actionNameLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor colorWithHexString:@"#b0b0b0"]];
        [self.contentView addSubview:actionNameLbl];
        
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(19.5);
            make.centerY.equalTo(self.contentView.mas_centerY);

        }];
        
        [actionNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).offset(-19.5);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
        
        actionNameLbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [actionNameLbl addGestureRecognizer:tap];
        
        
        actionNameLbl.text = @"查看全部";
        
        
    }
    
    return self;


}

- (void)tap {

    if (self.action) {
        self.action(self.section);
    }

}

@end
