//
//  TLUserProductXiaoJian.h
//  CustomB
//
//  Created by  tianlei on 2017/9/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//  套装里的小件

#import "TLBaseModel.h"
#import "TLMianLiaoModel.h"
#import "TLGuiGeDaLei.h"

@interface TLUserProductXiaoJian : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, copy) NSString *updateDatetime;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *modelSpecsCode;

@property (nonatomic, copy) NSArray *productSpecs;
@property (nonatomic, copy) NSArray *productCategory;

@property (nonatomic, strong) TLMianLiaoModel *mianLiaoModel;

@property (nonatomic, strong) NSMutableArray <TLGuiGeDaLei *>*guiGeDaLeiRoom;


//"code": "PSV201709170052232449",
//"name": "西服",
//"pic": "2_1505277174544.jpg",
//"updater": "U1111111111111111",
//"updateDatetime": "Sep 17, 2017 12:52:23 AM",
//"productCode": "PD201709170052232429",
//"modelSpecsCode": "MOS201709181245105021",

@end
