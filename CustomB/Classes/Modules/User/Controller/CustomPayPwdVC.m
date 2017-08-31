//
//  CustomPayPwdVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CustomPayPwdVC.h"
#import "CustomCaptchaView.h"
#import "CustomInputView.h"
#import "TLUIHeader.h"
#import "TLNetworking.h"
#import "TLUser.h"
#import "TLAlert.h"
#import "NSString+Extension.h"

@interface CustomPayPwdVC ()

@property (nonatomic, strong) CustomInputView *phoneInputView;

//
@property (nonatomic, strong) CustomInputView *nPwdInputView;
@property (nonatomic, strong) CustomInputView *reNewPwdInputView;
@property (nonatomic, strong) UIScrollView *bgSV;

@property (nonatomic, strong) CustomCaptchaView *captchaView;

@end

@implementation CustomPayPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付密码";
    
    self.bgSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.bgSV];
    
    //手机号
    self.phoneInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.phoneInputView];
    self.phoneInputView.leftTitleLbl.text = @"手机号码";
    self.phoneInputView.textField.text = [TLUser user].mobile;
    self.phoneInputView.textField.userInteractionEnabled = NO;

    //验证码
    CustomCaptchaView *captchaView = [[CustomCaptchaView alloc] initWithFrame:CGRectMake(0,  self.phoneInputView.yy + 10, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:captchaView];
    self.captchaView = captchaView;
    captchaView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    self.nPwdInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0,captchaView.bottom + 10, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.nPwdInputView];
    self.nPwdInputView.leftTitleLbl.text = @"支付密码";
    self.nPwdInputView.textField.secureTextEntry = YES;
    
    self.reNewPwdInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0, self.nPwdInputView.yy  + 10, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.reNewPwdInputView];
    self.reNewPwdInputView.leftTitleLbl.text = @"重复密码";
    self.reNewPwdInputView.textField.secureTextEntry = YES;


    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.reNewPwdInputView.yy + 30, SCREEN_WIDTH - 40, 44) title:@"确定" backgroundColor:[UIColor colorWithHexString:@"9ba9b5"] cornerRadius:5];
    [self.view addSubview:btn];
    btn.centerX = SCREEN_WIDTH/2.0;
    [btn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)sendCaptcha {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805950";
    http.parameters[@"bizType"] = @"805066";
    http.parameters[@"mobile"] = [TLUser user].mobile;
    [http postWithSuccess:^(id responseObject) {
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


- (void)confirm {
    
    
    if (!(self.nPwdInputView.textField.text &&self.nPwdInputView.textField.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入支付密码"];
        return;
    }
    
    
    if (![self.reNewPwdInputView.textField.text isEqualToString:self.nPwdInputView.textField.text]) {
        
        [TLAlert alertWithInfo:@"输入的密码不一致"];
        return;
        
    }
    
    
    if (![self.captchaView.textField.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入验证码"];
        return;
    }
    

    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805066";//  805067重置支付密码
    http.parameters[@"smsCaptcha"] = self.captchaView.textField.text;
    http.parameters[@"tradePwd"] = self.nPwdInputView.textField.text;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithInfo:@"操作成功"];
        [[TLUser user] updateUserInfo];
        [TLUser user].tradepwdFlag = @"1";
        if (self.success) {
            self.success();
        }

        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}


@end
