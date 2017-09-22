//
//  ZHBankCardAddVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBankCardAddVC.h"
#import "TLPickerTextField.h"
#import "ZHBank.h"
#import "TLUIHeader.h"
#import "TLUser.h"
#import "UIColor+theme.h"
#import "TLTextField.h"
#import "TLUIHeader.h"
#import "TLNetworking.h"
#import "TLAlert.h"
#import "NSString+Extension.h"
#import "CustomInputView.h"
#import "CustomBankCardChooseView.h"
#import "AppConfig.h"

@interface ZHBankCardAddVC ()

@property (nonatomic,strong) CustomInputView *realNameInputView; //户名
@property (nonatomic,strong) CustomBankCardChooseView *bankInputView; //开户行
@property (nonatomic,strong) CustomBankCardChooseView *subbranchInputView; //支行

@property (nonatomic,strong) CustomInputView *bankCardNumInputView; //银行卡号
@property (nonatomic,strong) CustomInputView *pwdInputView; //银行卡号



//
//@property (nonatomic,strong) TLTextField *realNameTf;
@property (nonatomic,strong) TLPickerTextField *bankNameTf; //开户行
//@property (nonatomic,strong) TLTextField *bankCardTf;
//@property (nonatomic, strong) TLTextField *tradePwdTf;

@property (nonatomic,strong) UIScrollView *bgSV;
@property (nonatomic,strong) UIButton *operationBtn;
@property (nonatomic,strong) NSMutableArray <ZHBank *>*banks; //所有银行
@property (nonatomic,strong) NSMutableArray <NSString *>*bankNames; //所有银行


@end


@implementation ZHBankCardAddVC
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.bgSV.frame = self.view.bounds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    
    self.bgSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.bgSV];
    [self.bgSV adjustsContentInsets];

    //户名
    self.realNameInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.realNameInputView];
    self.realNameInputView.leftTitleLbl.text = @"持卡人";
    
    //
    self.bankInputView = [[CustomBankCardChooseView alloc] initWithFrame:CGRectMake(0, self.realNameInputView.yy + 10, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.bankInputView];
    self.bankInputView.leftTitleLbl.text = @"开户行";
    
    //支行
    self.subbranchInputView = [[CustomBankCardChooseView alloc] initWithFrame:CGRectMake(0, self.bankInputView.yy + 10, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.subbranchInputView];
    self.subbranchInputView.leftTitleLbl.text = @"开户支行";
    
    //卡号
    self.bankCardNumInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0, self.subbranchInputView.yy  + 10, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.bankCardNumInputView];
    self.bankCardNumInputView.leftTitleLbl.text = @"卡号";
    self.bankCardNumInputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    //
    self.pwdInputView = [[CustomInputView alloc] initWithFrame:CGRectMake(0, self.bankCardNumInputView.yy  + 10, SCREEN_WIDTH, 45)];
    [self.bgSV addSubview:self.pwdInputView];
    self.pwdInputView.leftTitleLbl.text = @"支付密码";
    self.pwdInputView.textField.secureTextEntry = YES;
    if (!self.bankCard) {
        self.pwdInputView.height = 0.1;
    }
    
    
    //
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.pwdInputView.yy + 30, SCREEN_WIDTH - 40, 44) ];
                     
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"9ba9b5"];
    
    [self.view addSubview:btn];
    btn.centerX = SCREEN_WIDTH/2.0;
    [btn addTarget:self action:@selector(bindCard) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self realNameAuthAfterAction];
}





- (void)realNameAuthAfterAction {

    
    
    //只能添加该用户，的银行卡
    self.realNameInputView.textField.text = [TLUser user].realName;
//    self.realNameInputView.textField.enabled = NO;
    if (self.bankCard) {
        
        self.realNameInputView.textField.text = self.bankCard.realName;
        self.bankInputView.textField.text = self.bankCard.bankName;
        self.bankCardNumInputView.textField.text = self.bankCard.bankcardNumber;
        self.subbranchInputView.textField.text  = self.bankCard.subbranch;
        [self.operationBtn setTitle:@"修改" forState:UIControlStateNormal];
        self.title = @"修改银行卡";
        
    }
    
    
    //获取银行卡渠道
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802116";
    http.parameters[@"channelType"] = @"40";
    http.parameters[@"status"] = @"1";
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = responseObject[@"data"];
        self.banks = [ZHBank tl_objectArrayWithDictionaryArray:arr];
        self.bankNames = [NSMutableArray arrayWithCapacity:self.banks.count];
        [self.banks enumerateObjectsUsingBlock:^(ZHBank * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.bankNames addObject:obj.bankName];
            
        }];
        
        //传递银行名称
        self.bankInputView.textField.tagNames = self.bankNames;
        
    } failure:^(NSError *error) {
        
        
    }];

}


- (void)bindCard {

    if (![self.realNameInputView.textField.text valid]) {
        [TLAlert alertWithMsg:@"请输入姓名"];
        return;
    }
    
    if (![self.bankInputView.textField.text valid]) {
        [TLAlert alertWithMsg:@"请选择银行卡"];
        return;
    }
    
    if (![self.bankCardNumInputView.textField.text valid]) {
        [TLAlert alertWithMsg:@"请填写银行卡号"];
        return;
    }
    
    if (![self.subbranchInputView.textField.text valid]) {
        [TLAlert alertWithMsg:@"请填写开户支行"];
        return;
    }
    
    //
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    if (self.bankCard) {//修改
        //
        
        if (![self.pwdInputView.textField.text valid]) {
            [TLAlert alertWithInfo:@"请填写支付密码"];
            return;
        }
        //
        http.code = @"802013";
        http.parameters[@"code"] = self.bankCard.code;
        http.parameters[@"status"] = @"1";
        http.parameters[@"tradePwd"] = self.pwdInputView.textField.text;
        
    } else {//绑定
    
       http.code = @"802010";
    
    }
    
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"realName"] = self.realNameInputView.textField.text;
    http.parameters[@"subbranch"] = self.subbranchInputView.textField.text;

    NSString *bankName = self.bankInputView.textField.text;
  __block  ZHBank *bank = nil;
    [self.banks enumerateObjectsUsingBlock:^(ZHBank * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.bankName isEqualToString:bankName]) {
            bank = obj;
            *stop = YES;
        }
    }];
    
    __block  NSString *bankCode = nil;
    [self.banks enumerateObjectsUsingBlock:^(ZHBank * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.bankName isEqualToString: self.bankInputView.textField.text ]) {
            bankCode = obj.bankCode;
        }
    }];
   
    
    if (!bankCode) {
        [TLAlert alertWithHUDText:@"暂时无法添加"];
        return;
    }
    
    http.parameters[@"systemCode"] = [AppConfig config].systemCode;
    http.parameters[@"bankName"] = self.bankInputView.textField.text;
    http.parameters[@"bankCode"] = bankCode;
    http.parameters[@"bankcardNumber"] = self.bankCardNumInputView.textField.text; //卡号
    http.parameters[@"currency"] = @"CNY"; //币种
    http.parameters[@"type"] = @"B"; //b端用户
    
    [http postWithSuccess:^(id responseObject) {
        
        if (self.bankCard) {
            
            [TLAlert alertWithHUDText:@"修改成功"];

        } else {
            [TLAlert alertWithHUDText:@"绑定成功"];

        }
        
        [self.navigationController popViewControllerAnimated:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ZHBankCard *card = [[ZHBankCard alloc] init];
            card.bankName = self.bankInputView.textField.text;
            card.bankcardNumber = self.bankCardNumInputView.textField.text;
            if (self.addSuccess) {
                self.addSuccess(card);
            }
        });
        
    } failure:^(NSError *error) {
        
        
    }];


}

- (void)setUpUI {
//
//    CGFloat leftW = 90;
//    CGFloat margin = 0.5;
//    
//    //户名
//    TLTextField *nameTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:@"户名" titleWidth:leftW placeholder:@"请输入银行卡所属人姓名"];
//    [self.bgSV addSubview:nameTf];
//    self.realNameTf = nameTf;
//    
//    //开户行
//    TLPickerTextField *bankPick = [[TLPickerTextField alloc] initWithframe:CGRectMake(0, nameTf.yy + margin, SCREEN_WIDTH, nameTf.height) leftTitle:@"开户行" titleWidth:leftW placeholder:@"请选择开户行"];
//    [self.bgSV addSubview:bankPick];
//    self.bankNameTf = bankPick;
//    
//    
//    //卡号
//    TLTextField *bankCardTf = [[TLTextField alloc] initWithframe:CGRectMake(0, bankPick.yy + margin, SCREEN_WIDTH, 45) leftTitle:@"银行卡号  " titleWidth:leftW placeholder:@"请输入银行卡号"];
//    [self.bgSV addSubview:bankCardTf];
//    bankCardTf.keyboardType = UIKeyboardTypeNumberPad;
//    self.bankCardTf = bankCardTf;
//    
//    
//    //
//    self.tradePwdTf = [[TLTextField alloc] initWithframe:CGRectMake(0, bankCardTf.yy + margin, SCREEN_WIDTH, 45) leftTitle:@"支付密码" titleWidth:leftW placeholder:@"请输入支付密码"];
//    [self.bgSV addSubview:self.tradePwdTf];
//    self.tradePwdTf.secureTextEntry = YES;
//
//    //--//
//    if (!self.bankCard) {
//        self.tradePwdTf.height = 0.01;
//        self.tradePwdTf.hidden = YES;
//    }
//    
//    //
//    UIButton *addBtn = [UIButton zhBtnWithFrame:CGRectMake(15, self.tradePwdTf.yy + 30, SCREEN_WIDTH - 30, 45) title:@"添加"];
//    [self.bgSV addSubview:addBtn];
//    [addBtn addTarget:self action:@selector(bindCard) forControlEvents:UIControlEventTouchUpInside];
//    self.operationBtn = addBtn;
//    
//    
// 
//
//    UIButton *setPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, addBtn.yy + 10, SCREEN_WIDTH - 30, 30) title:@"您还未设置支付密码,前往设置->" backgroundColor:[UIColor clearColor]];
//    [self.view addSubview:setPwdBtn];
//    [setPwdBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
//    setPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [setPwdBtn addTarget:self action:@selector(setTrade:) forControlEvents:UIControlEventTouchUpInside];
//    
//    if ([[TLUser user].tradepwdFlag isEqualToString:@"1"]) {
//        setPwdBtn.hidden = YES;
//    }
//    
}

- (void)setTrade:(UIButton *)btn {
//    
//    ZHPwdRelatedVC *tradeVC = [[ZHPwdRelatedVC alloc] initWith:ZHPwdTypeTradeReset];
//    tradeVC.success = ^() {
//        
//        btn.hidden = YES;
//        
//    };
//    [self.navigationController pushViewController:tradeVC animated:YES];
//    
    
}

@end
