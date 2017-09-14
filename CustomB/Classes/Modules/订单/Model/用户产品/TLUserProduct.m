//
//  TLUserProduct.m
//  CustomB
//
//  Created by  tianlei on 2017/8/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUserProduct.h"
#import "NSNumber+TLAdd.h"
#import "TLGuiGeDaLei.h"

@implementation TLUserProduct

+ (NSDictionary *)mj_objectClassInArray {

    return @{
             
             @"productSpecsList" : [TLUserParameterModel class]
             
             };

}

- (NSString *)getPriceStr {

    return [NSString stringWithFormat:@"%@|%@",self.modelName,[self.price convertToRealMoney]];

}

//"productVarList": [
//                   {
//                       "code": "PSV201709160846338343",
//                       "name": "西单",
//                       "pic": "2_1505277098691.jpg",
//                       "updater": "U1111111111111111",
//                       "updateDatetime": "Sep 16, 2017 8:46:33 AM",
//                       "productCode": "PD201709160846338245",
//                       "modelSpecsCode": "MOS201709181243554097",
//                       "productSpecs" : [{
//"code": "BL00110",
//"type": "1",
//"brand": "花花公子",
//"modelNum": "YDP-PC20223",
//"pic": "DPF11008_1493951635755.jpg",
//"advPic": "DPF11008_1493951635755.jpg",
//"color": "3",
//"flowers": "1",
//"form": "1",
//"weight": 0,
//"yarn": "1",
//"price": 0,
//"productVarCode": "PSV201709160846338343",
//"productCode": "PD201709160846338245",
//"orderCode": "DD201709160808405074"

//                         }],
//                       "productCategory": []
//                   }
- (void)setProductVarList:(NSMutableArray *)productVarList {

    _productVarList = productVarList;
    
    NSDictionary *dict = _productVarList[0];
    
    //全部规格
    NSArray *guiGeArr = dict[@"productCategory"];
    self.guiGeDaLeiRoom = [TLGuiGeDaLei tl_objectArrayWithDictionaryArray:guiGeArr];
    
    //面料
    self.mianLiaoModel = [TLMianLiaoModel tl_objectWithDictionary:dict[@"productSpecs"][0]];
    
}


+ (NSDictionary *)tl_replacedKeyFromPropertyName
{
    return @{ @"description" : @"desc" };
    
}

@end
