//
//  TLCustomer.m
//  CustomB
//
//  Created by  tianlei on 2017/8/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLCustomer.h"

@implementation TLCustomer

- (NSString *)getDetailAddress {

    return [NSString stringWithFormat:@"%@%@%@",self.province? : @"",self.city? : @"",self.area? : @""];

}

- (NSString *)getVipName {

//    ONE("1", "普通用户"), TWO("2", "银卡会员"),
//    THREE("3", "金卡会员"),
//    FOUR("4", "铂金会员"), FIVE(
//      "5", "钻石会员");
    NSDictionary *dict = @{
                           
                           @"1": @"普通用户",
                           @"2": @"银卡会员",
                           @"3": @"金卡会员",
                           @"4": @"铂金会员",
                           @"5": @"钻石会员"
                           
                           };
    
    return dict[self.level];

}

- (NSString *)getCustomerTitle {
    
    if (!self.frequent) {
      return @"";
    }
    
    
//    ONE("1", "新用户"), TWO("2", "老客户"), THREE("3", "活跃老客户"), FOUR("4", "非常活跃老客户"), FIVE(
//                                                                                      "5", "预流失客户"), SIX("6", "流失客户");
    NSDictionary *dict = @{
                           
                           @"1": @"新客户",
                           @"2": @"老客户",
                           @"3": @"活跃老客户",
                           @"4": @"非常活跃老客户",
                           @"5": @"预流失客户",
                           @"6": @"流失客户"
                           
                           };
    
    
    return dict[self.frequent];
    
}

@end
