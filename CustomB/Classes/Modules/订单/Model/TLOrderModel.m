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
                           kOrderStatusWillPay : @"待支付",
                           kOrderStatusWillCheck : @"待复核",
                           kOrderStatusWillMeasurement : @"待量体",
                           kOrderStatusWillCheck : @"待复核",
                           kOrderStatusWillSubmit : @"待录入"
                           
                           };
    //
    return dict[self.status];

}
@end
