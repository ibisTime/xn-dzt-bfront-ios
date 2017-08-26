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
@property (nonatomic,strong) TLTextField *tradePwdTf;
@property (nonatomic, strong) UIScrollView *bgSV;
@end

@implementation ZHChangeMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView
    self.title = @"修改手机号";
    self.bgSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.bgSV];
    
    //手机号
    self.phoneInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.phoneInputView];
    self.phoneInputView.leftTitleLbl.text = @"新手机号";
    
    //验证码
    CustomCaptchaView *captchaView = [[CustomCaptchaView alloc] initWithFrame:CGRectMake(self.phoneInputView.x, self.phoneInputView.yy + 1, self.phoneInputView.width, self.phoneInputView.height)];
    [self.bgSV addSubview:captchaView];
    
    self.captchaView = captchaView;
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    //支付密码按钮
    TLTextField *tradePwdTf = [[TLTextField alloc] initWithframe:CGRectMake(0, captchaView.yy  + 1, SCREEN_WIDTH, 50) leftTitle:@"支付密码" titleWidth:90 placeholder:@"请输入支付密码"];
    tradePwdTf.secureTextEntry = YES;
    tradePwdTf.isSecurity = YES;
    [self.view addSubview:tradePwdTf];
    self.tradePwdTf = tradePwdTf;
    
    //
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, tradePwdTf.yy + 30, SCREEN_WIDTH - 40, 44) title:@"确定" backgroundColor:[UIColor colorWithHexString:@"9ba9b5"] cornerRadius:5];
    [self.view addSubview:btn];
    btn.centerX = SCREEN_WIDTH/2.0;
    [btn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    

    
//    //
//    UIButton *setPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, confirmBtn.yy + 10, SCREEN_WIDTH - 30, 30) title:@"您还未设置支付密码,前往设置->" backgroundColor:[UIColor clearColor]];
//    [self.view addSubview:setPwdBtn];
//    [setPwdBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
//    setPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [setPwdBtn addTarget:self action:@selector(setTrade:) forControlEvents:UIControlEventTouchUpInside];
    
//    if ([[TLUser user].tradepwdFlag isEqualToString:@"1"]) {
//        setPwdBtn.hidden = YES;
//    }
    
}

- (void)setTrade:(UIButton *)btn {

//    ZHPwdRelatedVC *tradeVC = [[ZHPwdRelatedVC alloc] initWith:ZHPwdTypeTradeReset];
//    tradeVC.success = ^() {
//        
//        btn.hidden = YES;
//        
//    };
//    [self.navigationController pushViewController:tradeVC animated:YES];


}

- (void)sendCaptcha {

    if (!self.phoneInputView.textField.text) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"";
    http.parameters[@"bizType"] = USER_CAHNGE_MOBILE;
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
    
    if (![self.tradePwdTf.text length]) {
        
        [TLAlert alertWithHUDText:@"请输入支付密码"];
        return;
        
    }

    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CAHNGE_MOBILE;
    http.parameters[@"newMobile"] = self.phoneInputView.textField.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.textField.text;
    http.parameters[@"tradePwd"] = self.tradePwdTf.text;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
