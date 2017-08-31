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

@interface TLOrderParameterCell()

@property (nonatomic, strong) UIImageView *bgImageView;
//@property (nonatomic, strong) UIImageView *selectMarkImageView;
@property (nonatomic, strong) UIImageView *selectMarkImageView;

@property (nonatomic, strong) UILabel *testLbl;

@end

@implementation TLOrderParameterCell

+ (NSString *)cellReuseIdentifier {
    
    return @"TLOrderParameterCellID";
    
}

- (void)setModel:(id)model {

    [super setModel:model];
    
    TLParameterModel *parameterModel = model;
    NSString *str = [parameterModel.pic convertImageUrl];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:str]];
    
    self.testLbl.text = [parameterModel.price stringValue];
//    if (0 && parameterModel.yuSelected) {
//        
//        NSString *str = [parameterModel.selectPic convertImageUrl];
//        [self.selectMarkImageView sd_setImageWithURL:[NSURL URLWithString:str]];
//        self.selectMarkImageView.layer.cornerRadius = 0;
//        self.selectMarkImageView.layer.masksToBounds = NO;
//        self.selectMarkImageView.layer.borderWidth = 0;
//        
//    } else {
    
        self.selectMarkImageView.layer.cornerRadius = 10;
        self.selectMarkImageView.layer.masksToBounds = YES;
        self.selectMarkImageView.layer.borderColor = [UIColor themeColor].CGColor;
        self.selectMarkImageView.layer.borderWidth = 2;
    
//    }
    
    if (parameterModel.yuSelected) {
        
        self.selectMarkImageView.hidden = NO;
        
    } else {
        
        self.selectMarkImageView.hidden = YES;
        
    }
    
//    self.selectMarkImageView.hidden = !parameterModel.isSelected;
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor backgroundColor];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.bgImageView];
        self.bgImageView.layer.cornerRadius = 10;
        self.bgImageView.backgroundColor = [UIColor whiteColor];
        self.bgImageView.layer.masksToBounds = YES;
        self.bgImageView.layer.borderColor = [UIColor colorWithHexString:@"#a0a0a0"].CGColor;
        self.bgImageView.layer.borderWidth = 0.8;
        
        //
        self.selectMarkImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.selectMarkImageView];
        self.selectMarkImageView.backgroundColor = [UIColor clearColor];
   
        
//        self.selectMarkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [self.bgImageView addSubview:self.selectMarkImageView];
//        
//        self.selectMarkImageView.image = [UIImage imageNamed:@"规格选中"];
//        [self.selectMarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.bottom.equalTo(self.bgImageView);
//        }];
        

        UILabel *testLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        testLbl.textColor = [UIColor blackColor];
        self.testLbl = testLbl;
        [self addSubview:testLbl];
      
        
    }
    return self;
}



@end
