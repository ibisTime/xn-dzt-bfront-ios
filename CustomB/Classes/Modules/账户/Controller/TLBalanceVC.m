//
//  TLBalanceVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBalanceVC.h"
#import "TLUIHeader.h"
#import "TLBalanceCell.h"
#import "NBNetwork.h"
#import "TLProgressHUD.h"
#import "AppConfig.h"
#import "TLUser.h"
#import "ZHCurrencyModel.h"
#import "NSNumber+TLAdd.h"
#import "ZHBillVC.h"
#import "ZHWithdrawalVC.h"

@interface TLBalanceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *balanceLbl;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataArray;
@property (nonatomic, strong) NSMutableArray <ZHCurrencyModel *>*currencyRoom;

@end

@implementation TLBalanceVC

- (void)goDetail {

    ZHBillVC *billVC = [[ZHBillVC alloc] init];
    billVC.displayHeader = YES;
    [self.currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.currency isEqualToString:kCNY]) {
            
            billVC.accountNumber = obj.accountNumber;
            
        }
        
    }];
    
    [self.navigationController pushViewController:billVC animated:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账户余额";
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:2];

    
    [TLProgressHUD showWithStatus:nil];
    NBCDRequest *balanceReq = [[NBCDRequest alloc] init];
    balanceReq.code = @"802503";
//    req.parameters[@"systemCode"] = [AppConfig config].systemCode;
//    req.parameters[@"companyCode"] = [AppConfig config].systemCode;
    balanceReq.parameters[@"token"] = [TLUser user].token;
    balanceReq.parameters[@"userId"] = [TLUser user].userId;
    
    NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[balanceReq]];
    [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
        [TLProgressHUD dismiss];
     NBCDRequest *balance = (NBCDRequest *)batchRequest.reqArray[0];
     self.currencyRoom = [ZHCurrencyModel tl_objectArrayWithDictionaryArray:balance.responseObject[@"data"]];
        [self.currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.currency isEqualToString:kCNY]) {
                
                self.balanceLbl.text =  [NSString stringWithFormat:@"￥%@",[obj.amount convertToRealMoney]];

            }
            
        }];
        
        //    cell.rightLbl.text = @"已提现金额";
        
        [self.dataArray addObject:@{ @"总收入" : @"￥1212"
                                     }];
        [self.dataArray addObject:@{ @"已提现金额" : @"￥1212"
                                     }];
        
        [self setUpUI];
        
        

    } failure:^(NBBatchReqest *batchRequest) {
        
        [TLProgressHUD dismiss];

    }];
    

    
}

- (void)goWithdraw {

    ZHWithdrawalVC *vc =[[ZHWithdrawalVC alloc] init];
    
    [self.currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.currency isEqualToString:kCNY]) {
            
            vc.balance = obj.amount;
            vc.accountNum = obj.accountNumber;

        }
        
    }];
    [self.navigationController pushViewController:vc animated:YES];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TLBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLBalanceCell"];
    if (!cell) {
        
        cell = [[TLBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TLBalanceCell"];
        
    }
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.leftLbl.text = dict.allKeys[0];
    cell.rightLbl.text = dict[cell.leftLbl.text];
    return cell;

}


//
- (void)setUpUI {

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 60;
    
    //
    UIButton *withdrawBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tableView.yy, SCREEN_WIDTH - 36, 40) title:@"提现" backgroundColor:[UIColor themeColor] cornerRadius:5];
    [self.view addSubview:withdrawBtn];
    [withdrawBtn setBackgroundColor:[UIColor themeColor] forState:UIControlStateNormal];
    [withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [withdrawBtn addTarget:self action:@selector(goWithdraw) forControlEvents:UIControlEventTouchUpInside];
    withdrawBtn.centerX = SCREEN_WIDTH/2.0;
    
    //
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    tableView.tableHeaderView = contentView;
    
    
    //
    UIView *topBgView = [[UIView alloc] init];
    [contentView addSubview:topBgView];
    topBgView.layer.cornerRadius = 125;
    topBgView.layer.masksToBounds = YES;
    topBgView.layer.borderColor = [UIColor themeColor].CGColor;
    topBgView.layer.borderWidth =  1;
    topBgView.layer.masksToBounds = YES;
    
    //
    UILabel *textLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(18)
                                     textColor:[UIColor colorWithHexString:@"#4d4d4d"]];
    [contentView addSubview:textLbl];
    textLbl.text = @"账户余额";
    
    //
    self.balanceLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:FONT(36)
                                    textColor:[UIColor colorWithHexString:@"#dab616"]];
    [contentView addSubview:self.balanceLbl];
    self.balanceLbl.text = @"--";
    //
    
    UIButton *goDetailBtn = [[UIButton alloc] init];
    [contentView addSubview:goDetailBtn];
    [goDetailBtn setTitle:@"点击查看明细" forState:UIControlStateNormal];
    [goDetailBtn setTitleColor:[UIColor colorWithHexString:@"#b0b0b0"] forState:UIControlStateNormal];
    goDetailBtn.titleLabel.font = FONT(14);
    [goDetailBtn addTarget:self action:@selector(goDetail) forControlEvents:UIControlEventTouchUpInside];
    
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(250);
        make.center.equalTo(contentView);
    }];
    
    [self.balanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topBgView.mas_centerY);
        make.centerX.equalTo(topBgView.mas_centerX);
    }];
    
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.balanceLbl.mas_top).offset(-21);
        make.centerX.equalTo(topBgView.mas_centerX);
    }];
    
    [goDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.balanceLbl.mas_bottom).offset(24);
        make.centerX.equalTo(contentView.mas_centerX);
        
    }];
    
    //
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView.mas_left).offset(18);
        make.right.equalTo(contentView.mas_right).offset(-18);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(contentView.mas_bottom);
        
    }];
    


}



@end
