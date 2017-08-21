//
//  TLSearchView.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLSearchView.h"
#import "TLUIHeader.h"

@implementation TLSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 88)];
        [self addSubview:searchBgView];
        
        //
        UIView *searchTfBgView = [[UIView alloc] initWithFrame:CGRectMake(18, 10,SCREEN_WIDTH - 110, 40)];
        [self addSubview:searchTfBgView];
        searchTfBgView.layer.borderColor = [UIColor colorWithHexString:@"#a0a0a0"].CGColor;
        searchTfBgView.layer.borderWidth = 1;
        searchTfBgView.layer.cornerRadius = 5;
        searchTfBgView.layer.masksToBounds = YES;
        
        //
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, searchTfBgView.width - 32, searchTfBgView.height)];
        
        [searchTfBgView addSubview:tf];
        tf.font = FONT(14);
        tf.placeholder = @"请输入订单编号、客户姓名或手机号";
        self.textField = tf;
        
        //
        UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchTfBgView.right + 10, searchTfBgView.top, 63, tf.height) title:@"搜索" backgroundColor:[UIColor themeColor]];
        self.searchBtn = searchBtn;
        searchBtn.layer.cornerRadius = 5;
        searchBtn.layer.masksToBounds = YES;
        [searchBgView addSubview:searchBtn];
        [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return self;
}

@end
