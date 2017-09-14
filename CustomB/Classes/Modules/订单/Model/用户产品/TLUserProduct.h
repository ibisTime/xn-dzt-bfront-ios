//
//  TLUserProduct.h
//  CustomB
//
//  Created by  tianlei on 2017/8/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLUserParameterModel.h"
#import "TLMianLiaoModel.h"

@class TLGuiGeDaLei;

@interface TLUserProduct : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *modelCode;
@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, copy) NSString *modelPic;
@property (nonatomic, copy) NSString *advPic;

@property (nonatomic, strong) NSNumber *price;


/**
 SB, 里面只可有用一个，还数组
 */
@property (nonatomic, strong) NSMutableArray *productVarList;
//@property (nonatomic, strong) NSMutableArray <TLUserParameterModel *>*productSpecsList;

// 由productVarList 转换
//当前产品对应的规格
@property (nonatomic, strong) NSMutableArray <TLGuiGeDaLei *>*guiGeDaLeiRoom;

//当前产品的面料
@property (nonatomic, strong) TLMianLiaoModel *mianLiaoModel;

- (NSString *)getPriceStr;
@end

//"productVarList": [
//                   {
//                       "code": "PSV201709160846338343",
//                       "name": "西单",
//                       "pic": "2_1505277098691.jpg",
//                       "updater": "U1111111111111111",
//                       "updateDatetime": "Sep 16, 2017 8:46:33 AM",
//                       "productCode": "PD201709160846338245",
//                       "modelSpecsCode": "MOS201709181243554097",
//                       "productSpecs": [{
//                                        }]
//                       "productCategory" : []
//                   }
//                   ]
