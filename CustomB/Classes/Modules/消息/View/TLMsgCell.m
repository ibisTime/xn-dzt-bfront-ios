//
//  TLOrderCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLMsgCell.h"
#import "TLUIHeader.h"
#import "TLStatusView.h"
#import "NSString+Extension.h"

@interface TLMsgCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UILabel *userInfoLbl;
@property (nonatomic, strong) UILabel *timeLbl;

@property (nonatomic, strong) UILabel *contentLbl;


@end


@implementation TLMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        
        
    }
    
    
    return self;
}

- (void)setSysMsg:(TLSysMsg *)sysMsg {

    _sysMsg = sysMsg;
    self.timeLbl.text = [_sysMsg.createDatetime convertToDetailDate];
    self.userInfoLbl.text = _sysMsg.smsTitle;
    self.contentLbl.text = _sysMsg.smsContent;
    
}


//这里是留言
- (void)setModel:(CustomLiuYanModel *)model {

    _model = model;

    self.timeLbl.text = [model.commentDatetime convertToDetailDate];
    
    if (_model.chatType == ChatModelTypeMe) {
        
        if (!model.receiveMobile) {
            
            self.userInfoLbl.text = model.receiveName;
            
        } else {
            
            self.userInfoLbl.text = [NSString stringWithFormat:@"%@|%@",model.receiveName,model.receiveMobile];
            
        }
  
        //
    } else {
    
        if (!model.commentMobile) {
            
            self.userInfoLbl.text = model.commentName;
            
        } else {
            
            self.userInfoLbl.text = [NSString stringWithFormat:@"%@|%@",model.commentName,model.commentMobile];
            
        }
        
    }

    
    //
    self.contentLbl.text = _model.content;
}

- (void)data {
    
    self.timeLbl.text = @"2017-2-3";
    //
    self.userInfoLbl.text = @"田磊|13830890482";
    self.contentLbl.text = @"Developer Program Membership Expired Expired 开发商计划成员资格过期失效 . ----------------------------------- 为你解答,如有帮助请...";

    
    
}

- (void)setUpUI {
    

    
    //订单号
    self.bgView = [[UIView alloc] init];
    [self.contentView addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor backgroundColor];
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
    
    
    //用户信息
    self.userInfoLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor textColor]];
    [self.topBgView addSubview:self.userInfoLbl];
    
    //
    self.timeLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentRight
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(12)
                                 textColor:[UIColor textColor]];
    [self.topBgView addSubview:self.timeLbl];
    

    
    //
    self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:FONT(12)
                                        textColor:[UIColor textColor]];
    [self.bgView addSubview:self.contentLbl];
    self.contentLbl.numberOfLines = 0;
    
    
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
    
    
    [self.userInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBgView.mas_left).offset(16);
        make.centerY.equalTo(self.topBgView.mas_centerY);
    }];
    
 
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topBgView.mas_right).offset(-16);
        make.centerY.equalTo(self.topBgView.mas_centerY);
    }];
    
 
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topBgView.mas_bottom).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-10);
        
    }];
    
    

    
}


@end
