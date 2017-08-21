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
#import "TLOrderModel.h"
#import "TLPageDataHelper.h"
#import "TLPlaceholderView.h"
#import "TLUser.h"
#import "TLNetworking.h"
#import "TLCustomerCell.h"

@interface TLCustomerCategoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *customerTableView;
@property (nonatomic,strong) NSMutableArray <TLOrderModel *>*orderGroups;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation TLCustomerCategoryVC


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //    if (self.isFirst) {
    //
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //            [self.customerTableView beginRefreshing];
    //            self.isFirst = NO;
    //
    //        });
    //
    //
    //    }
    
}


- (void)viewDidLayoutSubviews {

    self.customerTableView.frame = self.view.bounds;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    TLTableView *tableView = [TLTableView tableViewWithframe:self.view.bounds delegate:self dataSource:self];
    [self.view addSubview:tableView];
    //    tableView.contentOffset = CGPointMake(0, -24);
    //    tableView.contentInset = UIEdgeInsetsMake(24, 0, 0, 0);
    
    self.customerTableView = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无订单"];
    
    //--//
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808068";
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"applyUser"] = [TLUser user].userId;
    helper.isDeliverCompanyCode = NO;
    
//    if (self.status == TLOrderStatusWillPay) {
//        
//        helper.parameters[@"status"] = @"1";
//        
//    } else if(self.status == TLOrderStatusDidPay) {
//        
//        helper.parameters[@"status"] = @"3";
//        
//    } else if(self.status == TLOrderStatusWillSend)  {
//        
//        helper.parameters[@"status"] = @"2";
//        
//    } else if(self.status == TLOrderStatusDidFinish) {//全部
//        
//        helper.parameters[@"status"] = @"4";
//        
//        
//    }
    
    
    //    1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
    
    //    if (self.statusCode) {
    //        helper.parameters[@"status"] = self.statusCode;
    //    }
    helper.tableView = self.customerTableView;
    [helper modelClass:[TLOrderModel class]];
    
    //-----//
    __weak typeof(self) weakSelf = self;
    [self.customerTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            weakSelf.orderGroups = objs;
            [weakSelf.customerTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
        
    }];
    
    [self.customerTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.customerTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.customerTableView endRefreshingWithNoMoreData_tl];
    
}




#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [TLCustomerCell defaultCellHeight];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhOrderGoodsCellId = @"ZHOrderGoodsCell";
    TLCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:zhOrderGoodsCellId];
    if (!cell) {
        
        cell = [[TLCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhOrderGoodsCellId];
        
    }
    
    //    cell.order = self.orderGroups[indexPath.section];
    
    return cell;
    
}




@end
