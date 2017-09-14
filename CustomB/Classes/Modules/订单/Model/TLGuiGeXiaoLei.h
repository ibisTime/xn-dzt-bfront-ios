//
//  TLGuiGeXiaoLei.h
//  CustomB
//
//  Created by  tianlei on 2017/9/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

typedef NS_ENUM(NSUInteger, GuiGeXiaoLeiType) {
    GuiGeXiaoLeiTypeNone, //eg: 无口袋
    GuiGeXiaoLeiTypeDefault //eg: 船型口袋

};

@interface TLGuiGeXiaoLei : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, copy ,readonly) NSString *selectedPic;

@property (nonatomic, copy) NSString *selected;

@property (nonatomic, copy) NSString *modelSpecsCode; //所属产品编码

@property (nonatomic, copy) NSString *isHit;
@property (nonatomic, assign, readonly) GuiGeXiaoLeiType xiaoLeiType;



//"code": "GY201709181940107804",
//"type": "MJLX",
//"name": "标准v型无领",
//"pic": "default-32_1505301996128.png",
//"selected": "default-32_1505301999981.png",
//"isHit": "0",
//"price": 0,
//"status": "1",
//"updater": "admin",
//"updateDatetime": "Sep 18, 2017 7:40:10 PM",
//"remark": "",
//"modelSpecsCode": "MOS201709181201222042",
//"modelCode": "MO201708211548546234",
//"model": {
//    "name": "马甲"
//}

@end
