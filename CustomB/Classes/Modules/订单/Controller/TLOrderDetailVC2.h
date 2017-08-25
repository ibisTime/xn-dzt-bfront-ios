//
//  TLOrderDetailVC2.h
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//  H+ 较特殊，选择产品后，填写除量体信息 和形体信息 的其它信息进行定价
//
#import "TLBaseVC.h"

typedef NS_ENUM(NSUInteger, OrderOperationType) {
    
    OrderOperationTypeDefault,
    OrderOperationTypeHAddDingJia

};

@class TLOrderModel;

@interface TLOrderDetailVC2 : TLBaseVC

@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, assign) OrderOperationType operationType;

@end
