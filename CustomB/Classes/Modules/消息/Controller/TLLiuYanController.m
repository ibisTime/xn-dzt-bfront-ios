//
//  TLLiuYanController.m
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLLiuYanController.h"
#import "TLPageDataHelper.h"
#import "TLTableView.h"
#import "CustomLiuYanModel.h"
#import "TLMsgCell.h"
#import "TLUIHeader.h"
#import "TLUser.h"
#import "TLChatRoomVC.h"
#import "TLPlaceholderView.h"
#import "DeviceUtil.h"

@interface TLLiuYanController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *liuYanTableView;
@property (nonatomic, strong) NSMutableArray <CustomLiuYanModel *>*liuYanRoom;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation TLLiuYanController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.isFirst) {
        [self.liuYanTableView beginRefreshing];
        self.isFirst = NO;
    }
    
}


- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"客户消息";
    self.isFirst = YES;
    [self setUpUI];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    TLChatRoomVC *vc = [[TLChatRoomVC alloc] init];
    vc.otherUserId = [self.liuYanRoom[indexPath.row] otherUserId];
    vc.otherName = [self.liuYanRoom[indexPath.row] otherUserName];
    [self.navigationController pushViewController:vc animated:YES];
    

}


- (void)setUpUI {
    
    __weak typeof(self) weakself = self;
    self.liuYanTableView = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - 48) delegate:self dataSource:self];
    [self.view addSubview:self.liuYanTableView];
    self.liuYanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.liuYanTableView.estimatedRowHeight = 50;
    self.liuYanTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无留言"];
    
    //
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"620148";
    pageDataHelper.parameters[@"receiver"] = [TLUser user].userId;
    pageDataHelper.parameters[@"type"] = @"1";
    
    pageDataHelper.tableView = self.liuYanTableView;
    [pageDataHelper modelClass:[CustomLiuYanModel class]];
    [self.liuYanTableView addRefreshAction:^{
   
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.liuYanRoom = objs;
            [weakself.liuYanTableView reloadData_tl];
     
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.liuYanTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.liuYanRoom = objs;
            [weakself.liuYanTableView reloadData_tl];
            
 
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.liuYanRoom.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TLMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[TLMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TLMsgCellID"];
        
    }
    
    cell.model = self.liuYanRoom[indexPath.row];
    return cell;

}



@end
