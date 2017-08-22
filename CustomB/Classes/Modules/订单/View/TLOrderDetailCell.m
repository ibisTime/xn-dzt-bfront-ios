//
//  TLOrderDetailCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderDetailCell.h"
#import "TLUIHeader.h"

@interface TLOrderDetailCell()



@end

@implementation TLOrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor textColor]];
        [self.contentView addSubview:self.titleLbl];
        
        //
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(14)
                                      textColor:[UIColor textColor]];
        [self.contentView addSubview:self.contentLbl];
        self.contentLbl.numberOfLines = 0;
        
        //
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        //
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.width.mas_equalTo(70);
        }];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl.mas_right).offset(15);
            make.top.equalTo(self.titleLbl.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-10);
        }];
        
    }
    
    return self;

}

@end
