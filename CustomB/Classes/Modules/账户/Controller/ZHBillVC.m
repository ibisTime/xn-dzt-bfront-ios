//
//  ZHBillVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBillVC.h"
#import "TLPageDataHelper.h"
#import "ZHBillModel.h"
#import "CDBillCell.h"
#import "TLUser.h"
#import "TLUIHeader.h"
#import "TLPlaceholderView.h"
//#import "AppCopyConfig.h"
#import "BillDateChooseVC.h"

@interface ZHBillVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <ZHBillModel *>*bills;
@property (nonatomic,strong) TLTableView *billTV;
@property (nonatomic,assign) BOOL isFirst;


@end

@implementation ZHBillVC

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    if (self.isFirst) {
        [self.billTV beginRefreshing];
        self.isFirst = NO;
    }

}

- (void)chooseDate {

    BillDateChooseVC *vc = [[BillDateChooseVC alloc] init];
    vc.accountNumber = self.accountNumber;
    [self.navigationController pushViewController:vc animated:YES];

}

- (UIView *)headerView {

    UIButton *headerV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headerV.backgroundColor = [UIColor whiteColor];
    [headerV addTarget:self action:@selector(chooseDate) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [headerV addSubview:leftImageView];
    leftImageView.image = [UIImage imageNamed:@"历史账单"];
    
    
    UIColor *textColor = [UIColor colorWithHexString:@"#4d4d4d"];
    
    //
    UILabel *textLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:FONT(14)
                                 textColor:textColor];
    [headerV addSubview:textLbl];
    textLbl.text = @"历史账单明细";
    
    
    //
    UIImageView *arrow =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多"]];
    [headerV addSubview:arrow];
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    
    //
    
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.centerY.equalTo(headerV.mas_centerY);
        make.left.equalTo(headerV.mas_left).offset(56);
    }];
    
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).offset(19);
        make.centerY.equalTo(headerV);
    }];
    
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(headerV.mas_right).offset(-29);
        make.centerY.equalTo(headerV);
        
    }];
    
 
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#a1a1a1"];
    [headerV addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerV.mas_left).offset(18);
        make.right.equalTo(headerV.mas_right).offset(-18);
        make.height.mas_equalTo(@1);
        make.bottom.equalTo(headerV.mas_bottom);
    }];
    
    return  headerV;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.displayHeader) {
        
        self.title = @"账单";

    }
    
 
    if (!self.accountNumber) {
        NSLog(@"请传入账户编号");
        return;
    }
    
    TLTableView *billTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                       delegate:self
                                                     dataSource:self];
    [self.view addSubview:billTableView];
    self.isFirst = YES;

    billTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    billTableView.rowHeight = 110;
    billTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    self.billTV = billTableView;
    //
    if (self.displayHeader) {
        
        self.billTV.tableHeaderView = [self headerView];

    }

    //--//
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"802524"; //我的流水查询传时间无效

    pageDataHelper.tableView = billTableView;
    pageDataHelper.parameters[@"token"] = [TLUser user].token;
    pageDataHelper.parameters[@"type"] = @"B";
    pageDataHelper.parameters[@"accountNumber"] = self.accountNumber;
    
    pageDataHelper.parameters[@"dateStart"] = self.beginTime;
    pageDataHelper.parameters[@"dateEnd"] = self.endTime;
  
    [pageDataHelper modelClass:[ZHBillModel class]];
    [billTableView addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.bills = objs;
            [weakSelf.billTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [billTableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.bills = objs;
            [weakSelf.billTV reloadData_tl];
   
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    CDOneBillDetailVC *detailVC = [CDOneBillDetailVC new];
//    detailVC.billModel = self.bills[indexPath.row];
//    [self.navigationController pushViewController:detailVC animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.bills.count;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    return self.bills[indexPath.row].dHeightValue + 110;
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *billCellId = @"CDBillCellID";
    CDBillCell *cell = [tableView dequeueReusableCellWithIdentifier:billCellId];
    
    if (!cell) {
        cell = [[CDBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:billCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.billModel = self.bills[indexPath.row];
    
    return cell;
    
}

@end
