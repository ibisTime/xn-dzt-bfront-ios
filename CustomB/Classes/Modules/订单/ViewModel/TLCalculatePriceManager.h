//
//  TLCalculatePriceManager.h
//  CustomB
//
//  Created by  tianlei on 2017/8/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLCalculatePriceManager : NSObject

/**
 根据会员的
 */
@property (nonatomic, assign) float times;

//6个元素必须同时配置才能进行计算
@property (nonatomic, assign) float mianLiaoPrice; //单价
@property (nonatomic, assign) float mianLiaoCount; //面料数量
@property (nonatomic, assign) float gongYiPrice; //工艺费


//
//@property (nonatomic, assign) float jiaGongPrice; //加工费
//@property (nonatomic, assign) float kuaiDiPrice; //快递费
//@property (nonatomic, assign) float baoZhuangPrice; //包装费

- (float)calculate;

@end
