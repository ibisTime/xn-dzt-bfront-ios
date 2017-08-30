//
//  TLOrderCategoryVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderCategoryVC.h"
#import "TLTableView.h"
#import "TLUIHeader.h"
#import "TLOrderModel.h"
#import "TLPageDataHelper.h"
#import "TLPlaceholderView.h"
#import "TLUser.h"
#import "TLNetworking.h"
#import "TLOrderCell.h"
#import "Const.h"
#import "TLOrderDetailVC.h"
#import "TLOrderDetailVC2.h"
#import "TLProductChooseVC.h"
#import "TLConfirmPriceVC.h"
#import "TLAlert.h"

@interface TLOrderCategoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *orderTableView;
@property (nonatomic,strong) NSMutableArray <TLOrderModel *>*orderGroups;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation TLOrderCategoryVC


- (void)viewDidLayoutSubviews {
    
    self.orderTableView.frame = self.view.bounds;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (self.isFirst) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.orderTableView beginRefreshing];
            self.isFirst = NO;
            
        });
        
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
//    tableView.contentOffset = CGPointMake(0, -24);
//    tableView.contentInset = UIEdgeInsetsMake(24, 0, 0, 0);
    
    self.orderTableView = tableView;
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无订单"];
    
    //--//
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"620230";
    helper.parameters[@"ltUser"] = [TLUser user].userId;
//    helper.parameters[@"applyUser"] = [TLUser user].userId;
    
    switch (self.status) {
        case TLOrderStatusWillMeasurement: {
        
            helper.parameters[@"status"] = kOrderStatusWillMeasurement;
            
        } break;
        case TLOrderStatusWillPay: {
            
            helper.parameters[@"status"] = kOrderStatusDidDingJia;
            
        } break;
            
        case TLOrderStatusWillSubmit: {
            
            helper.parameters[@"status"] = kOrderStatusDidPay;
            
        } break;
            
        case TLOrderStatusWillCheck: {
            
            helper.parameters[@"status"] = kOrderStatusWillCheck;
            
        } break;
            
 
        default: {
        
            
        
        }
            break;
    }

    
    //    1待支付 2 已支付待发货 3 已发货待收货 4 已收货 91用户取消 92 商户取消 93 快递异常
    
    //    if (self.statusCode) {
    //        helper.parameters[@"status"] = self.statusCode;
    //    }
    helper.tableView = self.orderTableView;
    [helper modelClass:[TLOrderModel class]];
    
    //-----//
    __weak typeof(self) weakSelf = self;
    [self.orderTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf removePlaceholderView];
            weakSelf.orderGroups = objs;
            [weakSelf.orderTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
        
    }];
    
    [self.orderTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orderGroups = objs;
            [weakSelf.orderTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.orderTableView endRefreshingWithNoMoreData_tl];
    
}


- (void)tl_placeholderOperation {

    [self.orderTableView beginRefreshing];

}


#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0) {
        
        TLOrderDetailVC *vc = [[TLOrderDetailVC alloc] init];
        vc.order  = self.orderGroups[indexPath.row];
        [self.navigationController pushViewController:vc
                                             animated:YES];
        
    } else {
        
        TLOrderModel *order = self.orderGroups[indexPath.row];
    
        if ([order.status isEqualToString:kOrderStatusCancle]) {
            
            [TLAlert alertWithInfo:@"该订单已取消"];
            return;
            
        }
        
            
            if ([order getOrderType] == TLOrderTypeProductUnChoose ){
            
            //产品未选择
            TLConfirmPriceVC *vc = [[TLConfirmPriceVC alloc] init];
            vc.order = order;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            //衬衫或者H+
            TLOrderDetailVC2 *vc = [[TLOrderDetailVC2 alloc] init];
            vc.orderCode = order.code;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
            
        }
        
        
    }

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [TLOrderCell defaultCellHeight];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.orderGroups.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhOrderGoodsCellId = @"ZHOrderGoodsCell";
    TLOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:zhOrderGoodsCellId];
    if (!cell) {
        
        cell = [[TLOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhOrderGoodsCellId];
        
    }

    cell.order = self.orderGroups[indexPath.row];
    
    return cell;
    
}




@end
