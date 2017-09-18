//
//  TLCustomerCategoryVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLCustomerCategoryVC.h"
#import "TLTableView.h"
#import "TLUIHeader.h"
#import "TLPageDataHelper.h"
#import "TLPlaceholderView.h"
#import "TLUser.h"
#import "TLNetworking.h"
#import "TLCustomerCell.h"
#import "AppConfig.h"
#import "TLCustomer.h"
#import "TLCustomerDetailVC.h"
#import <MJRefresh/MJRefresh.h>

@interface TLCustomerCategoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *customerTableView;
@property (nonatomic,strong) NSMutableArray <TLCustomer *>*customerGroups;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation TLCustomerCategoryVC


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
        if (self.isFirst) {
    
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
                [self.customerTableView beginRefreshing];
                self.isFirst = NO;
    
            });
    
    }
    
}


- (void)viewDidLayoutSubviews {

    self.customerTableView.frame = self.view.bounds;

}

//
- (void)tl_placeholderOperation {

    
    [self.customerTableView beginRefreshing];
    
}

//
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    TLTableView *tableView = [TLTableView tableViewWithframe:self.view.bounds delegate:self dataSource:self];
    [self.view addSubview:tableView];
    
    self.customerTableView = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无客户"];
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"805120";
    helper.parameters[@"systemCode"] = [AppConfig config].systemCode;
    helper.parameters[@"companyCode"] = [AppConfig config].systemCode;
    helper.parameters[@"ltUser"] = [TLUser user].userId;

    helper.parameters[@"kind"] = @"C";
    if (self.status && self.status.length > 0) {
        
        helper.parameters[@"frequent"] = self.status;

    }
    
    helper.isDeliverCompanyCode = NO;
    helper.tableView = self.customerTableView;
    [helper modelClass:[TLCustomer class]];
    
    //-----//
    __weak typeof(self) weakSelf = self;
    [self.customerTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            weakSelf.customerGroups = objs;
            [weakSelf.customerTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
        
    }];
    
    [self.customerTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.customerGroups = objs;
            [weakSelf.customerTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.customerTableView endRefreshingWithNoMoreData_tl];
    
    self.customerTableView.contentInset = UIEdgeInsetsMake(24, 0, 0, 0);
    self.customerTableView.mj_header.ignoredScrollViewContentInsetTop = 24;

}




#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TLCustomerDetailVC *vc = [[TLCustomerDetailVC alloc] init];
    vc.customer = self.customerGroups[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [TLCustomerCell defaultCellHeight];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.customerGroups.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhOrderGoodsCellId = @"ZHOrderGoodsCell";
    TLCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:zhOrderGoodsCellId];
    if (!cell) {
        
        cell = [[TLCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhOrderGoodsCellId];
        
    }
        
    cell.customer = self.customerGroups[indexPath.row];
    return cell;
    
}




@end
