//
//  TLOrderCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderCell.h"
#import "TLUIHeader.h"
#import "TLStatusView.h"

@interface TLOrderCell()

@property (nonatomic, strong) UILabel *codeLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *userInfoLbl;
@property (nonatomic, strong) UILabel *productInfoLbl;
@property (nonatomic, strong) TLStatusView *statusView;

@end


@implementation TLOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        
    }
    
    [self data];
    
    return self;
}

+ (CGFloat)defaultCellHeight {

    return 105;

}

- (void)data {

    self.codeLbl.text = @"DD2131221";
    self.timeLbl.text = @"2017-2-3";
    
    //
    self.userInfoLbl.text = @"田磊|13830890482";
    self.productInfoLbl.text = @"衬衫|￥500";
    //
    self.statusView.backgroundColor = [UIColor colorWithHexString:@"#dab616"];
    self.statusView.contentLbl.text=  @"新单";
    self.statusView.contentLbl.text=  @"待量体";


}

- (void)setUpUI {
    
    //顶线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:topLine];

    //订单号
    self.codeLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(12)
                                 textColor:[UIColor textColor]];
    [self.contentView addSubview:self.codeLbl];
    
    //
    self.timeLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentRight
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(12)
                                 textColor:[UIColor textColor]];
    [self.contentView addSubview:self.timeLbl];
    
    //用户信息
    self.userInfoLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(12)
                                 textColor:[UIColor textColor]];
    [self.contentView addSubview:self.userInfoLbl];
    
    //
    self.productInfoLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(12)
                                 textColor:[UIColor textColor]];
    [self.contentView addSubview:self.productInfoLbl];
    
    //
    self.statusView = [[TLStatusView alloc] init];
    [self.contentView addSubview:self.statusView];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.right.equalTo(self.contentView.mas_right).offset(-18);

    }];
    
    [self.codeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(17);
        make.left.equalTo(self.contentView.mas_left).offset(35);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(17);
        make.right.equalTo(self.contentView.mas_right).offset(-35);
    }];
    
    [self.userInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLbl.mas_bottom).offset(13);
        make.left.equalTo(self.codeLbl.mas_left);
    }];
    
    [self.productInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userInfoLbl.mas_top);
        make.right.equalTo(self.timeLbl.mas_right);
    }];
    
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeLbl.mas_left);
        make.top.equalTo(self.userInfoLbl.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-17);
        make.height.equalTo(@18);
    }];

}


@end
