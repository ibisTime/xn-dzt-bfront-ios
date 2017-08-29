//
//  TLUserSettingCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUserSettingCell.h"
#import "TLUIHeader.h"

#import "UIImageView+WebCache.h"

@interface TLUserSettingCell()

@property (nonatomic,strong) UILabel *textLbl;

@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UILabel *subTextLbl;

@end


@implementation TLUserSettingCell

+ (CGFloat)defaultCellHeight {
    
    return 58;
}

- (void)setModel:(TLSettingModel *)model {
    
    _model = model;
    
//    self.leftImageView.image = [UIImage imageNamed:model.imgName];
    self.textLbl.text = model.text;
    self.subTextLbl.text = model.subText;
    
    if (self.type == TLUserSettingCellTypePhoto) {
    
        self.photoImageView.hidden = NO;
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.imgName] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
    } else {
        
        self.photoImageView.hidden = YES;
        
    }
    
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
    }
    
    
    return self;

}


- (void)setUpUI {

//    self.leftImageView = [[UIImageView alloc] init];
//    [self addSubview:self.leftImageView];
    
    
    UIColor *textColor = [UIColor colorWithHexString:@"#4d4d4d"];
    
    //
    self.textLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(14)
                                 textColor:textColor];
    [self.contentView addSubview:self.textLbl];
    
    //
    self.subTextLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(14)
                                    textColor:textColor];
    [self.contentView addSubview:self.subTextLbl];
    
    
    //
    UIImageView *arrow =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多"]];
    [self.contentView addSubview:arrow];
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    
    //
    self.photoImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.photoImageView];
    self.photoImageView.layer.cornerRadius = 25;
    self.photoImageView.layer.masksToBounds = YES;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.clipsToBounds = YES;
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(arrow.mas_left).offset(-6);

    }];
    
    
    
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25);
        make.centerY.equalTo(self.contentView);
    }];
    
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-29);
        make.centerY.equalTo(self.contentView);
        
    }];
    
    [self.subTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.mas_left).offset(-12);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#a1a1a1"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(@0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];


}

@end
