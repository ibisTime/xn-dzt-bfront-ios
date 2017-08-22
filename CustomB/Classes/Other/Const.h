//
//  Const.h
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Const : NSObject
//新单就是待量体

//1 待量体,2 已定价,3 已支付 ,4 待复核,5 待生产,6 生产中,7 已发货,8 已收货,9 已评价,10 已归档,11 取消订单


@end

//订单状态
FOUNDATION_EXTERN NSString * const kOrderStatusCancle;

FOUNDATION_EXTERN NSString * const kOrderStatusWillPay; //待支付
FOUNDATION_EXTERN NSString * const kOrderStatusWillMeasurement; //待量体
FOUNDATION_EXTERN NSString * const kOrderStatusWillCheck; //待复核
FOUNDATION_EXTERN NSString * const kOrderStatusWillSubmit; //待录入，已支付





