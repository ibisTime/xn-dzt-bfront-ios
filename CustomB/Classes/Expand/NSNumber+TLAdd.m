//
//  NSNumber+TLAdd.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NSNumber+TLAdd.h"

@implementation NSNumber (TLAdd)


- (NSString *)convertToRealMoneyWithCount:(NSInteger)count {

    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    if (count == 0) {
        return 0;
    }
    
    long long m = [self longLongValue]*count;
    double value = m/1000.0;
    
    NSString *tempStr =  [NSString stringWithFormat:@"%.3f",value];
    NSString *subStr = [tempStr substringWithRange:NSMakeRange(0, tempStr.length - 1)];
    
    //  return [NSString stringWithFormat:@"%.2f",value];
    return subStr;
    

}

- (NSString *)convertToRealMoneyRuleBySystem {

    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    long long m = [self longLongValue];
    double value = m/1000.0;
    
//    NSString *tempStr = [NSString stringWithFormat:@"%.3f",value];
//    NSString *subStr = [tempStr substringWithRange:NSMakeRange(0, tempStr.length - 1)];
    
    //  return [NSString stringWithFormat:@"%.2f",value];
    return [NSString stringWithFormat:@"%.2f",value];

}

- (NSString *)convertToRealMoney {

    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
  long long m = [self longLongValue];
  double value = m/1000.0;
    
  NSString *tempStr =  [NSString stringWithFormat:@"%.3f",value];
  NSString *subStr = [tempStr substringWithRange:NSMakeRange(0, tempStr.length - 1)];
    
//  return [NSString stringWithFormat:@"%.2f",value];
 return subStr;
    
}

//- (NSString *)convertToSimpleRealMoney {
//
//    return [self covertToSimpleRealMoney];
//
//}
//
//- (NSString *)covertToRealMoney {
//
//    return [self convertToRealMoney];
//}

- (NSString *)convertToSimpleRealMoney {

    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
        
    }
    
    long long m = [self longLongValue];
    
    if (m%10 > 0) { //有厘
        
        double value = m/1000.0;
        return [NSString stringWithFormat:@"%.2f",value];
        
    } else if (m%100 > 0) {//有分
    
        double value = m/1000.0;
        return [NSString stringWithFormat:@"%.2f",value];
        
    } else if(m%1000 > 0) { //有角
    
        double value = m/1000.0;
        return [NSString stringWithFormat:@"%.1f",value];
        
    } else {//元
    
        double value = m/1000.0;
        return [NSString stringWithFormat:@"%.0f",value];
    }


}

@end
