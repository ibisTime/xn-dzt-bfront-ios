//
//  TLInnerProduct.h
//  CustomB
//
//  Created by  tianlei on 2017/9/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

#import "TLRes.h"

@interface TLInnerProduct : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *modelCode;
@property (nonatomic, copy) NSString *remark;

//
@property (nonatomic, strong) TLRes *res;

//"code": "MOS201709181245105021",
//"name": "西服",
//"pic": "2_1505277174544.jpg",
//"updater": "admin",
//"updateDatetime": "Sep 18, 2017 12:45:10 PM",
//"remark": "",
//"modelCode": "MO201708291541466881",

@end
