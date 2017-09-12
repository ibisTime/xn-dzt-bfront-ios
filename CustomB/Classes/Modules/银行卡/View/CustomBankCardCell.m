//
//  CustomBankCardCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CustomBankCardCell.h"
#import <Masonry/Masonry.h>
#import "UILable+convience.h"
#import "UIColor+theme.h"
#import "UIColor+Extension.h"

@interface CustomBankCardCell()

@property (nonatomic, strong) UIView *bgView;
//@property (nonatomic, strong) UILabel *bankNameLbl;
//@property (nonatomic, strong) UILabel *markLbl;
//@property (nonatomic, strong) UILabel *bankCardNumLbl;

@end

@implementation CustomBankCardCell

- (void)data {

    self.bankNameLbl.text = @"建设银行";
    self.markLbl.text = @"借记卡";
    self.bankCardNumLbl.text = @"43*********54";

}

- (void)setBankCard:(ZHBankCard *)bankCard {

    _bankCard = bankCard;
    self.bankNameLbl.text = bankCard.bankName;
    self.markLbl.text = @"借记卡";
    if (bankCard.bankcardNumber.length > 4) {
        
     NSString *shortNum = [NSString stringWithFormat:@"%@**************%@",[bankCard.bankcardNumber substringToIndex:2],[bankCard.bankcardNumber substringFromIndex:bankCard.bankcardNumber.length - 2 ]];
        
        self.bankCardNumLbl.text = shortNum;

    
    } else {
    
        self.bankCardNumLbl.text = bankCard.bankcardNumber;

    }
    

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#4d4d4d"].CGColor;
        self.bgView.layer.borderWidth = 0.7;
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        //
        self.bankNameLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:[UIFont systemFontOfSize:12]
                                         textColor:[UIColor colorWithHexString:@"#4d4d4d"]];
        [self.bgView addSubview:self.bankNameLbl];
        
        //
        self.markLbl = [UILabel labelWithFrame:CGRectZero
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:[UIFont systemFontOfSize:12]
                                         textColor:[UIColor colorWithHexString:@"#4d4d4d"]];
        [self.bgView addSubview:self.markLbl];
        
        //
        self.bankCardNumLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont systemFontOfSize:12]
                                     textColor:[UIColor colorWithHexString:@"#4d4d4d"]];
        [self.bgView addSubview:self.bankCardNumLbl];
        
        //
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(18);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-18);
            make.bottom.equalTo(self.contentView.mas_bottom);

        }];
        
        [self.bankNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(26);
            make.centerY.equalTo(self.bgView.mas_centerY);
        }];
        
        //卡类型
        [self.markLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-30);
            make.bottom.equalTo(self.bgView.mas_centerY).offset(-5);
        }];
        
        //
        [self.bankCardNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.markLbl.mas_right);
            make.top.equalTo(self.bgView.mas_centerY).offset(5);
            
        }];
        
    }
    //
    [self data];
    return self;
}

@end
