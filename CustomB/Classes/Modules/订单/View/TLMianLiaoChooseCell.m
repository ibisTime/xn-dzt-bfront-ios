//
//  TLMianLiaoChooseCell.m
//  CustomB
//
//  Created by  tianlei on 2017/9/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLMianLiaoChooseCell.h"
#import "TLUIHeader.h"
#import "TLMianLiaoModel.h"
#import <CDCommon/ImageUtil.h>
#import "AppConfig.h"
#import "UIImageView+WebCache.h"


@interface TLMianLiaoChooseCell ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UIImageView *selectMarkImageView;


@end


@implementation TLMianLiaoChooseCell


- (void)setMianLiaoModel:(TLMianLiaoModel *)mianLiaoModel {

    _mianLiaoModel = mianLiaoModel;
    
    NSString *str = [ImageUtil convertImageUrl:_mianLiaoModel.advPic imageServerUrl:[AppConfig config].qiniuDomain];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:str]];
    self.nameLbl.text = _mianLiaoModel.modelNum;
    

    
    
    if (_mianLiaoModel.isSelected) {
        
        self.selectMarkImageView.hidden = NO;
        
    } else {
        
        self.selectMarkImageView.hidden = YES;
        
    }
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.bgImageView];
        self.bgImageView.layer.cornerRadius = 5;
        self.bgImageView.backgroundColor = [UIColor whiteColor];
        self.bgImageView.layer.masksToBounds = YES;
        self.bgImageView.layer.borderColor = [UIColor colorWithHexString:@"#a0a0a0"].CGColor;
        self.bgImageView.layer.borderWidth = 0.8;
        
        //
        self.selectMarkImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.selectMarkImageView];
        self.selectMarkImageView.backgroundColor = [UIColor clearColor];
        self.selectMarkImageView.layer.cornerRadius = self.bgImageView.layer.cornerRadius;
        self.selectMarkImageView.layer.masksToBounds = YES;
        self.selectMarkImageView.layer.borderColor = [UIColor themeColor].CGColor;
        self.selectMarkImageView.layer.borderWidth = 2;
        
        //
        self.nameLbl = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLbl];
        self.nameLbl.textAlignment = NSTextAlignmentCenter;
        self.nameLbl.textColor = [UIColor themeColor];
        self.nameLbl.numberOfLines = 0;
        self.nameLbl.font = [UIFont systemFontOfSize:12];
        
        //
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.centerX.equalTo(self.contentView.mas_centerX);
            
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(70);
            
        }];
        
        //
        [self.selectMarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.right.bottom.equalTo(self.bgImageView);
            
        }];
        
        //
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgImageView.mas_bottom);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.left.right.equalTo(self.contentView);
        }];
        
    }
    
    [self data];
    return self;
    
}

- (void)data {

    self.nameLbl.text = @"123445";
    
}


+ (NSString *)cellReuseIdentifier {

    return [NSString stringWithFormat:@"%@%@",NSStringFromClass(self),@"ID"];
    
}

@end
