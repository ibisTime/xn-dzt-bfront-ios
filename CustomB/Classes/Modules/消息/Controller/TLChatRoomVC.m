//
//  TLChatRoomVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLChatRoomVC.h"
#import "NBNetwork.h"
#import "TLUser.h"
#import "TLChatCell.h"
#import "TLTableView.h"
#import "TLUIHeader.h"
#import "CustomLiuYanModel.h"
#import "TLPageDataHelper.h"
#import "TLAlert.h"
#import "TLProgressHUD.h"
#import "MJRefresh.h"
#import "DeviceUtil.h"

@interface TLChatRoomVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *chatTableView;
@property (nonatomic, strong) NSMutableArray *chatModelRoom;
@property (nonatomic, strong) UIView *bootomBgView;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation TLChatRoomVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (self.isFirst) {
        [self.chatTableView.mj_footer beginRefreshing];
//        beginRefreshing];
        self.isFirst = NO;
    }
    
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.isFirst = YES;

    if (!self.otherUserId || !self.otherName) {
        
        NSLog(@"请传入对方的userID 和 名称");
        return;
    }
    
    self.title = self.otherName;
    //
    CGFloat bottomHeight = 60;
    self.chatTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - bottomHeight) delegate:self dataSource:self];
    [self.view addSubview:self.chatTableView];
    self.chatTableView.estimatedRowHeight =  50;
    self.chatTableView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    
//    NBCDRequest *req = [[NBCDRequest alloc] init];
//    req.code = @"620149";
//    req.parameters[@"receiver"] = [TLUser user].userId;
//    req.parameters[@"commenter"] = @"U201708231336531301754";
//    req.parameters[@"start"] = @"1";
//    req.parameters[@"limit"] = @"10";
//    [req startWithSuccess:^(__kindof NBBaseRequest *request) {
//        
//        self.chatModelRoom = [CustomLiuYanModel tl_objectArrayWithDictionaryArray:request.responseObject[@"data"][@"list"]];
//        [self.chatTableView reloadData];
//        
//    } failure:^(__kindof NBBaseRequest *request) {
//        
//        
//    }];
    
    //
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"620149";
    pageDataHelper.parameters[@"receiver"] = [TLUser user].userId;
    pageDataHelper.parameters[@"commenter"] = self.otherUserId;
//    pageDataHelper.limit = 1;
    [pageDataHelper modelClass:[CustomLiuYanModel class]];
    [self.chatTableView addRefreshAction:^{
    
      
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf.chatTableView endRefreshHeader];
            
            NSEnumerator *enumerator = [objs reverseObjectEnumerator];
            weakSelf.chatModelRoom = [enumerator.allObjects mutableCopy];
            //            weakSelf.chatModelRoom = objs;
            
            if (!stillHave) {
                pageDataHelper.start ++;
            }
            
            [weakSelf.chatTableView reloadData];

//            if (weakSelf.chatModelRoom.count) {
//                
//                [weakSelf.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: weakSelf.chatModelRoom.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//            }
            
        } failure:^(NSError *error) {
            
            [weakSelf.chatTableView endRefreshHeader];
            
        }];
        
  
    }];
    
    
    [self.chatTableView addLoadMoreAction:^{
     
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            [weakSelf.chatTableView endRefreshFooter];
            
            NSEnumerator *enumerator = [objs reverseObjectEnumerator];
            weakSelf.chatModelRoom = [enumerator.allObjects mutableCopy];
            [weakSelf.chatTableView reloadData];
      
            //
            [weakSelf.chatTableView resetNoMoreData_tl];
            
            if (!stillHave) {
                pageDataHelper.start ++;
            }
            
            if (weakSelf.chatModelRoom.count) {
//                [weakSelf.chatTableView scrollRectToVisible:CGRectMake(0, MAXFLOAT, 100, 10) animated:NO];
//                CGFloat offfsetY = (weakSelf.chatTableView.contentSize.height - weakSelf.chatTableView.height) > 0 ? (weakSelf.chatTableView.contentSize.height - weakSelf.chatTableView.height) : 0;
//                [weakSelf.chatTableView  setContentOffset:CGPointMake(0, offfsetY)];
//                weakSelf.chatTableView.contentSize
                //
                [weakSelf.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: weakSelf.chatModelRoom.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
        } failure:^(NSError *error) {
            
            [weakSelf.chatTableView endRefreshFooter];
            
        }];
        
        
    }];
    
    //
   MJRefreshNormalHeader *refreshStateHeader =  (MJRefreshNormalHeader *)self.chatTableView.mj_header;
    
    refreshStateHeader.lastUpdatedTimeLabel.hidden = YES;
    [refreshStateHeader setTitle:@"加载历史" forState:MJRefreshStateIdle];
    [refreshStateHeader setTitle:@"加载历史" forState:MJRefreshStatePulling];
    
    [refreshStateHeader setTitle:@"正在加载历史" forState:MJRefreshStateRefreshing];
    
    //
    MJRefreshBackNormalFooter *refreshBackNormalFooter = (MJRefreshBackNormalFooter *)self.chatTableView.mj_footer;
    
    [refreshBackNormalFooter setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [refreshBackNormalFooter setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [refreshBackNormalFooter setTitle:@"上拉刷新" forState:MJRefreshStatePulling];
    [refreshBackNormalFooter setTitle:@"上拉刷新" forState:MJRefreshStateWillRefresh];
//    [refreshBackNormalFooter setTitle:@"上拉刷新" forState:MJRefreshStateWillRefresh];


    //
    CGFloat btnW = 60;
    //
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.chatTableView.yy, SCREEN_WIDTH, bottomHeight)];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgView];
    self.bootomBgView = bottomBgView;
    
    //
    UIView *inputInnerBgView = [[UIView alloc] initWithFrame:CGRectMake(18, 10, SCREEN_WIDTH - btnW - 18*3, 40)];
    [bottomBgView addSubview:inputInnerBgView];
    inputInnerBgView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    inputInnerBgView.layer.borderColor = [UIColor colorWithHexString:@"#9d9d9d"].CGColor;
    inputInnerBgView.layer.borderWidth = 0.7;
    inputInnerBgView.layer.cornerRadius = 5;
    inputInnerBgView.layer.masksToBounds = YES;
    

    //输入textView
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 2.5, inputInnerBgView.width - 10, inputInnerBgView.height - 5)];
    textView.font = [UIFont systemFontOfSize:12];
    textView.backgroundColor = inputInnerBgView.backgroundColor;
    [inputInnerBgView  addSubview:textView];
    self.textView = textView;
    
    //按钮
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 60, 30) ];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 5;
    sendBtn.layer.masksToBounds = YES;
    sendBtn.backgroundColor = [UIColor themeColor];
    
    
    [bottomBgView addSubview:sendBtn];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sendBtn.left = SCREEN_WIDTH - sendBtn.width - 18;
    [sendBtn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];

    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];

    

}

- (void)sendMsg {
    
    if (!self.textView.text || self.textView.text.length <= 0) {
        
        [TLAlert alertWithInfo:@"请输入消息内容"];
        return;
    }
    
    //
    [TLProgressHUD showWithStatus:nil];
            NBCDRequest *req = [[NBCDRequest alloc] init];
            req.code = @"620141";
            req.parameters[@"commenter"] = [TLUser user].userId;
            req.parameters[@"content"] = self.textView.text;
            req.parameters[@"receiver"] = self.otherUserId;
            [req startWithSuccess:^(__kindof NBBaseRequest *request) {
                [TLProgressHUD dismiss];

                CustomLiuYanModel *model = [[CustomLiuYanModel alloc] init];
                model.commenter = [TLUser user].userId;
                model.commentPhoto = [TLUser user].photo;
                model.content = self.textView.text;
           
                self.textView.text = nil;
                [self.view endEditing:YES];
                [self.chatModelRoom addObject:model];
                [self.chatTableView reloadData];
                
            } failure:^(__kindof NBBaseRequest *request) {
                
                [TLProgressHUD dismiss];

            }];
    
}


- (void)keyboardWillAppear:(NSNotification *)notification {
    
    //获取键盘高度
    CGFloat duration =  [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyBoardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    [UIView animateWithDuration:duration delay:0 options: 458752 | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.bootomBgView.y = CGRectGetMinY(keyBoardFrame) - [DeviceUtil top64] - self.bootomBgView.height;
        
        self.chatTableView.height = CGRectGetMinY(keyBoardFrame)  - [DeviceUtil top64] - self.bootomBgView.height;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
              [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatModelRoom.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
        });
        
    } completion:NULL];
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.chatModelRoom.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TLChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLChatCell"];
    if (!cell) {
        
        cell = [[TLChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TLChatCell"];
//        cell.backgroundColor =   ;
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];

    }
    cell.model = self.chatModelRoom[indexPath.row];
    
    return cell;

}

@end
