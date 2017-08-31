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

//1 待量体,2 已定价,3 已支付 ,4 待复核,
//5 待生产,6 生产中,7 已发货,8 已收货,9 已评价,10 已归档,11 取消订单


//1-1       产品规格
//1-2       衬衫面料
//1-3       领型选择
//1-4       袖型选择
//1-5       门襟选择
//1-6       下摆选择
//1-7       收省选择
//1-8       领口颜色
//1-9       口袋选择
//1-10       纽扣选择
//1-11       纽扣颜色
//2-1       领围
//2-2       胸围
//2-3       中腰围
//2-4       裤腰围
//2-5       臀围
//2-6       大腿围
//2-7       通档
//2-8       臀围
//2-9       总肩宽
//2-10       袖长
//2-11       前肩宽
//2-12       后腰节长
//2-13       后腰高
//2-14       后衣高
//2-15       前腰节长
//2-16       前腰高
//2-17       裤长
//2-18       小腿围
//4-1       体型
//4-2       背型
//4-3       左肩
//4-4       右肩
//4-5       脖子
//4-6       肤色
//4-7       肚型
//4-8       色彩
//5-1       个性刺绣
//5-2       刺绣位置
//5-3       刺绣字体
//5-4       刺绣颜色
//6-1       年龄（岁）
//6-2       身高（cm）
//6-3       体重（kg）
//6-4       邮寄地址
//6-5       备注
//4-9       手臂
//4-10       对比
//4-11       臀型
//4-12       量感
//2-19       前胸宽
//2-20       后背宽
//2-21       腹围
//2-22       小臂围
//2-23       前衣长

//// 面料
//CSGG("1-01", "规格"), CSML("1-02", "面料"),
//
//// 工艺
//LXXZ("1-03", "领型选择"), XXXZ("1-04", "袖型选择"), MJXZ("1-05", "门襟选择"),
//
//SXXZ("1-06", "收省选择"), LKYZ("1-07", "着装风格"), KDXZ("1-08", "口袋选择"),
//
//// 测量
//LW("2-01", "领围"), SW("2-02", "胸围"), ZYW("2-03", "中腰围"), KYW("2-04", "裤腰围"),
//
//TW("2-05", "臀围"), DTW("2-06", "大腿围"), TD("2-07", "通档"), BW("2-08", "臀围"),
//
//ZJK("2-09", "总肩宽"), XC("2-10", "袖长"), QJK("2-11", "前肩宽"), HYJC("2-12",
//                                                               "后腰节长"),
//
//HYG("2-13", "后腰高"), HYGH("2-14", "后衣高"), QYJC("2-15", "前腰节长"), QYG("2-16",
//                                                                   "前腰高"),
//
//KC("2-17", "裤长"), XTW("2-18", "小腿围"), QXK("2-19", "前胸宽"), HBK("2-20", "后背宽"),
//
//FW("2-21", "腹围"),
//
//XBW("2-22", "小臂围"), QYC("2-23", "前衣长"), WW("2-24", "腕围"),
//
////
//TX("4-01", "体型"), BX("4-02", "背型"), ZJ("4-03", "左肩"), YJ("4-04", "右肩"),
//
//BZ("4-05", "脖子"), FS("4-06", "肤色"), DX("4-07", "肚型"), SC("4-08", "色彩"),
//
//SB("4-09", "手臂"), DB("4-10", "对比"), TUNX("4-11", "臀型"), GL("4-12", "量感"),
////
//GXCX("5-01", "个性刺绣"),
//
//CXWZ("5-02", "刺绣位置"), CXZT("5-03", "刺绣字体"), CXYS("5-04", "刺绣颜色"),
////
//// NL("6-01", "年龄"),
//
//SG("6-02", "身高"), TZ("6-03", "体重"),
//
//YJDZ("6-04", "邮寄地址"),
//
//BEIZHU("6-05", "备注");

@end

//订单状态
FOUNDATION_EXTERN NSString * const kOrderStatusCancle;

FOUNDATION_EXTERN NSString * const kOrderStatusWillMeasurement; //待量体
FOUNDATION_EXTERN NSString * const kOrderStatusDidDingJia; //已定价
FOUNDATION_EXTERN NSString * const kOrderStatusDidPay; //待录入，已支付
FOUNDATION_EXTERN NSString * const kOrderStatusWillCheck; //待复核

//
FOUNDATION_EXTERN NSString * const kOrderStatusWillShengChan; //待生产
FOUNDATION_EXTERN NSString * const kOrderStatusShengChanIng; //生产中
FOUNDATION_EXTERN NSString * const kOrderStatusDidSend; //已发货
FOUNDATION_EXTERN NSString * const kOrderStatusDidReceive; //已收货
FOUNDATION_EXTERN NSString * const kOrderStatusDidComment; //评价
FOUNDATION_EXTERN NSString * const kOrderStatusDidSave; //评价


//
FOUNDATION_EXTERN NSString * const kShouHuoDiZhiType; //收货地址
FOUNDATION_EXTERN NSString * const kBeiZhuType; //收货地址











