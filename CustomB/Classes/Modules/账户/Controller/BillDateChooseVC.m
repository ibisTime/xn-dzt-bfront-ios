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
#import "TLDateModel.h"

@interface BillDateChooseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *dateTableView;
@property (nonatomic, strong) NSMutableArray <TLDateModel *>*dateRooms;

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
    
    //
    self.dateRooms = [[NSMutableArray alloc] init];
    
    //从2017-05-01 开始
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获得NSDate的每一个元素
    NSInteger lastYear = [calendar component:NSCalendarUnitYear fromDate:now];
    NSInteger lastMonth = [calendar component:NSCalendarUnitMonth fromDate:now];
    NSInteger lastDay = [calendar component:NSCalendarUnitDay fromDate:now];
    
    
    //
    TLDateModel *lastDateModel = [[TLDateModel alloc] init];
    lastDateModel.year = lastYear;
    lastDateModel.month=  lastMonth;
    

    
    //遍历年
    for (NSInteger i = 2017; i <= lastYear; i ++) {
        
        //遍历月
        if (i == 2017 && lastYear == 2017) {
            
            for (NSInteger month = 9; month <= lastMonth; month ++) {
                
                TLDateModel *dateModel = [[TLDateModel alloc] init];
                dateModel.year = i;
                dateModel.month = month;
                dateModel.totalDay = [self howManyDaysInThisYear:dateModel.year withMonth:dateModel.month];
                [self.dateRooms addObject:dateModel];
                
            }
            
            
        } else if (i == 2017){
        
            for (NSInteger month = 5; month <= 12; month ++) {
                
                TLDateModel *dateModel = [[TLDateModel alloc] init];
                dateModel.year = i;
                dateModel.month = month;
                dateModel.totalDay = [self howManyDaysInThisYear:dateModel.year withMonth:dateModel.month];
                [self.dateRooms addObject:dateModel];
                
            }
        
        
        } else if (i == lastYear) {
            
            for (NSInteger month = 1; month <= lastMonth; month ++) {
                
                TLDateModel *dateModel = [[TLDateModel alloc] init];
                dateModel.year = i;
                dateModel.month = month;
                dateModel.totalDay = [self howManyDaysInThisYear:dateModel.year withMonth:dateModel.month];
                [self.dateRooms addObject:dateModel];
                
            }
            
        } else {
        
            for (NSInteger month = 1; month <= 12; month ++) {
                
                TLDateModel *dateModel = [[TLDateModel alloc] init];
                dateModel.year = i;
                dateModel.month = month;
                dateModel.totalDay = [self howManyDaysInThisYear:dateModel.year withMonth:dateModel.month];
                [self.dateRooms addObject:dateModel];

            }
        
        }

    }
    //
    
    NSEnumerator *enumerator =  [self.dateRooms reverseObjectEnumerator];
    self.dateRooms = [[enumerator allObjects] mutableCopy];

    
}



- (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHBillVC *billVC = [[ZHBillVC alloc] init];
    billVC.displayHeader = NO;
    TLDateModel *dateModel = self.dateRooms[indexPath.row];
    billVC.accountNumber = self.accountNumber;
    billVC.beginTime = [NSString stringWithFormat:@"%ld-%02ld-01",dateModel.year,dateModel.month];
    //结束时间
    billVC.endTime = [NSString stringWithFormat:@"%ld-%02ld-%02ld",dateModel.year,dateModel.month,dateModel.totalDay];
    [self.navigationController pushViewController:billVC animated:YES];
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.dateTableView.frame = self.view.bounds;

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dateRooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DateChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateChooseCell"];
    if (!cell) {
        
        cell = [[DateChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DateChooseCell"];
        
    }

    TLDateModel *dateModel = self.dateRooms[indexPath.row];
    cell.textLbl.text = [NSString stringWithFormat:@"%ld-%ld月账单",dateModel.year,dateModel.month];
    return cell;

}

@end
