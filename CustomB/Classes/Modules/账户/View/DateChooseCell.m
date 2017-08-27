//
//  ZHSettingUpCell.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "DateChooseCell.h"
#import "TLUIHeader.h"

@interface DateChooseCell()


@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel *subTextLbl;


@end

@implementation DateChooseCell


+ (CGFloat)defaultCellHeight {
    
    return 58;
}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.leftImageView = [[UIImageView alloc] init];
        [self addSubview:self.leftImageView];
        self.leftImageView.image = [UIImage imageNamed:@"账单"];
        
        
        UIColor *textColor = [UIColor colorWithHexString:@"#4d4d4d"];
        
        //
        self.textLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(14)
                                     textColor:textColor];
        [self addSubview:self.textLbl];
        
        //
        self.subTextLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(14)
                                        textColor:textColor];
        [self addSubview:self.subTextLbl];
        
        
        //
        UIImageView *arrow =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多"]];
        [self addSubview:arrow];
        arrow.contentMode = UIViewContentModeScaleAspectFit;
        
        //
        
        
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@18);
            make.height.equalTo(@18);
            make.left.equalTo(self.mas_left).offset(57);
            make.centerY.equalTo(self);
        }];
        
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImageView.mas_right).offset(20);
            make.centerY.equalTo(self);
        }];
        
        
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-29);
            make.centerY.equalTo(self);
            
        }];
        
        [self.subTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrow.mas_left).offset(-12);
            make.centerY.equalTo(self);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#a1a1a1"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(18);
            make.right.equalTo(self.mas_right).offset(-18);
            make.height.mas_equalTo(@0.5);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    
    return self;
}




@end
