//
//  TLColorDaLei.h
//  CustomB
//
//  Created by  tianlei on 2017/9/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLGuiGeXiaoLei.h"

@interface TLColorDaLei : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *parentKey;
@property (nonatomic, copy) NSString *codkeyde;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy) NSString *dvalue;

@property (nonatomic, copy) NSString *modelSpecsCode;

@property (nonatomic, copy) NSArray <TLGuiGeXiaoLei *>*colorCraftList;

//"code": "121",
//"kind": "0",
//"type": "1",
//"parentKey": "XFSKD",
//"dkey": "XFSKDYS",
//"dvalue": "西服胸口袋颜色",
//"modelSpecsCode": "MOS201709181243554097",
//"updater": "admin",
//"updateDatetime": "Sep 12, 2

@end
