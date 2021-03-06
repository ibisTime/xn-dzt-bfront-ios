//
//  ZHBillModel.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBillModel.h"

@implementation ZHBillModel


- (NSString *)getBizName {
    NSDictionary *dict = @{
                           
                           
                           @"11" : @"充值",
                           @"-11" : @"取现",
                           @"19" : @"蓝补",
                           @"-19" : @"红冲",
                           @"-30" : @"购物",
                           @"30" : @"购物退款",
                           @"32" : @"商品确认收货",
                           @"-40" : @"购买抵扣券",
                           @"-ZH1" : @"正汇O2O支付",
                           @"-ZH2" : @"正汇分红权分红",
                           @"-50" : @"购买汇赚宝",
                           @"51" : @"购买汇赚宝分成",
                           @"52" : @"汇赚宝摇一摇奖励",
                           @"53" : @"摇一摇分成",
                           @"60" : @"发一发得红包",
                           @"61" : @"领取红包",
                           @"-70" : @"参与小目标",
                           @"71" : @"小目标中奖",
                           @"200" : @"币种兑换"
                           
                           
                           };
    
    return dict[self.bizType];
    
}

//- (CGFloat)dHeightValue {
//    
//    CGSize size = [self.bizNote calculateStringSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) font:FONT(14)];
//    return size.height - [FONT(14) lineHeight] + 3;
//    
//}

//AJ_CZ(), AJ_QX("-11", "取现"), AJ_LB("19", "蓝补"), AJ_HC("-19", "红冲"), AJ_GW( "-30", "购物"), AJ_GWTK("30", "购物退款"), AJ_DPXF("-31", "店铺消费"), AJ_GMZKQ(                                                                                               "-32", "购买抵扣券"), AJ_XSZKQ("32", "销售抵扣券"), AJ_GMFLYK("33", "购买福利月卡"), AJ_HB2FR(
//                                                                                                                                                                                                                                                                                                                              "50", "红包兑分润"), AJ_HBYJ2FR("52", "红包业绩兑分润"), AJ_HBYJ2GXJL("54",
//                                                                                                                                                                                                                                                                                                                                                                                        "红包业绩兑贡献奖励"), AJ_FR2RMB("56", "分润兑人民币"), AJ_GXJL2RMB("58",
//                                                                                                                                                                                                                                                                                                                                                                                                                                             "贡献奖励兑人民币");
@end
