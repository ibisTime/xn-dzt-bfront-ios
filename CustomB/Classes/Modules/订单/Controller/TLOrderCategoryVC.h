//
//  TLOrderCategoryVC.h
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"


typedef NS_ENUM(NSInteger,TLOrderStatus){
    
    TLOrderStatusAll = 0, //全部
    TLOrderStatusWillMeasurement = 1, //待量体
    TLOrderStatusWillPay = 2, //待支付
    TLOrderStatusWillSubmit = 3, //待录入,已支付
    TLOrderStatusWillCheck = 4 //待复核
    
};


@interface TLOrderCategoryVC : TLBaseVC

@property (nonatomic,assign) TLOrderStatus status;

@end
