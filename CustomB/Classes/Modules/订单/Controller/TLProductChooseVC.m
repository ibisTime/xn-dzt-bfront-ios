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
    [self tl_placeholderOperation];

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TLOrderDetailVC2 *vc = [[TLOrderDetailVC2 alloc] init];
    vc.productCode = self.productRoom[indexPath.row].code;
    vc.order = self.order;
    [self.navigationController pushViewController:vc animated:YES];
    
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
