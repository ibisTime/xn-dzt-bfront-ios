//
//  ZHBankCardListVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/15.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBankCardListVC.h"
#import "ZHBankCardAddVC.h"
//#import "ZHBankCardCell.h"
#import "TLPageDataHelper.h"
#import "ZHBankCard.h"
#import "TLUIHeader.h"
#import "TLUser.h"
#import "TLNetworking.h"
#import "TLPlaceholderView.h"
#import "CustomBankCardCell.h"
#import "ZHBankCardAddVC.h"

@interface ZHBankCardListVC()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *bankCardTV;
@property (nonatomic,strong) NSMutableArray <ZHBankCard *>*banks;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation ZHBankCardListVC

- (instancetype)init {

    if (self = [super init]) {
        self.isFirst = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        [self.bankCardTV beginRefreshing];
        self.isFirst = NO;
    }

}


- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"我的银行卡";
    
    
    TLTableView *bankCardTV = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                       delegate:self
                                                     dataSource:self];
    self.bankCardTV = bankCardTV;
    bankCardTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:bankCardTV];
    bankCardTV.rowHeight = 100;
    
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802015";
    pageDataHelper.tableView = bankCardTV;
    pageDataHelper.parameters[@"token"] = [TLUser user].token;
    pageDataHelper.parameters[@"userId"] = [TLUser user].userId;
    [pageDataHelper modelClass:[ZHBankCard class]];
    [bankCardTV addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.banks = objs;
            [weakSelf.bankCardTV reloadData_tl];
            
            if (weakSelf.banks.count > 0) {
                self.bankCardTV.tableFooterView = nil;
            } else {
            
                self.bankCardTV.tableFooterView = [self addView];
                
            }
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [bankCardTV addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.banks = objs;
            [weakSelf.bankCardTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    

    
    
    
}

- (UIView *)addView {

    //
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    
    UIButton *addBtn = [[UIButton alloc] init];
    [addView addSubview:addBtn];
    [addBtn setTitle:@"新增银行卡" forState:UIControlStateNormal];
    addBtn.layer.borderWidth = 1;
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.borderColor = [UIColor colorWithHexString:@"#b2b2b2"].CGColor;
    //
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#b2b2b2"] forState:UIControlStateNormal];
    //
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(addView.mas_left).offset(18);
        make.right.equalTo(addView.mas_right).offset(-18);
        make.top.equalTo(addView.mas_top).offset(15);
        make.height.mas_equalTo(60);
        
    }];
    
    [addBtn addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
    
    return addView;

}

- (void)addBankCard {

    ZHBankCardAddVC *vc = [[ZHBankCardAddVC alloc] init];
    vc.addSuccess = ^(ZHBankCard *card){
        
        [self.bankCardTV beginRefreshing];
        
    };
    [self.navigationController pushViewController:vc animated:YES];

}



- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                      title:@"删除"
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                        
                                                                        [self deleteBankCardWithTableView:tableView index:indexPath];
                                                                        
                                                                    }];
    
    return @[action];
    
}

//

//
- (void)deleteBankCardWithTableView:(UITableView *)tv index:(NSIndexPath *)indexPath {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"802011";
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"code"] = self.banks[indexPath.row].code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        //
        [self.bankCardTV beginRefreshing];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.banks.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    ZHBankCardAddVC *displayAddVC = [[ZHBankCardAddVC alloc] init];
    displayAddVC.bankCard = self.banks[indexPath.row];
    displayAddVC.addSuccess = ^(ZHBankCard *card){
        
        [self.bankCardTV beginRefreshing];
        
    };
    
    [self.navigationController pushViewController:displayAddVC animated:YES];

}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *bankCardCellId = @"bankCardCellId";
    CustomBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:bankCardCellId];
    if (!cell) {
        cell = [[CustomBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankCardCellId];
    }
    cell.bankCard = self.banks[indexPath.row];
    return cell;


}


@end
