//
//  ZHChangeNickNameVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHChangeNickNameVC.h"
#import "TLUser.h"
#import "TLUIHeader.h"
#import "TLTextField.h"
#import "TLNetworking.h"
#import "TLAlert.h"
#import "CustomInputView.h"
#import "UIButton+convience.h"
#import "UIButton+convience.h"

@interface ZHChangeNickNameVC ()

@property (nonatomic, strong) CustomInputView *nickNameView;

@end

@implementation ZHChangeNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改昵称";
    self.nickNameView = [[CustomInputView alloc] initWithFrame:CGRectMake(0,  20, SCREEN_WIDTH, 45)];
    [self.view addSubview:self.nickNameView];
    self.nickNameView.leftTitleLbl.text = @"新昵称";
    
    //
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.nickNameView.yy  +15, SCREEN_WIDTH - 36, 40) title:@"确定" backgroundColor:[UIColor colorWithHexString:@"9ba9b5"] cornerRadius:5];
    [self.view addSubview:btn];
    btn.centerX = SCREEN_WIDTH/2.0;
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    //
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    if ([TLUser user].nickname) {
        
        self.nickNameView.textField.text = [TLUser user].nickname;
        
        
    }
    
}

- (void)save {
    
    if (self.nickNameView.textField.text && !self.nickNameView.textField.text.length) {
        [TLAlert alertWithHUDText:@"请输入昵称"];
        return;
    }

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805082";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"nickname"] = self.nickNameView.textField.text;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
        [TLUser user].nickname = self.nickNameView.textField.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
        [[TLUser user] updateUserInfo];
        
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
