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
    TLOrderStatusWillPay = 1, //待支付支付
    TLOrderStatusWillSend = 2, //待发货
    TLOrderStatusDidPay = 3, //已经支付
    TLOrderStatusDidFinish = 4 //已经完成
    
    
};

@interface TLOrderCategoryVC : TLBaseVC

@property (nonatomic,assign) TLOrderStatus status;

@end
