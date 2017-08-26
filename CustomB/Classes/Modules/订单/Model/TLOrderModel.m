//
//  TLOrderModel.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderModel.h"
#import "Const.h"

@implementation TLOrderModel


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             
             @"productList" : [TLUserProduct class]
             
             };
    
    
}


//0为衬衫订单，1为H+ 为空时
- (TLOrderType)getOrderType {

    if (self.type == nil) {
        
        return TLOrderTypeProductUnChoose;
        
    } else if ([self.type isEqualToString:@"0"]) {
    
        return TLOrderTypeChenShan;

    } else {
    
        return TLOrderTypeHAdd;

    }
    

}

- (NSString *)getDetailAddress {

    return [NSString stringWithFormat:@"%@%@%@%@",self.ltProvince,self.ltCity,self.ltArea,self.ltAddress];

}

- (NSString *)getStatusName {

//    1 待量体,2 已定价,3 已支付 ,4 待复核,5 待生产,6 生产中,7 已发货,8 已收货,9 已评价,10 已归档,11 取消订单
    NSDictionary *dict = @{
                           
                           kOrderStatusCancle : @"已取消",
                           kOrderStatusDidDingJia : @"待支付",
                           kOrderStatusWillCheck : @"待复核",
                           kOrderStatusWillMeasurement : @"待量体",
                           kOrderStatusWillSubmit : @"待录入",
                           kOrderStatusWillShengChan : @"待生产", //待生产
                           kOrderStatusShengChanIng : @"生产中", //生产中
                           kOrderStatusDidSend : @"已发货",//已发货
                           kOrderStatusDidReceive : @"已收货", //已收货
                           kOrderStatusDidComment : @"已评价",//评价
                           kOrderStatusDidSave : @"已归档"//评价
                           
                           };
    //
    return dict[self.status];

}

- (BOOL)canEditXingTi {

    return ![self.status isEqualToString:kOrderStatusWillShengChan] &&
           ![self.status isEqualToString:kOrderStatusShengChanIng] &&
    ![self.status isEqualToString:kOrderStatusDidSend] &&
    ![self.status isEqualToString:kOrderStatusDidReceive] &&
    ![self.status isEqualToString:kOrderStatusDidComment] &&
    ![self.status isEqualToString:kOrderStatusDidSave]
    ;

}


- (BOOL)canEdit {

    return [self.status isEqualToString:kOrderStatusWillMeasurement] ||
    [self.status isEqualToString:kOrderStatusWillSubmit] ||
    [self.status isEqualToString:kOrderStatusDidDingJia] ||
    [self.status isEqualToString:kOrderStatusWillCheck];
    
//    return [self.status isEqualToString:kOrderStatusWillMeasurement] ||
//    
//           [self.status isEqualToString:kOrderStatusWillSubmit] ||
//    [self.status isEqualToString:kOrderStatusDidDingJia] ||
//    [self.status isEqualToString:kOrderStatusWillCheck];

}

@end
