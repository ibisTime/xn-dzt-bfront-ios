//
//  TLMeasureDataCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLMeasureDataCell.h"
#import "TLUIHeader.h"
#import "TLDataModel.h"
#import "TLChooseDataModel.h"
#import "TLInputDataModel.h"


@interface TLMeasureDataCell()

@property (nonatomic, strong) UILabel *leftTitleLbl;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation TLMeasureDataCell

+ (NSString *)cellReuseIdentifier {
    
    return @"TLMeasureDataCellID";
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.leftTitleLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(12)
                                          textColor:[UIColor themeColor]];
        [self.contentView addSubview:self.leftTitleLbl];
        //
        
        self.textField = [[UITextField alloc] init];
        [self.contentView addSubview:self.textField];
        self.textField.textColor = [UIColor textColor];
        self.textField.font = FONT(12);
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
        [self.textField addTarget:self action:@selector(editChange) forControlEvents:UIControlEventEditingChanged];

        
        //
        self.arrowImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.arrowImageView];
        self.arrowImageView.image = [UIImage imageNamed:@"下拉箭头"];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
        [self.contentView addSubview:line];
        
     
        CGFloat topMargin = 5;
        
        //从右到左布局
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.height.mas_equalTo(0.75);
            make.bottom.equalTo(self.mas_bottom);
            make.width.mas_equalTo(60);
        }];
        
        
        [self.leftTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(topMargin);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(line.mas_left).offset(-16);
            
        }];
        
     
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.leftTitleLbl.mas_centerY);
            make.right.equalTo(line.mas_right);
            
        }];

        
        // 16 22.5
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(line.mas_right).offset(-3);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.top.equalTo(self.leftTitleLbl);
            make.left.equalTo(line.mas_left).offset(5);
            
        }];
        
        

    }
    
//    [self data];
    return self;
}


- (void)editChange {
    
    TLInputDataModel *inputModel = self.model;
    inputModel.value = self.textField.text;
    
}

- (void)setModel:(id)model {

    [super setModel:model];
    
    
    if ([model isKindOfClass:[TLInputDataModel class]]) {
        
        TLInputDataModel *dataModel = model;
        self.leftTitleLbl.text = dataModel.keyName;
        self.textField.text = dataModel.value;
        self.textField.userInteractionEnabled = dataModel.canEdit;
        self.arrowImageView.hidden = YES;
        
    } else if ([model isKindOfClass:[TLChooseDataModel class]]) {
        //主要是形体
    
        TLChooseDataModel *dataModel = model;
        
        self.leftTitleLbl.text = dataModel.typeName;
        self.textField.text = dataModel.typeValueName;
        
        self.textField.userInteractionEnabled = NO;
        self.arrowImageView.hidden = !dataModel.canEdit;
        self.contentView.userInteractionEnabled = dataModel.canEdit;
        
    }
    
}

- (void)data {

    
    static NSInteger i = 0;
    
    if (i%3 == 0) {
        
        self.leftTitleLbl.text = @"前腰节长";
        self.textField.text = @"前腰节长";

        
    } else if (i%3 == 1) {
        
        self.leftTitleLbl.text = @"前腰节";
        self.textField.text = @"前腰节";

    
    } else  {
        
        self.leftTitleLbl.text = @"前腰";

        self.textField.text = @"100.5";

    
    }
    
    i ++;
}


@end
