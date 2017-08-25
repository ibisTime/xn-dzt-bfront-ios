//
//  TLHomeVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLHomeVC.h"
#import "TLUIHeader.h"
#import "TLOrderCell.h"
#import "TLMsgCell.h"
#import "TLHomeTableHeaderView.h"
#import "TLBannerView.h"
#import "NBNetwork.h"
#import "TLProductChooseVC.h"
#import "TLOrderDetailVC2.h"
#import "TLNetworking.h"
#import "ZHBannerModel.h"
#import "NSString+Extension.h"
#import "AppConfig.h"
#import "TLWebVC.h"

@interface TLHomeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, copy) NSArray <TLOrderModel *>*orderGroup;

@property (nonatomic, strong) TLBannerView *bannerView;
@property (nonatomic,strong) NSMutableArray <ZHBannerModel *>*bannerRoom;
@property (nonatomic,strong) NSMutableArray *bannerPics; //图片
@end

@implementation TLHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 30)
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(18)
                                      textColor:[UIColor colorWithHexString:@"#4d4d4d"]];
    titleLbl.text = @"合衣私人定制";
    self.navigationItem.titleView = titleLbl;
    
    [self setUpUI];
    //订单
    NBCDRequest *orderReq = [[NBCDRequest alloc] init];
    orderReq.code = @"620230";
    orderReq.parameters[@"start"] = @"1";
    orderReq.parameters[@"limit"] = @"5";
    [orderReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        
       NSArray *arr = request.responseObject[@"data"][@"list"];
       self.orderGroup  = [TLOrderModel tl_objectArrayWithDictionaryArray:arr];
        [self setUpUI];
        
        [self getBanner];
        
    } failure:^(__kindof NBBaseRequest *request) {
        
    }];
    
    //留言
    NBCDRequest *liuYanReq = [[NBCDRequest alloc] init];
    liuYanReq.code = @"620145";
    liuYanReq.parameters[@"start"] = @"1";
    liuYanReq.parameters[@"start"] = @"1";
    liuYanReq.parameters[@"receiver"] = [TLUser user].userId;
    [liuYanReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        
    } failure:^(__kindof NBBaseRequest *request) {
        
    }];
    
    
    
}

- (void)setUpUI {

    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 48) style:UITableViewStyleGrouped];
    [self.view addSubview:self.homeTableView];
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //tableView
    TLBannerView *headerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//    headerView.imgUrls = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503903557&di=152adb2d71faca4bb4d0820eff5385c5&imgtype=jpg&er=1&src=http%3A%2F%2Fimages0.cnblogs.com%2Fblog2015%2F780338%2F201508%2F261134016561975.png",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2084569111,4178087204&fm=26&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503903557&di=152adb2d71faca4bb4d0820eff5385c5&imgtype=jpg&er=1&src=http%3A%2F%2Fimages0.cnblogs.com%2Fblog2015%2F780338%2F201508%2F261134016561975.png"];
    self.homeTableView.tableHeaderView = headerView;
    self.bannerView = headerView;
    
    __weak typeof(self) weakSelf = self;
    self.bannerView.selected = ^(NSInteger index){
        
        TLWebVC *webVC = [[TLWebVC alloc] init];
        
        if (!(weakSelf.bannerRoom[index].url && weakSelf.bannerRoom[index].url.length > 0)) {
            return ;
        }
        webVC.url = weakSelf.bannerRoom[index].url;
        webVC.title = weakSelf.bannerRoom[index].name;
        [weakSelf.navigationController pushViewController:webVC animated:YES];
        
    };
}

- (void)getBanner {
    
//    NBCDRequest *req = [[NBCDRequest alloc] init];
//    req.code = @"805805";
//    req.parameters[@"type"] = @"2";
//    req.parameters[@"systemCode"] = [AppConfig config].systemCode;
//    req.parameters[@"companyCode"] = [AppConfig config].systemCode;
//    req.parameters[@"start"] = @"1";
//    req.parameters[@"limit"] = @"1";
//    
//    
//    [req startWithSuccess:^(__kindof NBBaseRequest *request) {
//        
//        
//    } failure:^(__kindof NBBaseRequest *request) {
//        
//    }];
    
    //广告图
    __weak typeof(self) weakSelf = self;
    TLNetworking *http = [TLNetworking new];
    http.code = @"805805";
    http.parameters[@"type"] = @"2";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"1000";
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.bannerRoom = [ZHBannerModel tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
        //组装数据
        weakSelf.bannerPics = [NSMutableArray arrayWithCapacity:weakSelf.bannerRoom.count];
        
        //取出图片
        [weakSelf.bannerRoom enumerateObjectsUsingBlock:^(ZHBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.bannerPics addObject:[obj.pic convertImageUrl]];
        }];
        
        weakSelf.bannerView.imgUrls = weakSelf.bannerPics;
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[TLOrderCell class]]) {
        
        TLOrderModel *order = self.orderGroup[indexPath.row];
        
        if ([order getOrderType] == TLOrderTypeProductUnChoose ){
            //产品未选择
            
            TLProductChooseVC *vc = [[TLProductChooseVC alloc] init];
            vc.order = order;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            //衬衫或者H+
            TLOrderDetailVC2 *vc = [[TLOrderDetailVC2 alloc] init];
            vc.orderCode = order.code;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
            
        }
        
        
    } else {
        
        
    
    }

}



#pragma mark- dataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [TLOrderCell defaultCellHeight];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {

    return 42;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section  {
    
    return 0.01;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        NSString *reuseIdentifier = @"headerId";
        TLHomeTableHeaderView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
        
        if (!v) {
            
            v = [[TLHomeTableHeaderView alloc] initWithReuseIdentifier:reuseIdentifier];
        }
        v.titleLbl.text = @"客户消息";
        return v;
    }
    
    NSString *reuseIdentifier = @"headerId";
    TLHomeTableHeaderView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    
    if (!v) {
        
        v = [[TLHomeTableHeaderView alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    v.titleLbl.text = @"订单消息";
    return v;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }
    return self.orderGroup.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        
        
        TLMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgCell"];
        if (!cell) {
            
            cell = [[TLMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"msgCell"];
        }
        
        return cell;
        
    }

    //订单
    TLOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        
        cell = [[TLOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    cell.order = self.orderGroup[indexPath.row];
    return cell;

}
@end
