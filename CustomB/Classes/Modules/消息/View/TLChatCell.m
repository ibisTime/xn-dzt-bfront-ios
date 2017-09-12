//
//  TLChatCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLChatCell.h"
#import "TLUIHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "ImageUtil.h"
#import "AppConfig.h"

@interface TLChatCell()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIImageView *leftArrowImageView;
@property (nonatomic, strong) UIImageView *rightArrowImageView;

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *contentLbl;

@end


@implementation TLChatCell


- (void)setModel:(CustomLiuYanModel *)model {

    _model = model;
    
    self.contentLbl.text = model.content;
    
    if (model.chatType == ChatModelTypeMe) {
        
        self.leftImageView.hidden = YES;
        self.rightImageView.hidden=  NO;
        self.leftArrowImageView.hidden = self.leftImageView.hidden;
        self.rightArrowImageView.hidden = self.rightImageView.hidden;

        NSString *photoUrl =  [ImageUtil convertImageUrl:model.commentPhoto imageServerUrl:[AppConfig config].qiniuDomain];
        
        
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        self.contentLbl.textAlignment = NSTextAlignmentLeft;
        
        
    } else {
        
        self.leftImageView.hidden = NO;
        self.rightImageView.hidden=  YES;
        self.leftArrowImageView.hidden = self.leftImageView.hidden;
        self.rightArrowImageView.hidden = self.rightImageView.hidden;
        
        NSString *photoUrl =  [ImageUtil convertImageUrl:model.commentPhoto imageServerUrl:[AppConfig config].qiniuDomain];
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        self.contentLbl.textAlignment = NSTextAlignmentRight;

    }
    
    self.bgImageView.backgroundColor = [UIColor whiteColor];
    
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        self.leftImageView = [self photoImageView];
        [self.contentView addSubview:self.leftImageView];
        
        self.rightImageView = [self photoImageView];
        [self.contentView addSubview:self.rightImageView];
        
        //
        self.leftArrowImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.leftArrowImageView];
        self.leftArrowImageView.image = [UIImage imageNamed:@"聊天箭头左"
                                         ];
        
        self.rightArrowImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.rightArrowImageView];
        self.rightArrowImageView.image = [UIImage imageNamed:@"聊天箭头右"
                                         ];

        
        //
        self.bgImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bgImageView];
        self.bgImageView.layer.cornerRadius = 5;
        self.bgImageView.layer.masksToBounds = YES;
        
        //
        self.contentLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentCenter
                                  backgroundColor:[UIColor whiteColor]
                                             font:[UIFont systemFontOfSize:12]
                                        textColor:[UIColor colorWithHexString:@"#000000"]];
        [self.bgImageView addSubview:self.contentLbl];
        self.contentLbl.numberOfLines = 0;
        
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(50);
            make.left.equalTo(self.contentView.mas_left).offset(18);
            make.top.equalTo(self.contentView.mas_top).offset(28);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom);
        }];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.leftImageView);
            make.right.equalTo(self.contentView.mas_right).offset(-18);
            make.top.equalTo(self.leftImageView.mas_top);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom);

        }];
        
     
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImageView.mas_right).offset(14);
            make.right.equalTo(self.rightImageView.mas_left).offset(-14);
            make.top.equalTo(self.leftImageView.mas_top).offset(4);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom);
        }];
        [self.leftArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgImageView.mas_left);
            make.centerY.equalTo(self.bgImageView.mas_top).offset(22);

        }];
        
        [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView.mas_right);
            make.centerY.equalTo(self.leftArrowImageView.mas_centerY);
        }];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView.mas_left).offset(14);
            make.right.equalTo(self.bgImageView.mas_right).offset(-14);
            make.top.equalTo(self.bgImageView.mas_top).offset(14);
            make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-14);
        }];
        
        
    }
    
    return self;

}


- (UIImageView *)photoImageView {

    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.layer.cornerRadius = 25;
    imageV.layer.masksToBounds = YES;
    return imageV;

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
