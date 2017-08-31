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
 NSString * const kOrderStatusDidDingJia = @"2"; //待支付
 NSString * const kOrderStatusWillMeasurement = @"1"; //待量体
 NSString * const kOrderStatusWillCheck = @"4"; //待复核
 NSString * const kOrderStatusDidPay = @"3"; //待复核

 NSString * const kOrderStatusWillShengChan = @"5"; //待生产
 NSString * const kOrderStatusShengChanIng = @"6"; //生产中
 NSString * const kOrderStatusDidSend = @"7"; //已发货
 NSString * const kOrderStatusDidReceive = @"8"; //已收货
 NSString * const kOrderStatusDidComment = @"9"; //评价
 NSString * const kOrderStatusDidSave = @"10"; //评价


//****************** 收货地址 *********************//
NSString * const kShouHuoDiZhiType = @"6-04";
NSString * const kBeiZhuType = @"6-05";


@implementation Const


//// 面料
//CSGG("1-1", "规格"), CSML("1-2", "面料"),
//// 工艺
//LXXZ("1-3", "领型选择"), XXXZ("1-4", "袖型选择"), MJXZ("1-5", "门襟选择"),
//
//XBXZ("1-6", "下摆选择"), SXXZ("1-7", "收省选择"), LKYZ("1-8", "着装风格"),
//
//KDXZ("1-9", "口袋选择"),
//// 测量
//LW("2-1", "领围"), SW("2-2", "胸围"), ZYW("2-3", "中腰围"), KYW("2-4", "裤腰围"),
//
//TW("2-5", "臀围"), DTW("2-6", "大腿围"), TD("2-7", "通档"), BW("2-8", "臀围"),
//
//ZJK("2-9", "总肩宽"), XC("2-10", "袖长"), QJK("2-11", "前肩宽"), HYJC("2-12",
//                                                              "后腰节长"),
//
//HYG("2-13", "后腰高"), HYGH("2-14", "后衣高"), QYJC("2-15", "前腰节长"), QYG("2-16",
//                                                                   "前腰高"),
//
//KC("2-17", "裤长"), XTW("2-18", "小腿围"), QXK("2-19", "前胸宽"), HBK("2-20", "后背宽"),
//
//FW("2-21", "腹围"),
//XBW("2-22", "小臂围"), QYC("2-23", "前衣长"), WW("2-24", "腕围"),
//TX("4-1", "体型"), BX("4-2", "背型"), ZJ("4-3", "左肩"), YJ("4-4", "右肩"),
//
//BZ("4-5", "脖子"), FS("4-6", "肤色"), DX("4-7", "肚型"), SC("4-8", "色彩"),
//
//SB("4-9", "手臂"), DB("4-10", "对比"), TUNX("4-11", "臀型"), GL("4-12", "量感"),
//GXCX("5-1", "个性刺绣"),
//CXWZ("5-2", "刺绣位置"), CXZT("5-3", "刺绣字体"), CXYS("5-4", "刺绣颜色"),
////
//NL("6-1", "年龄"), SG("6-2", "身高"), TZ("6-3", "体重"), YJDZ("6-4", "邮寄地址"),
//BEIZHU("6-5", "备注");

@end
