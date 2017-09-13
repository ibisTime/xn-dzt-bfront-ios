//
//  TLGuiGeDaLei.h
//  CustomB
//
//  Created by  tianlei on 2017/9/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLGuiGeXiaoLei.h"

@interface TLGuiGeDaLei : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *dvalue;
@property (nonatomic, copy) NSString *modelSpecsCode;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, copy) NSString *updateDatetime;



/**
 大类的小类规格
 */
@property (nonatomic, copy) NSArray <TLGuiGeXiaoLei *>*craftList;

/**
 大类规格是否需要颜色标识
 */
@property (nonatomic, copy) NSArray <TLGuiGeXiaoLei *>*colorCraftList;

//"code": "PC1120",
//"type": "0",
//"dkey": "EXFSKD",
//"dvalue": "西服胸口袋",
//"modelSpecsCode": "MOS201709181245105021",
//"updater": "admin",
//"updateDatetime": "Sep 12, 2017 9:43:33 AM",

@end
