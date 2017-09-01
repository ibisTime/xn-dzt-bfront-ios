 //
//  TLWithdrawalVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHWithdrawalVC.h"
#import "TLPickerTextField.h"
#import "ZHBankCardAddVC.h"
#import "TLUIHeader.h"
#import "UIColor+theme.h"
#import "TLUser.h"
#import "TLProgressHUD.h"
#import "TLNetworking.h"
#import "TLAlert.h"
#import "NSNumber+TLAdd.h"
#import "NSString+Extension.h"
#import "CustomPayPwdVC.h"

//#define WITHDRAW_RULE_MAX_KEY @"QXDBZDJE"


#define WITHDRAW_RULE_SHI_XIAO @"BUSERQXSX"
//
#define WITHDRAW_RULE_MAX_COUNT_KEY @"BUSERMONTIMES"
#define WITHDRAW_RULE_BEI_SHU_KEY @"BUSERQXBS"
#define WITHDRAW_RULE_PROCEDURE_FEE_KEY @"BUSERQXFL"
#define WITHDRAW_RULE_MAX_JIN_E @"QXDBZDJE"



//BUSERQXBS  着装顾问取现倍数
//BUSERQXFL  着装顾问取现费率
//BUSERQXSX  着装顾问取现时效
//BUSERMONTIMES   着装顾问每月取现次数

@interface ZHWithdrawalVC ()

@property (nonatomic,strong) TLPickerTextField *bankPickTf;
@property (nonatomic,strong) UILabel *balanceLbl;
@property (nonatomic,strong) UILabel *procedureFeeLbl;


//--//
//@property (nonatomic,strong) UILabel *hinLbl;
@property (nonatomic, strong) UILabel *withdrawRuleLbl;
//@property (nonatomic, strong) UIButton *setPwdBtn;

@property (nonatomic,strong) UITextField *moneyTf;
@property (nonatomic,strong) NSMutableArray <ZHBankCard *>*banks;
@property (nonatomic,strong) TLTextField *tradePwdTf;

@property (nonatomic, strong) NSNumber *shiXiao;

@property (nonatomic, strong) NSNumber *beiShu;
@property (nonatomic, strong) NSNumber *maxCount;
@property (nonatomic, strong) NSNumber *produceFee;
@property (nonatomic, strong) NSNumber *maxJinE;

@property (nonatomic, assign) BOOL getBankCardSuccess;



@end

@implementation ZHWithdrawalVC {

    dispatch_group_t _group;

}

- (void)tl_placeholderOperation {

    if ([[TLUser user].tradepwdFlag isEqual:@0]) {
        //1.先判断是否设置了支付密码
        [self setPlaceholderViewTitle:@"未设置支付密码" operationTitle:@"前往设置"];
        [self addPlaceholderView];
        CustomPayPwdVC *tradeVC = [[CustomPayPwdVC alloc] init];
            tradeVC.success = ^() {
        
                [self removePlaceholderView];
                [self tl_placeholderOperation];
                
         };
         [self.navigationController pushViewController:tradeVC animated:YES];
        
    } else {
        
        //2.判断是否绑定了银行卡
        [TLProgressHUD showWithStatus:nil];
        __block NSInteger successCount = 0;
        
        dispatch_group_enter(_group);
        TLNetworking *ruleHttp = [TLNetworking new];
        ruleHttp.code = @"802028";
        ruleHttp.parameters[@"keyList"] = @[WITHDRAW_RULE_SHI_XIAO,
                                            WITHDRAW_RULE_MAX_COUNT_KEY,
                                            WITHDRAW_RULE_BEI_SHU_KEY,
                                            WITHDRAW_RULE_PROCEDURE_FEE_KEY,
                                            WITHDRAW_RULE_MAX_JIN_E];
        
        [ruleHttp postWithSuccess:^(id responseObject) {
            
            dispatch_group_leave(_group);
            successCount ++;
            
            self.beiShu = responseObject[@"data"][WITHDRAW_RULE_BEI_SHU_KEY];
            self.maxCount = responseObject[@"data"][WITHDRAW_RULE_MAX_COUNT_KEY];
            self.shiXiao = responseObject[@"data"][WITHDRAW_RULE_SHI_XIAO];
            self.produceFee = responseObject[@"data"][WITHDRAW_RULE_PROCEDURE_FEE_KEY];
            self.maxJinE = responseObject[@"data"][WITHDRAW_RULE_MAX_JIN_E];
            
        } failure:^(NSError *error) {
            
            dispatch_group_leave(_group);
            
        }];
        
        //
        dispatch_group_enter(_group);
        TLNetworking *http = [TLNetworking new];
        http.code = @"802016";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"token"] = [TLUser user].token;
        [http postWithSuccess:^(id responseObject) {
            
            dispatch_group_leave(_group);
            successCount ++;
            
            NSArray *banks = responseObject[@"data"];
            self.banks = [ZHBankCard tl_objectArrayWithDictionaryArray:banks];
            
            
        } failure:^(NSError *error) {
            dispatch_group_leave(_group);
            
            
        }];
        
        
        //
        dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
            
            [TLProgressHUD dismiss];
            if (successCount == 2) {
                self.getBankCardSuccess = YES;
                
                [self addPlaceholderView];
                
                if (self.banks.count > 0 ) {

                    //
                    [self setUpUI];
                    self.procedureFeeLbl.text = @"本次提现手续费：0.00";
                    
                    //时间
                    [self.moneyTf addTarget:self action:@selector(moneyChange:) forControlEvents:UIControlEventEditingChanged];
                    
                    //余额进行初始化
                    self.balanceLbl.text = [NSString stringWithFormat:@"可用余额：%@",[self.balance convertToRealMoney]];
                    
                    
                    NSMutableParagraphStyle *paragraphyStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphyStyle.lineSpacing = 5;
                    
                    NSString *flStr = [NSString stringWithFormat:@"%.f",[self.produceFee floatValue]*100];
                    
                    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"取现规则：\n1.每月最大取现次数：%@\n2.提现时效%@\n3.取现手续费率 %@%%\n4.取现必须为%@的倍数\n5.单笔最大取现金额%@",self.maxCount,self.shiXiao,flStr,self.beiShu,self.maxJinE]attributes:@{NSParagraphStyleAttributeName : paragraphyStyle}];
                    
                    
                    
                    //
                    self.withdrawRuleLbl.attributedText = attr;
                    
                } else { //无卡
                    
                    [self setPlaceholderViewTitle:@"您还未添加银行卡" operationTitle:@"前往添加"];
                    [self addPlaceholderView];
                    ZHBankCardAddVC *addVC = [[ZHBankCardAddVC alloc] init];
                    addVC.addSuccess = ^(ZHBankCard *card){
                        
                        [self tl_placeholderOperation];
                        
                    };
                    
                    [self.navigationController pushViewController:addVC animated:YES];
                    
                }
                
            } else{
                
                [self removePlaceholderView];
                
            }
            
        });
        

    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";

    self.view.backgroundColor = [UIColor backgroundColor];
    _group = dispatch_group_create();
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    
    [self tl_placeholderOperation];
    
}

- (void)beginLoad {
    
    [TLProgressHUD showWithStatus:nil];
    __block NSInteger successCount = 0;
    
    dispatch_group_enter(_group);
    TLNetworking *ruleHttp = [TLNetworking new];
    ruleHttp.code = @"802028";
    ruleHttp.parameters[@"keyList"] = @[WITHDRAW_RULE_SHI_XIAO,
                                        WITHDRAW_RULE_MAX_COUNT_KEY,
                                        WITHDRAW_RULE_BEI_SHU_KEY,
                                        WITHDRAW_RULE_PROCEDURE_FEE_KEY];
    
    [ruleHttp postWithSuccess:^(id responseObject) {
        
        dispatch_group_leave(_group);
        successCount ++;
        
        self.beiShu = responseObject[@"data"][WITHDRAW_RULE_BEI_SHU_KEY];
        self.maxCount = responseObject[@"data"][WITHDRAW_RULE_MAX_COUNT_KEY];
        self.shiXiao = responseObject[@"data"][WITHDRAW_RULE_SHI_XIAO];
        self.produceFee = responseObject[@"data"][WITHDRAW_RULE_PROCEDURE_FEE_KEY];
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_group);
        
    }];

    //
    dispatch_group_enter(_group);
    TLNetworking *http = [TLNetworking new];
    http.code = @"802016";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
     
        dispatch_group_leave(_group);
        successCount ++;
        
        NSArray *banks = responseObject[@"data"];
        self.banks = [ZHBankCard tl_objectArrayWithDictionaryArray:banks];

        
    } failure:^(NSError *error) {
        dispatch_group_leave(_group);

        
    }];
    
    
    //
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        
        [TLProgressHUD dismiss];
        if (successCount == 2) {
            self.getBankCardSuccess = YES;

            [self addPlaceholderView];
            
            if (self.banks.count > 0 ) {
                

                //
                [self setUpUI];
                self.procedureFeeLbl.text = @"本次提现手续费：0.00";
                
                //时间
                [self.moneyTf addTarget:self action:@selector(moneyChange:) forControlEvents:UIControlEventEditingChanged];
                
                
                //余额进行初始化
                self.balanceLbl.text = [NSString stringWithFormat:@"可用余额：%@",[self.balance convertToRealMoney]];
                
                
                NSMutableParagraphStyle *paragraphyStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphyStyle.lineSpacing = 5;
                
               NSString *flStr = [NSString stringWithFormat:@"%.f",[self.produceFee floatValue]*100];
                
                NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"取现规则：\n1.每月最大取现次数：%@\n2.提现时效%@%@\n3.取现手续费率 %@%%",self.maxCount,self.beiShu,self.shiXiao,flStr ]attributes:@{NSParagraphStyleAttributeName : paragraphyStyle}];

                self.withdrawRuleLbl.attributedText = attr;
                
            } else { //无卡
                
                [self setPlaceholderViewTitle:@"您还未添加银行卡" operationTitle:@"前往添加"];
                [self addPlaceholderView];
                
            }
        
        } else{
            
            [self removePlaceholderView];

        }
        
    });

    
}

#pragma mark- 输入金额改变
- (void)moneyChange:(UITextField *)moneyTf {

    if (moneyTf.text.length) {
        
        CGFloat num = [self.produceFee floatValue];
        
        self.procedureFeeLbl.text = [NSString stringWithFormat:@"本次提现手续费：%.2f",[moneyTf.text floatValue]*num];


    } else {
    
        self.procedureFeeLbl.text = @"本次提现手续费：0.00";

    }
    

}


- (void)setUpUI {

    self.bankPickTf = [[TLPickerTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 50)
                                                     leftTitle:@"银行卡"
                                                    titleWidth:90
                                                   placeholder:@"请选择银行卡"];
    [self.view addSubview:self.bankPickTf];
    self.bankPickTf.isSecurity = YES;
    
    //
    UIView *mv = [self withdrawalView];
    [self.view addSubview:mv];
    
    //支付密码按钮
    TLTextField *tradePwdTf = [[TLTextField alloc] initWithframe:CGRectMake(0, mv.yy  + 10, SCREEN_WIDTH, 50) leftTitle:@"支付密码" titleWidth:90 placeholder:@"请输入支付密码"];
    tradePwdTf.secureTextEntry = YES;
    tradePwdTf.isSecurity = YES;
    [self.view addSubview:tradePwdTf];
    self.tradePwdTf = tradePwdTf;
    
    //
    UIButton *withdrawalBtn = [UIButton zhBtnWithFrame:CGRectMake(15, tradePwdTf.yy + 30, SCREEN_WIDTH - 30, 45) title:@"提现"];
    [self.view addSubview:withdrawalBtn];
    [withdrawalBtn addTarget:self action:@selector(withdrawal) forControlEvents:UIControlEventTouchUpInside];

    //
    UILabel *hinLbl2 = [UILabel labelWithFrame:CGRectMake(15, withdrawalBtn.yy + 20, SCREEN_WIDTH - 30, 20)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor themeColor]];
    [self.view addSubview:hinLbl2];
    self.withdrawRuleLbl = hinLbl2;
    self.withdrawRuleLbl.numberOfLines = 0;
    [hinLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(withdrawalBtn.mas_bottom).offset(13);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
    
    //取出银行卡
    NSMutableArray *bankCards = [NSMutableArray arrayWithCapacity:self.banks.count];
    
    [self.banks enumerateObjectsUsingBlock:^(ZHBankCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [bankCards addObject:obj.bankcardNumber];
    }];
    
    self.bankPickTf.tagNames = bankCards;
    self.bankPickTf.text = bankCards[0];
    
}


- (void)withdrawal {
    

    
    //
    if ([self.balance isEqual:@0]) {
       
        [TLAlert alertWithHUDText:@"余额不足"];
        return;
    }

    if(![self.moneyTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请输入提现金额"];
        return;
        
    }
    
    //
    if ([self.moneyTf.text greaterThan:self.balance]) {
       
        [TLAlert alertWithHUDText:@"余额不足"];
        return;
    }
    
    if (![self.bankPickTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请选择银行卡"];
        return;
    }
    
    if (![self.tradePwdTf.text valid]) {
        
        [TLAlert alertWithHUDText:@"请输入支付密码"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802750";
    http.parameters[@"token"] = [TLUser user].token;
 
    
    http.parameters[@"accountNumber"] = self.accountNum;
    //
    http.parameters[@"amount"] = [self.moneyTf.text convertToSysMoney];   //@"-100";
    //银行卡号
    http.parameters[@"payCardNo"] = self.bankPickTf.text; //开户行信息
    


    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"applyNote"] = @"iOS用户端取现";
    http.parameters[@"tradePwd"] = self.tradePwdTf.text;

    [self.banks enumerateObjectsUsingBlock:^(ZHBankCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.bankcardNumber isEqualToString:self.bankPickTf.text ]) {
            
            http.parameters[@"payCardInfo"] = obj.bankName; //实体账户编号,

        }
    }];

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithHUDText:@"提现成功,我们将会对该交易进行审核"];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.success) {
            self.success();
        }
        
    } failure:^(NSError *error) {
        
    }];

}

- (UIView *)withdrawalView {

    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, self.bankPickTf.yy + 10, SCREEN_WIDTH, 147)];
    bgV.backgroundColor = [UIColor whiteColor];
    UILabel *hintLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, 300, 30) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:[UIFont secondFont] textColor:[UIColor textColor]];
    hintLbl.text = @"提现金额";
    hintLbl.height = [[UIFont secondFont] lineHeight];
    [bgV addSubview:hintLbl];
    
    //
    UILabel *markLbl = [UILabel labelWithFrame:CGRectMake(15, hintLbl.yy + 20, 23, 40) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:FONT(30) textColor:[UIColor colorWithHexString:@"#333333"]];
    [bgV addSubview:markLbl];
    markLbl.text = @"￥";
    markLbl.height = [FONT(25) lineHeight];
    
    //输入
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(markLbl.xx + 15, markLbl.y - 7, SCREEN_WIDTH - markLbl.xx - 5, markLbl.height)];
    [bgV addSubview:tf];
    tf.font = FONT(30);
    tf.centerY = markLbl.centerY;
    tf.placeholder = @"请输入取现金额";
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyTf = tf;
    
    
    //
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, tf.yy + 15, SCREEN_WIDTH - 15, 0.5)];
    [bgV addSubview:line];
    line.backgroundColor = [UIColor lineColor];
    
    //
    self.procedureFeeLbl = [UILabel labelWithFrame:CGRectMake(15, line.yy + 3, SCREEN_WIDTH - 15, 25)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:FONT(14)
                                         textColor:[UIColor themeColor]];
    [bgV addSubview:self.procedureFeeLbl];
    
    
    //
    UILabel *balanceLbl = [UILabel labelWithFrame:CGRectMake(15, self.procedureFeeLbl.yy, SCREEN_WIDTH - 15, 25)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:FONT(14)
                                        textColor:[UIColor lineColor]];
    [bgV addSubview:balanceLbl];
    balanceLbl.text = @"可取现余额";
    self.balanceLbl = balanceLbl;
    
   
    //
    bgV.height = balanceLbl.yy + 3;

 
    return bgV;

}


@end
