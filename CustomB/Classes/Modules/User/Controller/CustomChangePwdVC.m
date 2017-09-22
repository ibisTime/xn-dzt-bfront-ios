//
//  CustomCangePwdVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CustomChangePwdVC.h"
#import "CustomInputView.h"
#import "TLUIHeader.h"
#import "TLAlert.h"
#import "TLNetworking.h"
#import "TLUser.h"
#import "NBCDRequest.h"
#import "AppConfig.h"
#import "UIScrollView+TLAdd.h"

@interface CustomChangePwdVC ()

@property (nonatomic, strong) UIScrollView *bgSV;

@property (nonatomic, strong) CustomInputView *oldPwdInputView;
@property (nonatomic, strong) CustomInputView *nPwdInputView;
@property (nonatomic, strong) CustomInputView *reNewPwdInputView;


@end

@implementation CustomChangePwdVC

- (void)viewDidLayoutSubviews {
    
    self.bgSV.frame = self.view.bounds;

}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    self.title = @"修改登录密码";
    self.bgSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )];
    [self.view addSubview:self.bgSV];
    [self.bgSV adjustsContentInsets];
    
    //手机号
    self.oldPwdInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.oldPwdInputView];
    self.oldPwdInputView.leftTitleLbl.text = @"旧登录密码";
    self.oldPwdInputView.textField.secureTextEntry = YES;
    
    //
    self.nPwdInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0,  self.oldPwdInputView.yy + 10, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.nPwdInputView];
    self.nPwdInputView.leftTitleLbl.text = @"新登录密码";
    self.nPwdInputView.textField.secureTextEntry = YES;
    

    
    self.reNewPwdInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0, self.nPwdInputView.yy  + 10, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.reNewPwdInputView];
    self.reNewPwdInputView.leftTitleLbl.text = @"重复新密码";
    self.reNewPwdInputView.textField.secureTextEntry = YES;

    
    //
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.reNewPwdInputView.yy + 30, SCREEN_WIDTH - 40, 44) ];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"9ba9b5"];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    btn.centerX = SCREEN_WIDTH/2.0;
    [btn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)confirm {


    if (!(self.oldPwdInputView.textField.text &&self.oldPwdInputView.textField.text.length > 5)) {
        
        [TLAlert alertWithHUDText:@"请输入6位以上密码"];
        return;
    }
    
    if (!(self.nPwdInputView.textField.text &&self.nPwdInputView.textField.text.length > 5)) {
        
        [TLAlert alertWithHUDText:@"请输入6位以上密码"];
        return;
    }
    
    if (![self.nPwdInputView.textField.text isEqualToString:self.reNewPwdInputView.textField.text]) {
        
        [TLAlert alertWithHUDText:@"输入的密码不一致"];
        return;
        
    }
    
    
//    NBCDRequest *changePwd = [[NBCDRequest alloc] init];
//    changePwd.code = @"805064";
//    changePwd.parameters[@"newLoginPwd"] = self.nPwdInputView.textField.text;
//    changePwd.parameters[@"oldLoginPwd"] = self.oldPwdInputView.textField.text;
//    changePwd.parameters[@"token"] = [TLUser user].token;
//    changePwd.parameters[@"userId"] = [TLUser user].userId;
//    changePwd.parameters[@"systemCode"] = [AppConfig config].systemCode;
//    changePwd.parameters[@"companyCode"] = [AppConfig config].systemCode;
//    changePwd.parameters[@"kind"] = [AppConfig config].kind;
//    [changePwd startWithSuccess:^(__kindof NBBaseRequest *request) {
//        
//        [TLAlert alertWithInfo:@"修改成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//        if (self.success) {
//            self.success();
//        }
//        
//    } failure:^(__kindof NBBaseRequest *request) {
//        
//    }];
    
    
    //
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
        http.code = @"805064";
        http.parameters[@"newLoginPwd"] = self.nPwdInputView.textField.text;
        http.parameters[@"oldLoginPwd"] = self.oldPwdInputView.textField.text;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithInfo:@"修改成功"];
        [[TLUser user] updateUserInfo];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.success) {
            self.success();
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    

}


@end
