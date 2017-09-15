//
//  TLMeasureModel.h
//  CustomB
//
//  Created by  tianlei on 2017/9/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//  用户的测量数据

#import "TLBaseModel.h"

@interface TLMeasureModel : TLBaseModel

@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *ckey;
@property (nonatomic, copy) NSString *cvalue;


@property (nonatomic, copy) NSString *dkey;
@property (nonatomic, copy) NSString *dvalue;


@end


//"id": "8",
//"orderCode": "DD201709160808405074",
//"ckey": "6-02",
//"cvalue": "身高",
//"dkey": "170"

//形体数据
//{
//    "id": "85",
//    "orderCode": "DD201709170051212381",
//    "ckey": "4-06",
//    "cvalue": "肤色",
//    "dkey": "B",
//    "dvalue": "偏白"
//},
