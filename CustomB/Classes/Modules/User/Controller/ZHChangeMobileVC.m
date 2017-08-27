//
//  ZHChangeMobileVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHChangeMobileVC.h"
#import "UIColor+theme.h"
#import "TLUser.h"
#import "TLTextField.h"
#import "CustomCaptchaView.h"
#import "TLUIHeader.h"
#import "TLAlert.h"
#import "TLNetworking.h"
#import "APICodeHeader.h"
#import "CustomInputView.h"

@interface ZHChangeMobileVC ()

@property (nonatomic,strong) CustomInputView *phoneInputView;
@property (nonatomic,strong) CustomCaptchaView *captchaView;
@property (nonatomic, strong) UIScrollView *bgSV;

@end

@implementation ZHChangeMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改手机号";
    self.bgSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.bgSV];
    
    //手机号
    self.phoneInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.phoneInputView];
    self.phoneInputView.leftTitleLbl.text = @"新手机号";
    self.phoneInputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    //验证码
    CustomCaptchaView *captchaView = [[CustomCaptchaView alloc] initWithFrame:CGRectMake(self.phoneInputView.x, self.phoneInputView.yy + 1, self.phoneInputView.width, self.phoneInputView.height)];
    [self.bgSV addSubview:captchaView];
    self.captchaView = captchaView;
    
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.captchaView.yy + 30, SCREEN_WIDTH - 40, 44) title:@"确定" backgroundColor:[UIColor colorWithHexString:@"9ba9b5"] cornerRadius:5];
    [self.view addSubview:btn];
    btn.centerX = SCREEN_WIDTH/2.0;
    [btn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)sendCaptcha {

    if (!self.phoneInputView.textField.text) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805950";
    http.parameters[@"bizType"] = @"805061";
    http.parameters[@"mobile"] = self.phoneInputView.textField.text;

    [http postWithSuccess:^(id responseObject) {
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
    }];


}

- (void)confirm {
    
    if (![self.phoneInputView.textField.text length]) {
        
        [TLAlert alertWithHUDText:@"请输入正确的手机号"];
        return;
    }
    
    if (![self.captchaView.textField.text length] || self.captchaView.textField.text.length < 4 ) {
        [TLAlert alertWithHUDText:@"请输入正确的验证码"];
        return;
    }
    

    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805061";
    http.parameters[@"newMobile"] = self.phoneInputView.textField.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.textField.text;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"修改成功"];
        [TLUser user].mobile = self.phoneInputView.textField.text;
        if (self.changeMobileSuccess) {
            self.changeMobileSuccess(self.phoneInputView.textField.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
    }];
}



@end
