//
//  TLProductChooseVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLProductChooseVC.h"
#import "NBNetwork.h"
#import "AppConfig.h"
#import "TLNetworking.h"
#import "TLProduct.h"
#import "NSNumber+TLAdd.h"
#import "TLUIHeader.h"
#import "TLOrderDetailVC2.h"
#import "TLProgressHUD.h"
#import "NBNetwork.h"
#import "TLUser.h"
#import "TLOrderModel.h"

@interface TLProductChooseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <TLProduct *>*productRoom;

@end


@implementation TLProductChooseVC

- (void)tl_placeholderOperation {

    [TLProgressHUD showWithStatus:nil];
    NBCDRequest *xhReq = [[NBCDRequest alloc] init];
    xhReq.code = @"620012";
    xhReq.parameters[@"status"] = @"1";
    [xhReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        [TLProgressHUD dismiss];
        NSArray *arr = request.responseObject[@"data"];
        self.productRoom =  [TLProduct tl_objectArrayWithDictionaryArray:arr];
        
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [self.view addSubview:tv];
        tv.delegate = self;
        tv.dataSource = self;
        
        
    } failure:^(__kindof NBBaseRequest *request) {
        [TLProgressHUD dismiss];

    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品选择";
    [self tl_placeholderOperation];

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TLProduct *product = self.productRoom[indexPath.row];
    

//    //选择产品是衬衫
//    NBCDRequest *req = [[NBCDRequest alloc] init];
//    req.code = @"620203";
//    req.parameters[@"modelCode"] = product.code;
//    req.parameters[@"orderCode"] = self.order.code;
//    req.parameters[@"quantity"] = @"1";
//    req.parameters[@"remark"] = @"iOS 操作";
//    req.parameters[@"updater"] = [TLUser user].userId;
//    [req startWithSuccess:^(__kindof NBBaseRequest *request) {
//        
//        //选择产品是H+
//        NSLog(@"定价成功");
//        TLOrderDetailVC2 *vc = [[TLOrderDetailVC2 alloc] init];
//        vc.productCode = self.productRoom[indexPath.row].code;
//        vc.orderCode = self.order.code;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    } failure:^(__kindof NBBaseRequest *request) {
//        
//    }];
//    
//    return;
    
    if (product.productType == TLProductTypeChenShan) {
        //选择产品是衬衫
        //定价
        NBCDRequest *req = [[NBCDRequest alloc] init];
        req.code = @"620203";
        req.parameters[@"modelCode"] = product.code;
        req.parameters[@"orderCode"] = self.order.code;
        req.parameters[@"quantity"] = @"1";
        req.parameters[@"updater"] = [TLUser user].userId;
        [req startWithSuccess:^(__kindof NBBaseRequest *request) {
            
            TLOrderDetailVC2 *vc = [[TLOrderDetailVC2 alloc] init];
            vc.productCode = self.productRoom[indexPath.row].code;
            vc.orderCode = self.order.code;
            vc.operationType = OrderOperationTypeDefault;
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(__kindof NBBaseRequest *request) {
            
        }];
        
    } else {
    
        //选择产品是H+
        TLOrderDetailVC2 *vc = [[TLOrderDetailVC2 alloc] init];
        vc.productCode = self.productRoom[indexPath.row].code;
        vc.orderCode = self.order.code;
        [self.navigationController pushViewController:vc animated:YES];
        
    }


    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.productRoom.count;
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",self.productRoom[indexPath.row].name,[self.productRoom[indexPath.row].price convertToRealMoney]];
    return cell;

}

@end
