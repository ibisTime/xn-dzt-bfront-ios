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
#import "TLTableView.h"

@interface TLBalanceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *balanceLbl;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataArray;
@property (nonatomic, strong) NSMutableArray <ZHCurrencyModel *>*currencyRoom;
@property (nonatomic, strong) TLTableView *balanceTableView;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation TLBalanceVC


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[[UIColor colorWithHexString:@"#cccccc"] convertToImage]];

    if (self.isFirst) {
        
        self.isFirst = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.balanceTableView beginRefreshing];
        });
        
    }
    

}

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
    
    self.isFirst = YES;
    self.title = @"账户余额";
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:2];
    [self setUpUI];
    [self.dataArray addObject:@{ @"总收入" : @"￥--"
                                 }];
    [self.dataArray addObject:@{ @"已提现金额" : @"￥--"
                                 }];
    
    //
    __weak typeof(self) weakself = self;
    [self.balanceTableView addRefreshAction:^{
       
        NBCDRequest *balanceReq = [[NBCDRequest alloc] init];
        balanceReq.code = @"802503";
        balanceReq.parameters[@"token"] = [TLUser user].token;
        balanceReq.parameters[@"userId"] = [TLUser user].userId;
        
        NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[balanceReq]];
        [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
            
            [weakself.balanceTableView endRefreshHeader];
            NBCDRequest *balance = (NBCDRequest *)batchRequest.reqArray[0];
            weakself.currencyRoom = [ZHCurrencyModel tl_objectArrayWithDictionaryArray:balance.responseObject[@"data"]];
            [weakself.currencyRoom enumerateObjectsUsingBlock:^(ZHCurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.currency isEqualToString:kCNY]) {
                    
                    weakself.balanceLbl.text =  [NSString stringWithFormat:@"￥%@",[obj.amount convertToRealMoney]];
                    [weakself.dataArray removeAllObjects];
                    
                    //
                    [weakself.dataArray addObject:@{@"总收入" : [obj.addAmount convertToRealMoney]}];
                    [weakself.dataArray addObject:@{@"已提现金额" : [obj.outAmount convertToRealMoney]}];

                    [weakself.balanceTableView reloadData_tl];
                    
                }
                
            }];
            
        } failure:^(NBBatchReqest *batchRequest) {
            
            [weakself.balanceTableView endRefreshHeader];
            
        }];
        
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.leftLbl.text = dict.allKeys[0];
    cell.rightLbl.text = dict[cell.leftLbl.text];
    return cell;

}


//
- (void)setUpUI {

    self.balanceTableView =  [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60) delegate:self dataSource:self];
    [self.view addSubview:self.balanceTableView];
    self.balanceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.balanceTableView.rowHeight = 60;
    
    //
    UIButton *withdrawBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.balanceTableView.yy, SCREEN_WIDTH - 36, 40) ];
    [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    withdrawBtn.layer.cornerRadius = 5;
    withdrawBtn.layer.masksToBounds = YES;
    withdrawBtn.backgroundColor = [UIColor themeColor];
    [self.view addSubview:withdrawBtn];
    
    [withdrawBtn setBackgroundColor:[UIColor themeColor] forState:UIControlStateNormal];
    [withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [withdrawBtn addTarget:self action:@selector(goWithdraw) forControlEvents:UIControlEventTouchUpInside];
    withdrawBtn.centerX = SCREEN_WIDTH/2.0;
    
    //
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.balanceTableView.tableHeaderView = contentView;
    
    
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
