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
#import "TLOrderDetailVC2.h"
#import "TLNetworking.h"
#import "ZHBannerModel.h"
#import "NSString+Extension.h"
#import "AppConfig.h"
#import "TLWebVC.h"
#import "CustomLiuYanModel.h"
#import "TLChatRoomVC.h"
#import "TLLiuYanController.h"
#import "TLTableView.h"
#import "TLPageDataHelper.h"
#import "Const.h"
#import "TLConfirmPriceVC.h"
#import "TLAlert.h"
#import "TLRefreshEngine.h"
#import "SVProgressHUD.h"
#import "ImageUtil.h"
#import "TLMianLiaoChooseVC.h"

@interface TLHomeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView  *homeTableView;

@property (nonatomic, strong) TLBannerView *bannerView;
@property (nonatomic,strong) NSMutableArray <ZHBannerModel *>*bannerRoom;
@property (nonatomic,strong) NSMutableArray *bannerPics; //图片

@property (nonatomic, strong) NSMutableArray <CustomLiuYanModel *>*liuYanRoom;
@property (nonatomic, copy) NSArray <TLOrderModel *>*orderGroup;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation TLHomeVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (self.isFirst) {
        
        [self.homeTableView beginRefreshing];
        self.isFirst =  NO;
    }
    
    
    
   [TLRefreshEngine engine].outMark = NSStringFromClass([self class]);
   if ([[TLRefreshEngine engine] canRefresh]) {
            
       [self.homeTableView beginRefreshing];
       [[TLRefreshEngine engine] clear];
             
   } else {
            
      [[TLRefreshEngine engine] clear];
            
   }
        
        
    
}

- (void)viewDidLayoutSubviews {
    
    self.homeTableView.frame = self.view.bounds;
    
}

//
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    //
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 30)
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(18)
                                      textColor:[UIColor colorWithHexString:@"#4d4d4d"]];
    titleLbl.text = @"合衣私人定制";
    self.navigationItem.titleView = titleLbl;
    
    self.liuYanRoom = [[NSMutableArray alloc] init];
    self.orderGroup  = [[NSMutableArray alloc] init];
    
    [self setUpUI];
//    [self getBanner];
    

    
  
    
    
}

#pragma mark- 获得留言
- (void)getLiuYan {

    //留言
    NBCDRequest *liuYanReq = [[NBCDRequest alloc] init];
    liuYanReq.code = @"620148";
    liuYanReq.parameters[@"start"] = @"1";
    liuYanReq.parameters[@"limit"] = @"1";
    liuYanReq.parameters[@"receiver"] = [TLUser user].userId;
    liuYanReq.parameters[@"type"] = @"1";
    
//    liuYanReq.ignoreCache = NO;
//    if ([liuYanReq checkCache]) {
//        id resp = [liuYanReq getCache];
//        self.liuYanRoom = [CustomLiuYanModel tl_objectArrayWithDictionaryArray:resp[@"data"][@"list"]];
//        [self.homeTableView reloadData];
//        
//    }
    
    [liuYanReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        self.liuYanRoom = [CustomLiuYanModel tl_objectArrayWithDictionaryArray:request.responseObject[@"data"][@"list"]];
        [self.homeTableView reloadData];
        
    } failure:^(__kindof NBBaseRequest *request) {
        
        
        
    }];
}

- (void)setUpUI {

    __weak typeof(self) weakself = self;
    self.homeTableView = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, 0) delegate:self dataSource:self];
    [self.view addSubview:self.homeTableView];
    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"620230";
    pageDataHelper.parameters[@"ltUser"] = [TLUser user].userId;
    pageDataHelper.tableView = self.homeTableView;
    //
    pageDataHelper.parameters[@"statusList"] = @[kOrderStatusDidPay,kOrderStatusWillMeasurement,kOrderStatusDidDingJia,kOrderStatusWillCheck];
    [pageDataHelper modelClass:[TLOrderModel class]];
    [self.homeTableView addRefreshAction:^{
        [weakself getBanner];
        [weakself getLiuYan];
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.orderGroup = objs;
            [weakself.homeTableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    //
    [self.homeTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.orderGroup = objs;
            [weakself.homeTableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    //tableView
    CGFloat h = (SCREEN_WIDTH - 19*2)*430/750 + 35;
    UIView *bannerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
    self.homeTableView.tableHeaderView = bannerBgView;

    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(19, 10, SCREEN_WIDTH - 38, bannerBgView.height)];
    [bannerBgView addSubview:bannerView];

    self.bannerView = bannerView;
    
//    __weak typeof(self) weakSelf = self;
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
    NBCDRequest *bannerReq =  [[NBCDRequest alloc] init];
    bannerReq.code = @"805806";
    bannerReq.parameters[@"type"] = @"2";
    bannerReq.parameters[@"belong"] = @"1";
    bannerReq.parameters[@"companyCode"] = [AppConfig config].systemCode;
    bannerReq.parameters[@"systemCode"] = [AppConfig config].systemCode;
//    bannerReq.ignoreCache = NO;
//    
//    if([bannerReq checkCache]) {
//    
//       id responseObject = [bannerReq getCache];
//    
//        weakSelf.bannerRoom = [ZHBannerModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
//        //组装数据
//        weakSelf.bannerPics = [NSMutableArray arrayWithCapacity:weakSelf.bannerRoom.count];
//        
//        //取出图片
//        [weakSelf.bannerRoom enumerateObjectsUsingBlock:^(ZHBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [weakSelf.bannerPics addObject:[obj.pic convertImageUrl]];
//        }];
//        
//        weakSelf.bannerView.imgUrls = weakSelf.bannerPics;
//        
//    }
    
    [bannerReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        weakSelf.bannerRoom = [ZHBannerModel tl_objectArrayWithDictionaryArray:request.responseObject[@"data"]];
        //组装数据
        weakSelf.bannerPics = [NSMutableArray arrayWithCapacity:weakSelf.bannerRoom.count];
        
        //取出图片
        [weakSelf.bannerRoom enumerateObjectsUsingBlock:^(ZHBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf.bannerPics addObject: [ImageUtil convertImageUrl:obj.pic imageServerUrl:[AppConfig config].qiniuDomain]];
            
        }];
        
        weakSelf.bannerView.imgUrls = weakSelf.bannerPics;
        
    } failure:^(__kindof NBBaseRequest *request) {
        
        
    }];
    
}


#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
  

    
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[TLOrderCell class]]) {
        
        TLOrderModel *order = self.orderGroup[indexPath.row];

        if ([order.status isEqualToString:kOrderStatusCancle]) {
            
            [TLAlert alertWithInfo:@"该订单已取消"];
            return;
            
        }
        
        [TLRefreshEngine engine].inMark = NSStringFromClass([self class]);

        if ([order getOrderType] == TLOrderTypeProductUnChoose ||
            [order getOrderType] == TLOrderTypeHAddUnDingJia ||
            [order getOrderType] == TLOrderTypeChenShanUnDingJia){
            
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
        
    } else {
        
        TLChatRoomVC *vc = [[TLChatRoomVC alloc] init];
        vc.otherUserId = [self.liuYanRoom[indexPath.row] otherUserId];
        vc.otherName = [self.liuYanRoom[indexPath.row] otherUserName];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
     return 2;
   
    
}

//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {


    
    NSString *reuseIdentifier = @"headerId";
    TLHomeTableHeaderView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    
    if (!v) {
        
        v = [[TLHomeTableHeaderView alloc] initWithReuseIdentifier:reuseIdentifier];
    }

    v.section = section;

    if (section == 0 ) {

        v.titleLbl.text = @"客户消息";
        
   } else {

        v.titleLbl.text = @"订单消息";

    }
    __weak typeof(self) weakSelf = self;
    [v setAction:^(NSInteger section){

//        TLMianLiaoChooseVC *vc = [[TLMianLiaoChooseVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        return ;
        
        if (section == 0) {
        
            TLLiuYanController *vc = [[TLLiuYanController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            weakSelf.tabBarController.selectedIndex = 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderAll" object:nil];
        
        }
    }];

    return v;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.liuYanRoom.count;
    }
    
    return self.orderGroup.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        TLMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgCell"];
        if (!cell) {
            
            cell = [[TLMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"msgCell"];
        }
        cell.model = self.liuYanRoom[indexPath.row];
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
