//
//  ZHUserForgetPwdVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHUserForgetPwdVC.h"
#import "ZHCaptchaView.h"
#import "TLNetworking.h"
#import "APICodeHeader.h"
#import "TLAlert.h"
#import "TLUIHeader.h"
#import "NSString+Extension.h"
#import "NBNetwork.h"
#import "AppConfig.h"
#import "TLProgressHUD.h"

@interface ZHUserForgetPwdVC ()

@property (nonatomic,strong) ZHAccountTf *phoneTf;
@property (nonatomic,strong) ZHCaptchaView *captchaView;
@property (nonatomic,strong) ZHAccountTf *pwdTf;
@property (nonatomic,strong) ZHAccountTf *rePwdTf;

@end

@implementation ZHUserForgetPwdVC

- (void)sendCaptcha {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithHUDText:@"请输入正确的手机号"];
        
        return;
    }
    
    [TLProgressHUD showWithStatus:nil];
    NBCDRequest *sendCaptchaReq = [[NBCDRequest alloc] init];
    sendCaptchaReq.code = @"805950";
    sendCaptchaReq.parameters[@"bizType"] = @"805063";
    sendCaptchaReq.parameters[@"mobile"] = self.phoneTf.text;
    sendCaptchaReq.parameters[@"systemCode"] = [AppConfig config].systemCode;
    sendCaptchaReq.parameters[@"companyCode"] = [AppConfig config].systemCode;
    sendCaptchaReq.parameters[@"kind"] = [AppConfig config].kind;
    [sendCaptchaReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        [TLProgressHUD dismiss];
        [self.captchaView.captchaBtn begin];
        
    } failure:^(__kindof NBBaseRequest *request) {
        
        [TLProgressHUD dismiss];

    }];
    
    
}

- (void)changePwd {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithHUDText:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithHUDText:@"请输入正确的验证码"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithHUDText:@"请输入6位以上密码"];
        return;
    }

    
    [TLProgressHUD showWithStatus:nil];
    NBCDRequest *changePwd = [[NBCDRequest alloc] init];
    changePwd.code = @"805063";
    changePwd.parameters[@"mobile"] = self.phoneTf.text;
    changePwd.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    changePwd.parameters[@"loginPwdStrength"] = @"2";
    changePwd.parameters[@"newLoginPwd"] = self.pwdTf.text;
    changePwd.parameters[@"systemCode"] = [AppConfig config].systemCode;
    changePwd.parameters[@"companyCode"] = [AppConfig config].systemCode;
    changePwd.parameters[@"kind"] = [AppConfig config].kind;
    [changePwd startWithSuccess:^(__kindof NBBaseRequest *request) {
       [TLProgressHUD dismiss];
            [TLAlert alertWithInfo:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];

    } failure:^(__kindof NBBaseRequest *request) {
            [TLProgressHUD dismiss];

    }];
    
    
//    TLNetworking *http = [TLNetworking new];
//    http.showView = self.view;
//    http.code = @"805063";
//    http.parameters[@"mobile"] = self.phoneTf.text;
//    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
//    http.parameters[@"loginPwdStrength"] = @"2";
//    http.parameters[@"newLoginPwd"] = self.pwdTf.text;
//    
//    [http postWithSuccess:^(id responseObject) {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    } failure:^(NSError *error) {
//        
//        
//    }];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = ACCOUNT_TF_WIDTH;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat middleMargin = ACCOUNT_MIDDLE_MARGIN;
    
    //账号
    ZHAccountTf *phoneTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, 150, w, h)];
    phoneTf.zh_placeholder = @"请输入手机号";
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    phoneTf.leftIconView.image = [UIImage imageNamed:@"手机号"];
    [self.bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    self.phoneTf.centerX = self.bgSV.centerX;
    
    //验证码
    ZHCaptchaView *captchaView = [[ZHCaptchaView alloc] initWithFrame:CGRectMake(margin, phoneTf.yy + middleMargin, w, h)];
    [self.bgSV addSubview:captchaView];
    captchaView.captchaTf.zh_placeholder = @"请输入验证码";
    captchaView.captchaTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    self.captchaView = captchaView;
    self.captchaView.centerX = self.bgSV.centerX;

    //密码
    ZHAccountTf *pwdTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, captchaView.yy + middleMargin, w, h)];
    pwdTf.secureTextEntry = YES;
    pwdTf.zh_placeholder = @"请输入密码";
    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    [self.bgSV addSubview:pwdTf];
    self.pwdTf = pwdTf;
    self.pwdTf.centerX = self.bgSV.centerX;

    
    //re密码
    ZHAccountTf *rePwdTf = [[ZHAccountTf alloc] initWithFrame:CGRectMake(margin, pwdTf.yy + middleMargin, w, h)];
    rePwdTf.secureTextEntry = YES;
    rePwdTf.zh_placeholder = @"重新输入";
    [self.bgSV addSubview:rePwdTf];
    rePwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    self.rePwdTf = rePwdTf;
    self.rePwdTf.centerX = self.bgSV.centerX;

    //xiu gai
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin,pwdTf.yy + 10, w, h)];
    
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#b2b2b2"];
    
    [self.bgSV addSubview:confirmBtn];


    [confirmBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.centerX = self.bgSV.centerX;

    
    
}



@end
