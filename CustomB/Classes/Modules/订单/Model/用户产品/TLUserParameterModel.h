//
//  TLUserParameterModel.h
//  CustomB
//
//  Created by  tianlei on 2017/8/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface TLUserParameterModel : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *type; //大类

@property (nonatomic, copy) NSString *name; //对应选择的小类姓名

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *orderCode;



//"code":"GY201708231415574020",
//"type":"1-8",
//"name":"很修身",
//"pic":"领型袖口矢量图方格图-无字-03_1503468867746.png",
//"price":0,
//"productCode":"PD201708232132013489",
//"orderCode":"DD201708171511465585"


@end

