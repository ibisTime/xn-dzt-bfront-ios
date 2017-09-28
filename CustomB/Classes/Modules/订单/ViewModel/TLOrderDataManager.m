//
//  TLOrderDataManager.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderDataManager.h"
#import "NSString+Extension.h"
#import "TLDataModel.h"
#import "TLInputDataModel.h"
#import "TLChooseDataModel.h"
#import "NSNumber+TLAdd.h"
#import "Const.h"
#import "TLGuiGeDaLei.h"

@implementation TLOrderDataManager

- (instancetype)initWithOrder:(TLOrderModel *)order {

    if (self = [super init]) {
        
        self.order = order;
        self.groups = [[NSMutableArray alloc] init];

    }
    
    return self;


}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.groups = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)handMeasureDataWithResp:(id)resp {

 
    self.measureDataRoom = [[NSMutableArray alloc] init];
    [self.order.measure enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLInputDataModel *model = [[TLInputDataModel alloc] init];
        model.keyCode = obj[@"dkey"]; //1-2
        model.keyName = obj[@"dvalue"];//
        model.canEdit = [self.order canEditXingTi];
        //
        model.isMust = obj[@"remark"] && [obj[@"remark"] isEqualToString:@"1"];

        if (obj[@"orderSizeData"]) {
            NSDictionary *sizeData = obj[@"orderSizeData"];
            model.value = sizeData[@"dkey"];
            
        }
        //
        [self.measureDataRoom addObject:model];
        
    }];
    
    
// NSArray <NSDictionary *>*typeArr = @[
//
//  @{  @"2-01" : @"领围"},
//  @{  @"2-02" : @"胸围"},
//  @{  @"2-03" : @"中腰围"},
//  @{  @"2-04" : @"裤腰围"},
//  @{  @"2-05" : @"臀围"},
//  @{  @"2-06" : @"大腿围"},
//  @{  @"2-07" : @"通档"},
//  @{  @"2-08" : @"臂围"},
//  @{  @"2-09" : @"总肩宽"},
//  @{  @"2-10" : @"袖长"},
//  @{  @"2-11" : @"前肩宽"},
//  @{  @"2-12" : @"后腰节长"},
//  @{  @"2-13" : @"后腰高"},
//  @{  @"2-14" : @"后衣长"},
//  @{  @"2-15" : @"前腰节长"},
//  @{  @"2-16" : @"前腰高"},
//  @{  @"2-17" : @"裤长"},
//  @{  @"2-18" : @"小腿围"},
//  @{  @"2-19" : @"前胸宽"},
//  @{  @"2-20" : @"后背宽"},
//  @{  @"2-21" : @"腹围"},
//  @{  @"2-22" : @"小臂围"},
//  @{  @"2-23" : @"前衣长"},
//  @{  @"2-24" : @"腕围"}
//      ];
//
//    //组装量体信息，如果当前 数据控制器，的订单中测量信息不为空，就读取对应的值
//    //在用户详情中，可能也有这些信息，？？怎样处理
//    self.measureDataRoom = [[NSMutableArray alloc] initWithCapacity:typeArr.count];
//    [typeArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        TLInputDataModel *model = [[TLInputDataModel alloc] init];
//        model.canEdit = [self.order canEditXingTi];
//        model.keyCode = obj.allKeys[0]; //1-2
//        model.keyName = obj[model.keyCode];
//
//        //找出value
//        [self.order.orderSizeData enumerateObjectsUsingBlock:^(TLMeasureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                if ([model.keyCode isEqualToString:obj.ckey]) {
//
//                    model.value = obj.dkey;
//                    *stop = YES;
//
//                }
//
//         }];
//
//        [self.measureDataRoom addObject:model];
//
//    }];
    
    
}

- (void)configXingTiDataModelWithResp:(id)resp {

    
    self.xingTiRoom = [[NSMutableArray alloc] init];
    [self.order.figure enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLChooseDataModel *chooseDataModel = [[TLChooseDataModel alloc] init];
        chooseDataModel.type =  obj[@"dkey"];
        chooseDataModel.typeName = obj[@"dvalue"];
        chooseDataModel.parameterModelRoom = [[NSMutableArray alloc] init];
        chooseDataModel.canEdit = [self.order canEditXingTi];
        chooseDataModel.isMust = obj[@"remark"] && [obj[@"remark"] isEqualToString:@"1"];

        //找出对应的值
        if (obj[@"orderSizeData"]) {
            NSDictionary *sizeData = obj[@"orderSizeData"];
            chooseDataModel.typeValue = sizeData[@"dkey"];
            chooseDataModel.typeValueName = sizeData[@"dvalue"];
        }
        
        //组装选项
        NSDictionary *chooseChooseDict = resp[@"data"][chooseDataModel.type];
        [chooseChooseDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TLParameterModel *model = [[TLParameterModel alloc] init];
            
            model.code = key;
            model.name = chooseChooseDict[key];
            model.type = chooseDataModel.type;
            model.typeName = chooseDataModel.typeName;
            [chooseDataModel.parameterModelRoom addObject:model];
            
        }];
        
        [self.xingTiRoom addObject:chooseDataModel];
        
    }];
  
//    self.xingTiRoom = [[NSMutableArray alloc] init];
//    NSArray <NSDictionary *> *xingArr = @[
//                                 
//                                 @{@"4-01" : @"形态"},
//                                 @{@"4-02" : @"背型"},
//                                 @{@"4-03" : @"左肩"},
//                                 @{@"4-04" : @"右肩"},
//                                 @{@"4-05" : @"脖子"},
//                                 @{@"4-06" : @"肤色"},
//                                 @{@"4-07" : @"肚型"},
//                                 @{@"4-08" : @"色彩"},
//                                 @{@"4-09" : @"手臂"},
//                                 @{@"4-10" : @"对比"},
//                                 @{@"4-11" : @"臀型"},
//                                 @{@"4-12" : @"量感"}
//                                 
//                                 ];
//    NSDictionary *dict = resp[@"data"];
//    
//    //先创建 大类 eg: 形态
//    [xingArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        TLChooseDataModel *chooseDataModel = [[TLChooseDataModel alloc] init];
//        chooseDataModel.type =  obj.allKeys[0];
//        chooseDataModel.typeName = obj[chooseDataModel.type];
//        chooseDataModel.parameterModelRoom = [[NSMutableArray alloc] init];
//        chooseDataModel.canEdit = [self.order canEditXingTi];
//        
//        //找出大类当轻值
//        [self.order.orderSizeData enumerateObjectsUsingBlock:^(TLMeasureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            if ([chooseDataModel.type isEqualToString:obj.ckey]) {
//                chooseDataModel.typeValue = obj.dkey;
//                chooseDataModel.typeValueName = obj.dvalue;
//                *stop = YES;
//            }
//
//        }];
//        
//        
//        //
//        NSString *code = obj.allKeys[0]; //1-2
//        NSDictionary *paraDict = dict[code];
//        [paraDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            TLParameterModel *model = [[TLParameterModel alloc] init];
//            
//            model.code = key;
//            model.name = paraDict[key];
//            model.type = code;
//            model.typeName = obj[code];
//            
////            if (selectValueCode && [selectValueCode isEqualToString:model.code]) {
////                chooseDataModel.typeValue = model.code;
////                chooseDataModel.typeValueName = model.name;
////            }
//            //创建各种小类
//            [chooseDataModel.parameterModelRoom addObject:model];
//            
//        }];
//       
//        [self.xingTiRoom addObject:chooseDataModel];
//
//    }];
//    //

}



//- (void)handleMianLiaoData:(id)responseObject {
//
//    if (!responseObject) {
//        NSLog(@"布料 未传值");
//        return;
//    }
//    
//    self.mianLiaoRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
//
//    //
//    [self.mianLiaoRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        obj.name = [obj.modelNum copy];
//        if (self.order.resultMap.DINGZHI[@"1-02"]) {
//            
//            NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-02"];
//            
//            if ([obj.code isEqualToString:selelctParaDict[@"code"]]) {
//                
//                obj.isSelected = YES;
//                obj.yuSelected = YES;
//                self.mianLiaoValue = obj.modelNum;
//                
//            }
//            
//        }
//        
//    }];
//    
//    
//}



//- (void)handleCiXiu:(NSMutableArray <TLGuiGeDaLei *>*)ciXiuGuiGeRoom {

    //为分类好的全部信息
//    [ciXiuGuiGeRoom enumerateObjectsUsingBlock:^(TLGuiGeDaLei * _Nonnull guiGeDaLei, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (guiGeDaLei.GuiGeDaLei ) {
//            
//            TLInputDataModel *cixiuTextModel = [[TLInputDataModel alloc] init];
////            cixiuTextModel.canEdit = [self.order canSubmitData];
//            self.ciXiuTextRoom = [[NSMutableArray alloc] initWithArray:@[cixiuTextModel]];
////            self.ciXiuTextValue = @"";
//        
//        } else if ([guiGeDaLei.dkey isEqualToString:@"CXZT"]) {
//            
//            NSMutableArray *arr = [[NSMutableArray alloc] init];
//            [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
//                parameterModel.name = obj.name;
//                parameterModel.pic = obj.pic;
//                parameterModel.selectPic = obj.selectedPic;
//                parameterModel.dataModel = obj;
//                [arr addObject:parameterModel];
//                
//            }];
//            self.fontRoom = arr;
//        
//            
//        } else if ([guiGeDaLei.dkey isEqualToString:@"CXYS"]) {
//            
//            NSMutableArray *arr = [[NSMutableArray alloc] init];
//            [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
//                parameterModel.name = obj.name;
//                parameterModel.pic = obj.pic;
//                parameterModel.selectPic = obj.selectedPic;
//                parameterModel.dataModel = obj;
//                [arr addObject:parameterModel];
//
//            }];
//            self.ciXiuColorRoom = arr;
//            
//        } else if ([guiGeDaLei.dkey isEqualToString:@"CXWZ"]) {
//            
//            NSMutableArray *arr = [[NSMutableArray alloc] init];
//            [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
//                parameterModel.name = obj.name;
//                parameterModel.pic = obj.pic;
//                parameterModel.selectPic = obj.selectedPic;
//                parameterModel.dataModel = obj;
//                [arr addObject:parameterModel];
//
//            }];
//            
//            self.ciXiuLocationRoom = arr;
//        }
//        
//    }];
        
        
    
    
    //*************************** 刺绣开始************************//
//    NSArray *fontRoom = dict[@"5-03"];
//    self.fontRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:fontRoom];
//    if (self.order.resultMap.CIXIU[@"5-03"]) {
//        
//        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-03"];
//        [self.fontRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
//                
//                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
//                obj.yuSelected = obj.isSelected;
//                self.fontValue = selelctParaDict[@"name"];
//                *stop = YES;
//                
//            }
//            
//        }];
//        
//    }
    
    //
//    NSArray *ciXiuLocationRoom = dict[@"5-02"];
//    self.ciXiuLocationRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:ciXiuLocationRoom];
//    if (self.order.resultMap.CIXIU[@"5-02"]) {
//        
//        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-02"];
//        [self.ciXiuLocationRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
//                
//                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
//                obj.yuSelected = obj.isSelected;
//                self.ciXiuLocationValue = selelctParaDict[@"name"];
//                *stop = YES;
//                
//            }
//            
//        }];
//    }
//    
    //刺绣颜色
//    NSArray *ciXiuColorRoom = dict[@"5-04"];
//    self.ciXiuColorRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:ciXiuColorRoom];
//    if (self.order.resultMap.CIXIU[@"5-04"]) {
//        
//        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-04"];
//        [self.ciXiuColorRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
//                
//                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
//                obj.yuSelected = obj.isSelected;
//                self.ciXiuColorValue = selelctParaDict[@"name"];
//                *stop = YES;
//                
//            }
//            
//        }];
//    }
    
    //刺绣内容
//    TLInputDataModel *cixiuTextModel = [[TLInputDataModel alloc] init];
//    cixiuTextModel.canEdit = [self.order canSubmitData];
//    self.ciXiuTextRoom = [[NSMutableArray alloc] initWithArray:@[cixiuTextModel]];
//    self.ciXiuTextValue = @"";
//    if (self.order.resultMap.CIXIU[@"5-01"]) {
//        
//        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-01"];
//        [self.ciXiuColorRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            self.ciXiuTextValue = selelctParaDict[@"code"];
//            self.ciXiuTextRoom[0].value = self.ciXiuTextValue;
//            *stop = YES;
//            
//        }];
//    }

//}



//- (void)handleParameterData:(id)responseObject {
//
//    if (!responseObject) {
//        
//        NSLog(@"规格信息不能为空");
//        return;
//    }
//    
//    
//   
//}


- (NSMutableArray <TLDataModel *>*)configConstOrderInfoDataModel {

    if (!self.order) {
        NSLog(@"订单不能为空");
        return nil;
    }
    
 
    
    
  NSMutableArray <NSDictionary *> *dingDanInfoArr = [ @[
      
      @{@"订单编号" : self.order.code},
      @{@"下单时间" : [self.order.createDatetime convertToDetailDate]},
      @{@"订单状态" : [self.order getStatusName]},
      
      ] mutableCopy];

    NSMutableArray *thenArr = [[NSMutableArray alloc] init];
    [dingDanInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLDataModel *model = [[TLDataModel alloc] init];
        model.keyName = obj.allKeys[0];
        model.value = obj[model.keyName];
        model.isStatus = [model.keyName isEqualToString:@"订单状态"];

        [thenArr addObject:model];
    
    }];
    
    return thenArr;
    
    
}

- (NSMutableArray <TLCiXiuTextInputCell *>*)configCiXiuTextDataModel {

    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
    [arr addObject:[[TLInputDataModel alloc] init]];
    return arr;

}

//- (NSString *)mianLiaoCode {
//
//    if (self.order.resultMap.DINGZHI[@"1-02"]) {
//        
//        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-02"];
//        return selelctParaDict[@"code"];
//        [productInfoArr addObject:@{@"面料编号" : selelctParaDict[@"code"]}];
//        
//    }
//
//}

- (NSMutableArray <TLDataModel *>*)configProductInfoDataModel {

    if (!self.order || !self.order.product || self.order.product.productVarList.count <= 0) {
        NSLog(@"订单和产品");
        return nil;
    }
    
    
//    
    NSMutableArray <NSDictionary *> *productInfoArr = [ @[
                                                          
                                                          @{@"下单产品" :     self.order.product.modelName},
                                                          
                                                          ] mutableCopy];
//
//    [self.order.productList enumerateObjectsUsingBlock:^(TLUserProduct * _Nonnull userProduct, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        TLMianLiaoModel *mianLiaoModel = userProduct.mianLiaoModel;
//        
//        [productInfoArr addObject:@{[NSString stringWithFormat:@"%@面料编号",userProduct.modelName] : mianLiaoModel.modelNum}];
//
//    }];
    //
    
    //订单价格
    if (self.order.amount) {
        NSString *priceStr =  [NSString stringWithFormat:@"￥%@",[self.order.amount convertToRealMoney]];
        [productInfoArr addObject:@{@"订单价格":priceStr}];
    }
    
    if (self.order.originalAmount) {
        
        NSNumber *p = @([self.order.originalAmount longLongValue] -  [self.order.amount longLongValue]);
        NSString *turePriceStr =  [NSString stringWithFormat:@"￥%@",[p convertToRealMoney]];
        [productInfoArr addObject:@{@"价格优惠":turePriceStr}];
        
    }
    
    //
    NSMutableArray *productInfoArrDataModelRoom = [[NSMutableArray alloc] init];
    [productInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLDataModel *model = [[TLDataModel alloc] init];
        model.keyName = obj.allKeys[0];
        model.value = obj[model.keyName];
        [productInfoArrDataModelRoom addObject:model];
        
    }];
    
    return productInfoArrDataModelRoom;

}


- (NSMutableArray *)configConstLogisticsInfoDataModel {

    if (!self.order) {
        NSLog(@"订单不能为空");
        return nil;
    }
    
    if (!self.order.logisticsCode) {
        return [NSMutableArray new];
    }
    
    
    NSString *shouHuoStr = nil;
    shouHuoStr = @"未收货";
    if (
        [self.order.status isEqualToString:kOrderStatusDidReceive] ||
        [self.order.status isEqualToString:kOrderStatusDidSave] ||
        [self.order.status isEqualToString:kOrderStatusDidComment] ||
        [self.order.status isEqualToString:kOrderStatusDidSave]
        
        ) {
        shouHuoStr = @"已收货";
        
    }
    
NSDictionary *kuaiDiDcit =   @{
      
      @"EMS" : @"邮政EMS",
      @"STO" : @"申通快递",
      @"ZTO" : @"中通快递",
      @"YTO" : @"圆通快递",
      @"HTKY" : @"汇通快递",
      @"ZJS" : @"宅急送",
      @"SF" : @"顺丰快递",
      @"TTKD" : @"天天快递"

      };
    
    NSMutableArray <NSDictionary *> *orderInfoArr = [  @[
  @{@"物流公司" : kuaiDiDcit[self.order.logisticsCompany] ? : self.order.logisticsCompany},
  @{@"发货时间" : [self.order.deliveryDatetime convertDate]},
  @{@"快递单号" : self.order.logisticsCode},
  @{@"收货确认" : shouHuoStr},


                                                                                               ] mutableCopy];
    
    NSMutableArray *thenArr = [[NSMutableArray alloc] init];
    [orderInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLDataModel *model = [[TLDataModel alloc] init];
        model.keyName = obj.allKeys[0];
        model.value = obj[model.keyName];
        [thenArr addObject:model];
        
    }];
    
    return thenArr;
}

- (NSMutableArray *)configConstUserInfoDataModel {

    if (!self.order) {
        NSLog(@"订单不能为空");
        return nil;
    }
    
    TLInputDataModel *shouHuoDiZHi = [[TLInputDataModel alloc] init];
    self.shouHuoAddressRoom = [[NSMutableArray alloc] initWithObjects:shouHuoDiZHi, nil];
    shouHuoDiZHi.canEdit = [self.order canSubmitData];
//    if (self.order.resultMap.QITA[kShouHuoDiZhiType]) {
//        
//        NSDictionary *selelctParaDict = self.order.resultMap.QITA[kShouHuoDiZhiType];
//        shouHuoDiZHi.keyCode = kShouHuoDiZhiType;
//        shouHuoDiZHi.keyName = @"收货地址";
//        shouHuoDiZHi.value = selelctParaDict[@"code"];
//        
//    } else {
//        
//        shouHuoDiZHi.keyCode = kShouHuoDiZhiType;
//        shouHuoDiZHi.keyName = @"收货地址";
//        shouHuoDiZHi.value =  [self.order getDetailAddress];
//    
//    }
    if (self.order.reAddress) {
        
      shouHuoDiZHi.keyCode = kShouHuoDiZhiType;
      shouHuoDiZHi.keyName = @"收货地址";
      shouHuoDiZHi.value =  self.order.reAddress;
        
    }
    
    //
    TLInputDataModel *remarkDataModel =  [[TLInputDataModel alloc] init];
    //可提交 就可编辑
    remarkDataModel.canEdit = [self.order canSubmitData];
    self.remarkRoom = [[NSMutableArray alloc] initWithArray:@[remarkDataModel]];
    if (self.order.remark) {
        remarkDataModel.value = self.order.remark;
        self.remarkValue = self.order.remark;
    }
    
//    if (self.order.resultMap.QITA[kBeiZhuType]) {
//        
//        NSDictionary *selelctParaDict = self.order.resultMap.QITA[kBeiZhuType];
//        remarkDataModel.value = selelctParaDict[@"code"];
//        self.remarkValue = self.order.remark;
//        
//    }

    //
    NSMutableArray <NSDictionary *> *orderInfoArr = [[NSMutableArray alloc] initWithArray:   @[
                                      @{@"客户姓名" : self.order.applyName},
                                      @{@"联系电话" : self.order.applyMobile}
                                      ]];
    

//    if (self.order.resultMap.QITA[@"6-01"]) {
//        
//        NSDictionary *selelctParaDict = self.order.resultMap.QITA[@"6-01"];
//
//            [orderInfoArr addObject:@{@"年龄" : selelctParaDict[@"code"]}];
//    }
//    
//    //
    
//    if (self.order.orderSizeData) {
//
//        [self.order.orderSizeData enumerateObjectsUsingBlock:^(TLMeasureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj.ckey isEqualToString:@"6-02"]) {
//
//                [orderInfoArr addObject:@{@"身高" : [NSString stringWithFormat:@"%@ cm",obj.dkey]}];
//
//            } else if ([obj.ckey isEqualToString:@"6-03"]) {
//
//                [orderInfoArr addObject:@{@"体重" : [NSString stringWithFormat:@"%@ kg",obj.dkey]}];
//
//
//            }
//        }];
//
//
//    }
    if (self.order.other) {
        
        [self.order.other enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj[@"dkey"] isEqualToString:@"6-02"]) {
                
                if (obj[@"sizeData"]) {
                    
                    [orderInfoArr addObject:@{@"身高" : [NSString stringWithFormat:@"%@ cm",obj[@"sizeData"][@"dkey"]]
                                                 }];
                }
                
            } else  if ([obj[@"dkey"] isEqualToString:@"6-03"]) {
                
                if (obj[@"sizeData"]) {
                    
                    [orderInfoArr addObject:@{@"体重" : [NSString stringWithFormat:@"%@ kg",obj[@"sizeData"][@"dkey"]]
                                                 }];
                }
                
            }
            
        }];
        
        
    }
    
    //
    [orderInfoArr addObject:@{@"量体地址" : [self.order getDetailMeasureAddress]}];

    //
    NSMutableArray *thenArr = [[NSMutableArray alloc] init];
    [orderInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLDataModel *model = [[TLDataModel alloc] init];
        model.keyName = obj.allKeys[0];
        model.value = obj[model.keyName];
        [thenArr addObject:model];
        
    }];
    
    return thenArr;

}


- (NSMutableArray *)configDefaultModel {

    return [NSMutableArray new];

}

@end
