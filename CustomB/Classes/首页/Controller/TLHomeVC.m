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


@interface TLHomeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *homeTableView;
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
    
    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 48) style:UITableViewStyleGrouped];
    [self.view addSubview:self.homeTableView];
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //tableView
    TLBannerView *headerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    headerView.imgUrls = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503903557&di=152adb2d71faca4bb4d0820eff5385c5&imgtype=jpg&er=1&src=http%3A%2F%2Fimages0.cnblogs.com%2Fblog2015%2F780338%2F201508%2F261134016561975.png",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2084569111,4178087204&fm=26&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503903557&di=152adb2d71faca4bb4d0820eff5385c5&imgtype=jpg&er=1&src=http%3A%2F%2Fimages0.cnblogs.com%2Fblog2015%2F780338%2F201508%2F261134016561975.png"];
    self.homeTableView.tableHeaderView = headerView;
    
}

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

    return 2;

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
    
    return cell;

}
@end
