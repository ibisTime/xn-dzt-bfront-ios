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
#import "TLUIHeader.h"

@interface TLOrderStyleCell()

@property (nonatomic, strong) UILabel  *textLbl;

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
        
        self.textLbl = [UILabel labelWithFrame:self.bounds
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(12)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.textLbl];
        //
        
       
         self.textLbl.layer.cornerRadius = 5;
         self.textLbl.layer.masksToBounds = YES;
         self.textLbl.layer.borderWidth = 0.5;
         self.textLbl.layer.borderColor = [UIColor colorWithHexString:@"#a0a0a0"].CGColor;
         self.textLbl.text = @"非常修身";
        
    
        self.selectMarkImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.selectMarkImageView];
        self.selectMarkImageView.layer.cornerRadius = self.textLbl.layer.cornerRadius;
        self.selectMarkImageView.backgroundColor = [UIColor clearColor];
        self.selectMarkImageView.layer.masksToBounds = YES;
        self.selectMarkImageView.layer.borderColor = [UIColor themeColor].CGColor;
        self.selectMarkImageView.layer.borderWidth = 2;
        
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(1, 1, 1, 1));
        }];
        
        [self.selectMarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(1, 1, 1, 1));
        }];
    }
    return self;
}

- (void)setModel:(id)model {

    [super setModel:model];
    
    TLParameterModel *parameterModel = model;
    self.textLbl.text = parameterModel.name;
    
    if (parameterModel.yuSelected) {
        
        self.selectMarkImageView.hidden = NO;
        
    } else {
        
        self.selectMarkImageView.hidden = YES;
        
    }
//    self.selectMarkImageView.hidden = !parameterModel.isSelected;
    
}

@end
