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
#import "CustomLiuYanModel.h"
#import "TLChatRoomVC.h"
#import "TLLiuYanController.h"

@interface TLHomeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *homeTableView;

@property (nonatomic, strong) TLBannerView *bannerView;
@property (nonatomic,strong) NSMutableArray <ZHBannerModel *>*bannerRoom;
@property (nonatomic,strong) NSMutableArray *bannerPics; //图片

@property (nonatomic, strong) NSMutableArray <CustomLiuYanModel *>*liuYanRooom;
@property (nonatomic, copy) NSArray <TLOrderModel *>*orderGroup;

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
    
    self.liuYanRooom = [[NSMutableArray alloc] init];
    self.orderGroup  = [[NSMutableArray alloc] init];
    
    [self setUpUI];
    [self getBanner];
    

    
    //留言
    NBCDRequest *liuYanReq = [[NBCDRequest alloc] init];
    liuYanReq.code = @"620145";
    liuYanReq.parameters[@"start"] = @"1";
    liuYanReq.parameters[@"limit"] = @"1";
    liuYanReq.parameters[@"receiver"] = [TLUser user].userId;
    liuYanReq.parameters[@"type"] = @"1";
    [liuYanReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        self.liuYanRooom = [CustomLiuYanModel tl_objectArrayWithDictionaryArray:request.responseObject[@"data"][@"list"]];
        

        //订单
        NBCDRequest *orderReq = [[NBCDRequest alloc] init];
        orderReq.code = @"620230";
        orderReq.parameters[@"start"] = @"1";
        orderReq.parameters[@"limit"] = @"5";
        [orderReq startWithSuccess:^(__kindof NBBaseRequest *request) {
            
            NSArray *arr = request.responseObject[@"data"][@"list"];
            self.orderGroup  = [TLOrderModel tl_objectArrayWithDictionaryArray:arr];
            [self.homeTableView reloadData];
            
        } failure:^(__kindof NBBaseRequest *request) {
            
        }];
        
        
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
        
        TLChatRoomVC *vc = [[TLChatRoomVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.liuYanRooom.count && self.orderGroup.count) {
        return 2;
    } else if (self.liuYanRooom.count || self.orderGroup.count) {
    
        return 1;
    } else {
    
        return 0;
    }
    
}

//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {


    
    NSString *reuseIdentifier = @"headerId";
    TLHomeTableHeaderView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    
    if (!v) {
        
        v = [[TLHomeTableHeaderView alloc] initWithReuseIdentifier:reuseIdentifier];
    }

    v.section = section;

    if (section == 0 && self.liuYanRooom.count > 0) {

        v.titleLbl.text = @"客户消息";
        
   } else {

        v.titleLbl.text = @"订单消息";

    }
    __weak typeof(self) weakSelf = self;
    [v setAction:^(NSInteger section){
        
        if (section == 0) {
        
            TLLiuYanController *vc = [[TLLiuYanController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            self.tabBarController.selectedIndex = 1;
        
        
        }
        
    }];

    
    return v;

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
        cell.model = self.liuYanRooom[indexPath.row];
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
