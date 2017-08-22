//
//  TLOrderInfoCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderInfoCell.h"
#import "TLUIHeader.h"

@implementation TLOrderInfoCell

+ (NSString *)cellReuseIdentifier {

    return @"TLOrderInfoCellID";

}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLbl = [UILabel labelWithFrame:CGRectMake(48, 10, 50, 20)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor backgroundColor]
                                           font:FONT(12)
                                      textColor:[UIColor themeColor]];
        [self.contentView addSubview:self.titleLbl];
        
    
        
        //
        self.contentLbl = [UILabel labelWithFrame:CGRectMake(self.titleLbl.right + 16,  self.titleLbl.y, SCREEN_WIDTH - self.titleLbl.right - 16 - 40, 20)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor backgroundColor]
                                             font:self.titleLbl.font
                                        textColor:[UIColor textColor]];
        [self.contentView addSubview:self.contentLbl];
        self.contentLbl.numberOfLines = 0;

        
    }
    [self data];
    return self;
}

- (void)data {

    self.titleLbl.text = @"订单编号";
    self.contentLbl.text = @"订单编号订单编号订单编号订单编号订单编号订单编号订单编号";

}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        
//        
//        //
//        
//        UIView *line = [[UIView alloc] init];
//        line.backgroundColor = [UIColor lineColor];
//        [self.contentView addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(15);
//            make.right.equalTo(self.mas_right).offset(-15);
//            make.height.mas_equalTo(0.5);
//            make.bottom.equalTo(self.mas_bottom);
//        }];
//        
//        //
//        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(15);
//            make.top.equalTo(self.contentView.mas_top).offset(10);
//            make.width.mas_equalTo(70);
//        }];
//        
//        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.titleLbl.mas_right).offset(15);
//            make.top.equalTo(self.titleLbl.mas_top);
//            make.right.equalTo(self.contentView.mas_right).offset(-15);
//            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-10);
//        }];
//        
//    }
//    
//    return self;
//    
//}



@end
