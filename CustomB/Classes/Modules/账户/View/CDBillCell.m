//
//  CDBillCell.m
//  ZHBusiness
//
//  Created by  tianlei on 2017/5/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDBillCell.h"
#import "ZHBillModel.h"
#import "TLUIHeader.h"
#import "NSNumber+TLAdd.h"


@interface CDBillCell()

@property (nonatomic, strong) UILabel *dateTopLbl;
@property (nonatomic, strong) UILabel *dateBottomLbl;

@property (nonatomic, strong) UILabel *moneyChangeLbl;
@property (nonatomic, strong) UILabel *detailLbl;

@end

@implementation CDBillCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //ui
        [self setUpUI];
        

    }
    
    return self;
}


- (void)setBillModel:(ZHBillModel *)billModel {

    _billModel = billModel;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date01 = [formatter dateFromString:_billModel.createDatetime];
    
    formatter.dateFormat = @"MM-dd";
    formatter.locale = [NSLocale currentLocale];
    
    //得到日期1
    NSString *dateStr1 = [formatter stringFromDate:date01];
    
    //得到日期2
    formatter.dateFormat = @"HH:mm:ss";
    NSString *dateStr2 = [formatter stringFromDate:date01];

    
    
    
    self.dateTopLbl.text = dateStr1;
    self.dateBottomLbl.text = dateStr2;

    
    //
    if ([_billModel.transAmount longLongValue] > 0) {
        //收
//        self.moneyChangeLbl.textColor = [UIColor blackColor];
        self.moneyChangeLbl.text = [NSString stringWithFormat:@"￥+%@",[_billModel.transAmount convertToRealMoney]];

    } else {
        //支出
//        self.moneyChangeLbl.textColor = [UIColor colorWithRed:107/255.0 green:196/255.0 blue:250/255.0 alpha:1];
        self.moneyChangeLbl.text = [NSString stringWithFormat:@"￥%@",[_billModel.transAmount convertToRealMoney]];

    }
    
    self.detailLbl.text = _billModel.bizNote;
    
    
}

- (void)setUpUI {

    self.dateTopLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(12)
                                    textColor:[UIColor textColor]];
    [self.contentView addSubview:self.dateTopLbl];
    
    //
    self.dateBottomLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(12)
                                    textColor:[UIColor textColor]];
    [self.contentView addSubview:self.dateBottomLbl];
    
    //
    self.detailLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentCenter
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(12)
                                   textColor:[UIColor textColor]];
    [self.contentView addSubview:self.detailLbl];
    
    //钱数目变化
    self.moneyChangeLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(15)
                                    textColor:[UIColor textColor]];
    [self.contentView addSubview:self.moneyChangeLbl];
    
 
    
    //
    [self.dateTopLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(14);
    }];
 
    [self.dateBottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.dateTopLbl.mas_bottom).offset(8);
    }];
    
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(85);
        make.top.equalTo(self.dateTopLbl.mas_top);
        make.right.lessThanOrEqualTo(self.contentView.mas_right);
        
    }];
    
    //
    [self.moneyChangeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.detailLbl.mas_left);
        make.top.equalTo(self.detailLbl.mas_bottom).offset(6);
        
    }];
    

    
    //
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#a1a1a1"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.right.equalTo(self.mas_right).offset(-18);
        make.height.mas_equalTo(0.7);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    

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
