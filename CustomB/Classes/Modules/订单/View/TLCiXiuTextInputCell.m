//
//  TLCiXiuTextInputCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLCiXiuTextInputCell.h"
#import "TLUIHeader.h"
#import "TLInputDataModel.h"

@interface TLCiXiuTextInputCell()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation TLCiXiuTextInputCell

+ (NSString *)cellReuseIdentifier {

    return @"TLCiXiuTextInputCellID";
}

- (void)setModel:(id)model {

    [super setModel:model];
    
    TLInputDataModel *inputModel = model;
    self.textField.text = inputModel.value;
    
}

- (void)editChange {
    
    TLInputDataModel *inputModel = self.model;
    inputModel.value = self.textField.text;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textField = [[UITextField alloc] init];
        [self.contentView addSubview:self.textField];
        self.textField.placeholder = @"请输入刺绣内容";
        self.textField.font = [UIFont systemFontOfSize:12];
        [self.textField addTarget:self action:@selector(editChange) forControlEvents:UIControlEventEditingChanged];
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#afafaf"];
        [self.contentView addSubview:line];
        
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(45);
            make.right.equalTo(self.contentView.mas_right).offset(-45);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(self.contentView.mas_height);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(35);
            make.right.equalTo(self.contentView.mas_right).offset(-35);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

@end
