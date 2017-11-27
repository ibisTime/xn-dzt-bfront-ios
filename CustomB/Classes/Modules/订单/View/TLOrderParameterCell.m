//
//  TLOrderParameterCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderParameterCell.h"
#import "TLUIHeader.h"
#import "TLParameterModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"
#import "ImageUtil.h"
#import "AppConfig.h"

@interface TLOrderParameterCell()

@property (nonatomic, strong) UIImageView *bgImageView;
//@property (nonatomic, strong) UIImageView *selectMarkImageView;
@property (nonatomic, strong) UIImageView *selectMarkImageView;
//@property (nonatomic, strong) UILabel *testLbl;

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation TLOrderParameterCell

+ (NSString *)cellReuseIdentifier {
    
    return @"TLOrderParameterCellID";
    
}

- (void)setModel:(id)model {

    [super setModel:model];
    
    TLParameterModel *parameterModel = model;
    
    NSString *str = [ImageUtil convertImageUrl:parameterModel.pic imageServerUrl:[AppConfig config].qiniuDomain];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:str]];
    
    self.titleLbl.text = parameterModel.name;
//    self.testLbl.text = [parameterModel.price stringValue];

    
        self.selectMarkImageView.layer.cornerRadius = 10;
        self.selectMarkImageView.layer.masksToBounds = YES;
        self.selectMarkImageView.layer.borderColor = [UIColor themeColor].CGColor;
        self.selectMarkImageView.layer.borderWidth = 2;

    
    if (parameterModel.yuSelected) {
        
        self.selectMarkImageView.hidden = NO;
        self.selectMarkImageView.layer.borderWidth = 2;
        if (parameterModel.selectPic) {
            
            NSString *selectPicStr = [ImageUtil convertImageUrl:parameterModel.selectPic imageServerUrl:[AppConfig config].qiniuDomain];
            [self.selectMarkImageView sd_setImageWithURL:[NSURL URLWithString:selectPicStr]];
            self.selectMarkImageView.layer.borderWidth = 0;

        }
        
    } else {
        
        self.selectMarkImageView.hidden = YES;
        
        
    }
    
    self.backgroundColor = [UIColor orangeColor];
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor backgroundColor];
        self.contentView.backgroundColor = [UIColor backgroundColor];
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [self.contentView addSubview:self.bgImageView];
        self.bgImageView.layer.cornerRadius = 10;
        self.bgImageView.backgroundColor = [UIColor whiteColor];
        self.bgImageView.layer.masksToBounds = YES;
        self.bgImageView.layer.borderColor = [UIColor colorWithHexString:@"#a0a0a0"].CGColor;
        self.bgImageView.layer.borderWidth = 0.8;
        
        //
        self.selectMarkImageView = [[UIImageView alloc] initWithFrame:self.bgImageView.frame];
        [self.contentView addSubview:self.selectMarkImageView];
        self.selectMarkImageView.backgroundColor = [UIColor clearColor];
        
        //
        self.titleLbl = [UILabel labelWithFrame:CGRectMake(0, self.bgImageView.yy, self.width, TLOrderParameterCellBottomH) textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(12)
                                      textColor:[UIColor themeColor]];
   
        [self.contentView addSubview:self.titleLbl];
        self.titleLbl.numberOfLines = 0;
//        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self);
//            make.top.eq
//        }];
//        self.selectMarkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [self.bgImageView addSubview:self.selectMarkImageView];
//        
//        self.selectMarkImageView.image = [UIImage imageNamed:@"规格选中"];
//        [self.selectMarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.bottom.equalTo(self.bgImageView);
//        }];
        

//        UILabel *testLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//        testLbl.textColor = [UIColor blackColor];
//        self.testLbl = testLbl;
//        [self addSubview:testLbl];
    }
    
    return self;
}



@end
