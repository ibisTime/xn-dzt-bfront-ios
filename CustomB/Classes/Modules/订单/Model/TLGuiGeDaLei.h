//
//  TLGuiGeDaLei.h
//  CustomB
//
//  Created by  tianlei on 2017/9/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLGuiGeXiaoLei.h"
#import "TLProductCraft.h"
#import "TLColorDaLei.h"

typedef NS_ENUM(NSUInteger, GuiGeDaLeiType) {
    GuiGeDaLeiTypeZhuoZhuangFengGe,
    GuiGeDaLeiTypeDefaultGongYi,
    GuiGeDaLeiTypeCiXiuText,
    GuiGeDaLeiTypeCiXiuColor,
    GuiGeDaLeiTypeCiXiuOther
};


@interface TLGuiGeDaLei : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *type;   
@property (nonatomic, copy) NSString *dvalue; //SB 用name不知道要好多少 eg:领型

@property (nonatomic, copy) NSString *modelSpecsCode;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, copy) NSString *updateDatetime;



/**
 订单中，规格大类的_____值
 */
@property (nonatomic, strong) TLProductCraft *productCraft;


/**
 如果为工艺颜色大类，这个是对应的值
 */
@property (nonatomic, strong) TLProductCraft *colorProductCraft;

/**
 订单中，规格大类的颜色值，起的这名字也是zuiLe, 转换为 colorDaLei
 */
@property (nonatomic, strong) TLGuiGeDaLei *colorDaLei;
@property (nonatomic, strong) NSDictionary  *productCategory;

/**
 规格类别
 */


/**
 只用于规格，下属内容的判断
 */
@property (nonatomic, copy) NSString *dkey;

@property (nonatomic, copy) NSString *kind;
@property (nonatomic, assign,readonly) GuiGeDaLeiType guiGeLeiBie;


/**
 大类的小类规格
 */
@property (nonatomic, copy) NSArray <TLGuiGeXiaoLei *>*craftList;

/**
 大类规格是否需要颜色标识
 */
- (BOOL)isHaveColorMark;
@property (nonatomic, copy) NSArray <TLColorDaLei *>* colorPcList;


//@property (nonatomic, strong) TLColorDaLei *colorPcList;

//"code": "PC1120",
//"type": "0",
//"dkey": "EXFSKD",
//"dvalue": "西服胸口袋",
//"modelSpecsCode": "MOS201709181245105021",
//"updater": "admin",
//"updateDatetime": "Sep 12, 2017 9:43:33 AM",

@end
