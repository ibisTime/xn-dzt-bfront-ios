//
//  TLOrderDetailVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderDetailVC.h"
#import "TLOrderModel.h"
#import "NSString+Extension.h"
#import "TLOrderDetailCell.h"
#import "TLUIHeader.h"
#import "TLNetworking.h"
#import "NBNetwork.h"
#import "AppConfig.h"

@interface TLOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, copy) NSArray  <NSDictionary *> *orderArr;
@property (nonatomic, strong) UITableView *orderDetailTableView;


@end

@implementation TLOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    
    NBCDRequest *req = [[NBCDRequest alloc] init];
    req.code = @"620906";
    req.parameters[@"type"] = @"measure";
    req.parameters[@"systemCode"] = [AppConfig config].systemCode;
    [req startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        
    } failure:^(__kindof NBBaseRequest *request) {
        
        
    }];

    
  self.orderArr =  @[
                     
       @{@"订单编号" : self.order.code},
       @{@"下单时间" : [self.order.createDatetime convertToDetailDate]},
       @{@"订单状态" : [self.order getStatusName]},
       
       @{@"姓名" : self.order.applyName},
       @{@"手机号" :  self.order.applyMobile},
       @{@"量体地址" : [self.order getDetailAddress]},
       @{@"预约时间" : [self.order.ltDatetime convertToDetailDate]},
       @{@"量体叮嘱" : self.order.remark},


       ];
    
    
    self.orderDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.orderDetailTableView];
    self.orderDetailTableView.delegate = self;
    self.orderDetailTableView.dataSource = self;
    self.orderDetailTableView.estimatedRowHeight = 45;
    self.orderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    self.orderDetailTableView.tableFooterView = footerView;
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH - 40, 40) title:@"确认量体" backgroundColor:[UIColor themeColor]];
    [footerView addSubview:btn];
    btn.centerX = SCREEN_WIDTH/2.0;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(measure) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)measure {


    

}

- (void)viewDidLayoutSubviews {

    self.orderDetailTableView.frame = self.view.bounds;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.orderArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TLOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[TLOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    
    NSString *key = self.orderArr[indexPath.row].allKeys[0];
    cell.titleLbl.text = key;
    cell.contentLbl.text = self.orderArr[indexPath.row][key];
    return cell;

}



@end
