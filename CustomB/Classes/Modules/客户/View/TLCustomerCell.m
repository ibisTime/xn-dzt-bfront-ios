//
//  TLOrderCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLCustomerCell.h"
#import "TLUIHeader.h"
#import "TLStatusView.h"
#import "TLCustomer.h"
#import "NSString+Extension.h"
#import "TLUser.h"

@interface TLCustomerCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topBgView;

//
@property (nonatomic, strong) UILabel *masterLbl;
@property (nonatomic, strong) UILabel *timeLbl;

//
@property (nonatomic, strong) UILabel *userInfoLbl;
@property (nonatomic, strong) UILabel *vipTypeLbl;

//
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *customerTypeLbl;

@end

@implementation TLCustomerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
//    [self data];
    
    return self;
    
}

+ (CGFloat)defaultCellHeight {

    return 105;
}


- (void)setCustomer:(TLCustomer *)customer {

    _customer = customer;
    
    self.masterLbl.text = [TLUser user].realName;
//    [tluse]_customer.nickname;
    
    if (_customer.lastOrderDatetime) {
        
        self.timeLbl.text = [NSString stringWithFormat:@"最近下单时间：%@",[_customer.lastOrderDatetime convertToDetailDate]];

    } else {
    
        self.timeLbl.text = nil;

    
    }
    // _customer.realName ? : _customer.nickname
    self.userInfoLbl.text = [NSString stringWithFormat:@"%@|%@", _customer.nickname,_customer.mobile? : @""];
    self.vipTypeLbl.text = [_customer getVipName];
    self.addressLbl.text = [_customer getDetailAddress];
    self.customerTypeLbl.text = [_customer getCustomerTitle];
    
    
}


//- (void)data {
//    
//    self.masterLbl.text = @"AVVFDDD";
//    self.timeLbl.text = [NSString stringWithFormat:@"最近下单时间：%@",@"2017-09-08"];
//    //
//    self.userInfoLbl.text = @"田磊|13830890482";
//    self.vipTypeLbl.text = @"银卡会员";
//    
//    self.addressLbl.text = @"浙江省温州市乐清市";
//    self.customerTypeLbl.text = @"老客户";
//    
//    
//    
//}

- (void)setUpUI {
    
    
    
    //订单号
    self.bgView = [[UIView alloc] init];
    [self.contentView addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#9f9f9f"].CGColor;
    self.bgView.layer.borderWidth = 0.5;
    
    //
    self.topBgView = [[UIView alloc] init];
    [self.bgView addSubview:self.topBgView];
    self.topBgView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    //    self.topBgView.layer.masksToBounds = YES;
    //    self.topBgView.layer.cornerRadius = 10;
    
    
    //
    self.masterLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentRight
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(12)
                                 textColor:[UIColor textColor]];
    [self.topBgView addSubview:self.masterLbl];
    
    self.timeLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentRight
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(12)
                                 textColor:[UIColor textColor]];
    [self.topBgView addSubview:self.timeLbl];
    
    
    
    //用户信息
    self.userInfoLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor textColor]];
    [self.bgView addSubview:self.userInfoLbl];
    
    self.vipTypeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor textColor]];
    [self.bgView addSubview:self.vipTypeLbl];
    
    //
    self.addressLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor textColor]];
    [self.bgView addSubview:self.addressLbl];
    
    self.customerTypeLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor clearColor]
                                         font:FONT(12)
                                    textColor:[UIColor textColor]];
    [self.bgView addSubview:self.customerTypeLbl];
    


    //
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(28);
    }];
    
    
    [self.masterLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBgView.mas_left).offset(16);
        make.centerY.equalTo(self.topBgView.mas_centerY);
    }];
    
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topBgView.mas_right).offset(-16);
        make.centerY.equalTo(self.topBgView.mas_centerY);
    }];
    
    
    [self.masterLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBgView.mas_left).offset(16);
        make.centerY.equalTo(self.topBgView.mas_centerY);
    }];
    
    //
    [self.userInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.top.equalTo(self.topBgView.mas_bottom).offset(10);
    }];
    
    [self.vipTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.top.equalTo(self.userInfoLbl.mas_top);
    }];
    
    //
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userInfoLbl.mas_left);
        make.top.equalTo(self.vipTypeLbl.mas_bottom).offset(13);
    }];
    
    [self.customerTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vipTypeLbl.mas_right);
        make.top.equalTo(self.addressLbl.mas_top);
    }];
    
    
    
    
    
    
}


@end
