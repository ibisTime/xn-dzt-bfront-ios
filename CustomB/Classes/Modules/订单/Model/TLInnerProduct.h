//
//  TLInnerProduct.h
//  CustomB
//
//  Created by  tianlei on 2017/9/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

#import "TLRes.h"
@class TLMianLiaoModel;
@class TLGuiGeXiaoLei;

@interface TLInnerProduct : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *modelCode;
@property (nonatomic, copy) NSString *remark;

//产品规格大类列表
@property (nonatomic, strong) TLRes *res;


//"code": "MOS201709181245105021",
//"name": "西服",
//"pic": "2_1505277174544.jpg",
//"updater": "admin",
//"updateDatetime": "Sep 18, 2017 12:45:10 PM",
//"remark": "",
//"modelCode": "MO201708291541466881",

//产品进行工艺选择是确定一下字段
@property (nonatomic, strong) TLMianLiaoModel *mianLiaoModel;

//工艺
// key : 刺绣的key  value: 次刺绣的内容
@property (nonatomic, copy) NSDictionary *ciXiuDict;
@property (nonatomic, strong) NSMutableArray<TLGuiGeXiaoLei *> *guiGeXiaoLeiRoom;

- (float)calculateMianLiaoPrice ;
- (float)calculateGongYiPrice;
- (float)calculateTotalPrice;

@end
