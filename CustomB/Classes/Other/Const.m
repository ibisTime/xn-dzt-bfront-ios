//
//  Const.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "Const.h"

//1 待量体,2 已定价,3 已支付 ,4 待复核,5 待生产,6 生产中,7 已发货,8 已收货,9 已评价,10 已归档,11 取消订单

 NSString * const kOrderStatusCancle = @"11";
 NSString * const kOrderStatusWillPay = @"2"; //待支付
 NSString * const kOrderStatusWillMeasurement = @"1"; //待量体
 NSString * const kOrderStatusWillCheck = @"4"; //待复核
NSString * const kOrderStatusWillSubmit = @"3"; //待复核



@implementation Const

@end
