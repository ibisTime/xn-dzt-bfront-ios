//
//  TLOrderCollectionViewHeader.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderCollectionViewHeader.h"
#import "TLUIHeader.h"

@interface TLOrderCollectionViewHeader()






@end

@implementation TLOrderCollectionViewHeader

+ (NSString *)headerReuseIdentifier {

    return [NSString stringWithFormat:@"%@ID",NSStringFromClass(self)];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        self.titleLbl.text = @"着装风格";
  
        [self.editBtn addTarget:self action:@selector(goEdit) forControlEvents:UIControlEventTouchUpInside];
        [self.confirmBtn addTarget:self action:@selector(editConfirm) forControlEvents:UIControlEventTouchUpInside];
        [self.cancleBtn addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)setGroup:(TLGroup *)group {

    _group = group;
    
    self.contentLbl.text = _group.content;
    self.titleLbl.text = _group.title;
    
//    self.contentLbl.text=  @"在哪1";
    
    if (!group.canEdit) {
        
        [self forbidEdit];
        return;
    }
    if (_group.editting) {
        
        [self editing];
        
    } else {
        
        [self edited];
        
    }
    
}

- (void)forbidEdit {

    self.editBtn.hidden = YES;
    //
    self.cancleBtn.hidden = YES;
    self.confirmBtn.hidden = YES;

}

- (void)editing {

    self.editBtn.hidden = YES;
    //
    self.cancleBtn.hidden = NO;
    self.confirmBtn.hidden = NO;

}

- (void)edited {

    self.editBtn.hidden = NO;
    
    self.cancleBtn.hidden = YES;
    self.confirmBtn.hidden = YES;

}

#pragma mark- 点击编辑按钮
- (void)goEdit {
    
    [self callDelegateWithType:EditTypeGoEdit];
    
}

#pragma mark- 取消
- (void)cancelEdit {
    
    [self callDelegateWithType:EditTypeCancle];

}

#pragma mark- 确定编辑
- (void)editConfirm {
    
    [self callDelegateWithType:EditTypeConfirm];
    
}

- (void)callDelegateWithType:(EditType)type {

    if (self.delegate && self.delegate) {
        
        [self.delegate actionWithView:self type:type];
    }
    

}




- (void)setUpUI {

    self.backgroundColor = [UIColor backgroundColor];
    
    self.titleLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor clearColor]
                                       font:FONT(12)
                                  textColor:[UIColor themeColor]];
    
    [self addSubview:self.titleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(18);
        
    }];
    
    //
    self.contentLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor clearColor]
                                       font:FONT(12)
                                  textColor:[UIColor textColor]];
    
    [self addSubview:self.contentLbl];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.titleLbl.mas_right).offset(15);
        
    }];
    

    
    self.editBtn = [self btnWithTitle:@"编辑" titleColor:[UIColor colorWithHexString:@"#b0b0b0"]];
    [self addSubview:self.editBtn];
    
    //
    self.confirmBtn = [self btnWithTitle:@"确定" titleColor:[UIColor themeColor]];
    [self addSubview:self.confirmBtn];
    
    self.cancleBtn = [self btnWithTitle:@"取消" titleColor:[UIColor themeColor]];
    [self addSubview:self.cancleBtn];
    
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
        make.right.equalTo(self.mas_right).offset(-18);
        make.width.mas_equalTo(50);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);

        make.right.equalTo(self.mas_right).offset(-18);
        make.width.mas_equalTo(50);

    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.confirmBtn.mas_centerY);
        make.right.equalTo(self.confirmBtn.mas_left).offset(0);
        make.height.equalTo(self.mas_height);
        make.width.mas_equalTo(50);

    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#9f9f9f"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.right.equalTo(self.mas_right).offset(-18);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
}

- (UIButton *)btnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {

    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(12);
    btn.backgroundColor = [UIColor clearColor];
    return btn;
}

@end
