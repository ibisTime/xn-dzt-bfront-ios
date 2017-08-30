//
//  TLLiuYanController.m
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLSysMsgVC.h"
#import "TLPageDataHelper.h"
#import "TLTableView.h"
#import "TLMsgCell.h"
#import "TLUIHeader.h"
#import "TLUser.h"
#import "TLChatRoomVC.h"
#import "AppConfig.h"
#import "TLSysMsgVC.h"
#import "TLSysMsgVC.h"
#import "TLPlaceholderView.h"

@interface TLSysMsgVC()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *liuYanTableView;
@property (nonatomic, strong) NSMutableArray <TLSysMsg *>*sysMsgRoom;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation TLSysMsgVC


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.isFirst) {
        [self.liuYanTableView beginRefreshing];
        self.isFirst = NO;
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"系统消息";
    self.isFirst = YES;
    [self setUpUI];
    
}

- (void)setUpUI {
    
    __weak typeof(self) weakself = self;
    self.liuYanTableView = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 48) delegate:self dataSource:self];
    [self.view addSubview:self.liuYanTableView];
    self.liuYanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.liuYanTableView.estimatedRowHeight = 50;
    self.liuYanTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无消息"];
    
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"804040";
    pageDataHelper.parameters[@"token"] = [TLUser user].token;
    pageDataHelper.parameters[@"channelType"] = @"4";
//    pageDataHelper.parameters[@"pushType"] = @"41";
    //    1 立即发 2 定时发
//    pageDataHelper.parameters[@"smsType"] = @"1";
//    pageDataHelper.parameters[@"status"] = @"1";
    pageDataHelper.parameters[@"toKind"] = @"2";
    pageDataHelper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    pageDataHelper.tableView = self.liuYanTableView;
    
    [pageDataHelper modelClass:[TLSysMsg class]];
    [self.liuYanTableView addRefreshAction:^{
        
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.sysMsgRoom = objs;
            [weakself.liuYanTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.liuYanTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.sysMsgRoom = objs;
            [weakself.liuYanTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sysMsgRoom.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TLMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[TLMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TLMsgCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.sysMsg = self.sysMsgRoom[indexPath.row];
    return cell;
    
}



@end
