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
             
             @"productList" : [TLUserProduct class],
             @"orderSizeData" : [TLMeasureModel class]
             
             };
    
}


//0为衬衫订单，1为H+ 为空时
- (TLOrderType)getOrderType {

    
    if (self.type == nil) {
        
        //未选择产品
        return TLOrderTypeProductUnChoose;
        
    }
    
    //选择衬衫价格固定
    if ([self.type isEqualToString:@"0"]) {
        // H+
        if (self.amount) {
            
            return TLOrderTypeChenShanDidDingJia;
            
        } else {
            
            return TLOrderTypeChenShanUnDingJia;
            
        }

    } else {
        // H+
        if (self.amount) {
            
            return TLOrderTypeHAddDidDingJia;
            
        } else {
            
            return TLOrderTypeHAddUnDingJia;
        
        }
    
    }
    
    
    
//    
//    //
//    if ([self.type isEqualToString:@"0"]) {
//    
//        //产品为衬衫
//        return TLOrderTypeChenShanDidDingJia;
//
//    } else {
//        return TLOrderTypeHAddDidDingJia;
//
//        //产品
//    }
    
}

- (NSString *)getDetailMeasureAddress {

    return [NSString stringWithFormat:@"%@%@%@%@",self.ltProvince,self.ltCity,self.ltArea,self.ltAddress];

}

- (NSString *)getDetailAddress {

    if (self.reAddress) {
        return self.reAddress;
    }
    return [NSString stringWithFormat:@"%@%@%@%@",self.ltProvince,self.ltCity,self.ltArea,self.ltAddress];

}

- (NSString *)getStatusName {

//    1 待量体,2 已定价,3 已支付 ,4 待复核,5 待生产,6 生产中,7 已发货,8 已收货,9 已评价,10 已归档,11 取消订单
    NSDictionary *dict = @{
                           
                           kOrderStatusCancle : @"已取消",
                           kOrderStatusDidDingJia : @"待支付",
                           kOrderStatusWillCheck : @"待复核",
                           kOrderStatusWillMeasurement : @"待量体",
                           kOrderStatusDidPay : @"待录入",
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

- (BOOL)isVipOrder {
    
    return ![self.level isEqualToString:@"1"];
    
}



- (BOOL)canEditXingTi {

//    return YES;
    //已支付=待录入，的可以编辑形体信息
    return [self.status isEqualToString:kOrderStatusDidPay] ;
    
//    return ![self.status isEqualToString:kOrderStatusWillShengChan] &&
//           ![self.status isEqualToString:kOrderStatusShengChanIng] &&
//    ![self.status isEqualToString:kOrderStatusDidSend] &&
//    ![self.status isEqualToString:kOrderStatusDidReceive] &&
//    ![self.status isEqualToString:kOrderStatusDidComment] &&
//    ![self.status isEqualToString:kOrderStatusDidSave]
//    ;
    
}


- (BOOL)canSubmitData {

    return [self.status isEqualToString:kOrderStatusDidPay];

}


- (BOOL)canSubmitCheck {

    return [self.status isEqualToString:kOrderStatusDidPay];

}

- (BOOL)canEditDingZhi {

    
    if ([self getOrderType] == TLOrderTypeChenShanDidDingJia) {
        //普通衬衫, 已支付 可以进行编辑，
        return [self.status isEqualToString:kOrderStatusDidPay];
        
        
    } else {
    
        //H+, 确定价格后就不能改变
        return NO;
    
    }

    
}



- (BOOL)canEdit {
    
    return YES;
//    if ([self getOrderType] == TLOrderTypeChenShanDidDingJia) {
//            //普通衬衫
//        return [self.status isEqualToString:kOrderStatusWillMeasurement] ||
//        [self.status isEqualToString:kOrderStatusDidPay] ||
//        [self.status isEqualToString:kOrderStatusDidDingJia] ||
//        [self.status isEqualToString:kOrderStatusWillCheck];
//        
//    } else if([self getOrderType] == TLOrderTyp){
//        //H+
//        return [self.status isEqualToString:kOrderStatusWillMeasurement];
//    
//    } else {
//    
//        NSLog(@"根据订单判断不出，产品类型");
//        return YES;
//    }


    
//    return [self.status isEqualToString:kOrderStatusWillMeasurement] ||
//    
//           [self.status isEqualToString:kOrderStatusWillSubmit] ||
//    [self.status isEqualToString:kOrderStatusDidDingJia] ||
//    [self.status isEqualToString:kOrderStatusWillCheck];

}

//- (BOOL)isVip {
//    
//    
//    
//    
//}


- (NSArray<NSDictionary *> *)figure {
    
    return self.sysDictMap[@"figure"];
    
}

-(NSArray<NSDictionary *> *)measure {
    
    return self.sysDictMap[@"measure"];
    
}

-(NSArray<NSDictionary *> *)other {
    
    return self.sysDictMap[@"other"];
    
}

@end
