//
//  TLColorChooseCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLColorChooseCell.h"
#import "TLUIHeader.h"
#import "TLParameterModel.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"
#import "ImageUtil.h"
#import "AppConfig.h"


@interface TLColorChooseCell()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *markImageView;


@end


@implementation TLColorChooseCell

+ (NSString *)cellReuseIdentifier {
    
    return @"TLColorChooseCellID";
    
}

- (void)setModel:(id)model {
    
    [super setModel:model];
    
    TLParameterModel *parameterModel = model;
    
    NSString *str = [ImageUtil convertImageUrl:parameterModel.pic imageServerUrl:[AppConfig config].qiniuDomain];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:str]];
    if (parameterModel.yuSelected) {
        
        self.markImageView.hidden = NO;
        
    } else {
        
        self.markImageView.hidden = YES;
        
    }
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor backgroundColor];
        self.contentView.backgroundColor =  [UIColor backgroundColor];
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.bgImageView];
        self.bgImageView.layer.cornerRadius = 5;
        self.bgImageView.backgroundColor = [UIColor whiteColor];
        self.bgImageView.layer.masksToBounds = YES;
        
        //
        self.markImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.markImageView];
        self.markImageView.image = [UIImage imageNamed:@"颜色选中"];
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 6, 0, 6));
        }];
        
        [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);

        }];
        
        //
        
        
    }
    return self;
}

@end
