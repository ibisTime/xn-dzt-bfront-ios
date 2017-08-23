//
//  TLOrderStyleCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderStyleCell.h"
#import "UIColor+Extension.h"
#import "UIColor+theme.h"
#import "TLParameterModel.h"

@interface TLOrderStyleCell()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIImageView *selectMarkImageView;

@end

@implementation TLOrderStyleCell

+ (NSString *)cellReuseIdentifier {

    return @"TLOrderStyleCellID";

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor backgroundColor];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.btn = [[UIButton alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.btn];
       
        self.btn.layer.cornerRadius = 5;
        self.btn.layer.masksToBounds = YES;
        self.btn.layer.borderWidth = 0.5;
        self.btn.layer.borderColor = [UIColor colorWithHexString:@"#a0a0a0"].CGColor;
        self.btn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.backgroundColor = [UIColor whiteColor];
        [self.btn setTitle:@"非常修身" forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];

        
        self.btn.userInteractionEnabled = NO;
        
        
        
        self.selectMarkImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.selectMarkImageView];
        self.selectMarkImageView.layer.cornerRadius = self.btn.layer.cornerRadius;
        self.selectMarkImageView.backgroundColor = [UIColor clearColor];
        self.selectMarkImageView.layer.masksToBounds = YES;
        self.selectMarkImageView.layer.borderColor = [UIColor themeColor].CGColor;
        self.selectMarkImageView.layer.borderWidth = 2;
        
        
    }
    return self;
}

- (void)setModel:(id)model {

    [super setModel:model];
    
    TLParameterModel *parameterModel = model;
    [self.btn setTitle:parameterModel.name forState:UIControlStateNormal];
    self.selectMarkImageView.hidden = !parameterModel.isSelected;
    
}

@end
