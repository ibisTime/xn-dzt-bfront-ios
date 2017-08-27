//
//  BillDateChooseVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillDateChooseVC.h"
#import "DateChooseCell.h"
#import "ZHBillVC.h"

@interface BillDateChooseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *dateTableView;

@end

@implementation BillDateChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史账户明细";
    self.dateTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.dateTableView];
    self.dateTableView.dataSource = self;
    self.dateTableView.delegate  = self;
    self.dateTableView.rowHeight = 58;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHBillVC *billVC = [[ZHBillVC alloc] init];
    billVC.displayHeader = NO;
    billVC.beginTime = @"2016-01-01";
    billVC.endTime = @"2017-06-06";
    [self.navigationController pushViewController:billVC animated:YES];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.dateTableView.frame = self.view.bounds;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DateChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateChooseCell"];
    if (!cell) {
        
        cell = [[DateChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DateChooseCell"];
        
    }
    
    cell.textLbl.text = @"4月账单";
    return cell;

}

@end
