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

 NSArray <NSDictionary *>*typeArr = @[
  
  @{  @"2-01" : @"领围"},
  @{  @"2-02" : @"胸围"},
  @{  @"2-03" : @"中腰围"},
  @{  @"2-04" : @"裤腰围"},
  @{  @"2-05" : @"臀围"},
  @{  @"2-06" : @"大腿围"},
  @{  @"2-07" : @"通档"},
  @{  @"2-08" :  @"臀围"},
  @{  @"2-09" :  @"总肩宽"},
  @{  @"2-10" :  @"袖长"},
  @{  @"2-11" : @"前肩宽"},
  @{  @"2-12" : @"后腰节长"},
  @{  @"2-13" : @"后腰高"},
  @{  @"2-14" : @"后衣高"},
  @{  @"2-15" : @"前腰节长"},
  @{  @"2-16" : @"前腰高"},
  @{  @"2-17" : @"裤长"},
  @{  @"2-18" : @"小腿围"},
  @{  @"2-19" : @"前胸宽"},
  @{  @"2-20" : @"后背宽"},
  @{  @"2-21" : @"腹围"},
  @{  @"2-22" : @"小臂围"},
  @{  @"2-23" : @"前衣长"},
  @{  @"2-24" : @"腕围"}
      ];
    
    //组装量体信息，如果当前 数据控制器，的订单中测量信息不为空，就读取对应的值
    //在用户详情中，可能也有这些信息，？？怎样处理
    self.measureDataRoom = [[NSMutableArray alloc] initWithCapacity:typeArr.count];
    
    [typeArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        TLDataModel *model = [[TLDataModel alloc] init];
//        
//        model.keyCode = obj.allKeys[0]; //1-2
//        model.keyName = obj[model.keyCode];
//        
//        model.value = @"-";
//
//        if (self.order.resultMap.CELIANG && self.order.resultMap.CELIANG[model.keyCode]) {
//            
//            NSDictionary *dict = self.order.resultMap.CELIANG[model.keyCode];
//            model.value =   dict[@"code"] ? dict[@"code"] : @"-";
//        }
//        [self.measureDataRoom addObject:model];
        
        TLInputDataModel *model = [[TLInputDataModel alloc] init];
        
        model.keyCode = obj.allKeys[0]; //1-2
        model.keyName = obj[model.keyCode];
        model.value = @"-";
        
        if (!resp) {
            //查询订单中信息进行赋值
            if (self.order.resultMap.CELIANG && self.order.resultMap.CELIANG[model.keyCode]) {
                
                NSDictionary *dict = self.order.resultMap.CELIANG[model.keyCode];
                model.value =   dict[@"code"] ? dict[@"code"] : @"-";
            }
            
        } else {
            
           //根据传入的结果进行估值
           //用在用户信息界面
        
        }
   
        [self.measureDataRoom addObject:model];
        
    }];
    
    
}

- (void)configXingTiDataModelWithResp:(id)resp {

    //TX("4-01", "体型"), BX("4-02", "背型"), ZJ("4-03", "左肩"), YJ("4-04", "右肩"),
    //
    //BZ("4-05", "脖子"), FS("4-06", "肤色"), DX("4-07", "肚型"), SC("4-08", "色彩"),
    //
    //SB("4-09", "手臂"), DB("4-10", "对比"), TUNX("4-11", "臀型"), GL("4-12", "量感"),
    
    self.xingTiRoom = [[NSMutableArray alloc] init];
    NSArray <NSDictionary *> *xingArr = @[
                                 
                                 @{@"4-01" : @"形态"},
                                 @{@"4-02" : @"背型"},
                                 @{@"4-03" : @"左肩"},
                                 @{@"4-04" : @"右肩"},
                                 @{@"4-05":  @"脖子"},
                                 @{@"4-06" : @"肤色"},
                                 @{@"4-07" : @"肚型"},
                                 @{@"4-08" : @"色彩"},
                                 @{@"4-09"  : @"手臂"},
                                 @{@"4-10" : @"对比"},
                                 @{@"4-11" : @"臀型"},
                                 @{@"4-12" : @"量感"}
                                 
                                 ];
    NSDictionary *dict = resp[@"data"];
    
    [xingArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        TLChooseDataModel *chooseDataModel = [[TLChooseDataModel alloc] init];
        chooseDataModel.type =  obj.allKeys[0];
        chooseDataModel.typeName = obj[chooseDataModel.type];
        chooseDataModel.parameterModelRoom = [[NSMutableArray alloc] init];
        chooseDataModel.canEdit = self.order.canEditXingTi;
        
        //形体对应的类
        NSDictionary *valueDict = self.order.resultMap.TIXIN[chooseDataModel.type];
        NSString *selectValueCode = valueDict[@"code"];
        
        //
        NSString *code = obj.allKeys[0]; //1-2
        NSDictionary *paraDict = dict[code];

        [paraDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TLParameterModel *model = [[TLParameterModel alloc] init];
            
            model.code = key;
            model.name = paraDict[key];
            model.type = code;
            model.typeName = obj[code];
            
            if (selectValueCode && [selectValueCode isEqualToString:model.code]) {
                chooseDataModel.typeValue = model.code;
                chooseDataModel.typeValueName = model.name;
            }
            
            [chooseDataModel.parameterModelRoom addObject:model];
            
        }];
       
        [self.xingTiRoom addObject:chooseDataModel];

    }];
    //

}



- (void)handleMianLiaoData:(id)responseObject {

    if (!responseObject) {
        NSLog(@"布料 未传值");
        return;
    }
    self.mianLiaoRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];

    //
    [self.mianLiaoRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.name = [obj.code copy];
        if (self.order.resultMap.DINGZHI[@"1-02"]) {
            
            NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-02"];
            
            if ([obj.code isEqualToString:selelctParaDict[@"code"]]) {
                
                obj.isSelected = YES;
                obj.yuSelected = YES;
                self.mianLiaoValue = obj.code;
                
            }
            
        }
        
    }];
    
    
    
}



- (void)handleParameterData:(id)responseObject {

    if (!responseObject) {
        
        NSLog(@"规格信息不能为空");
        return;
    }
    
    
    //// 面料
    //CSGG("1-01", "规格"), CSML("1-02", "面料"),
    //
    //// 工艺
    //LXXZ("1-03", "领型选择"), XXXZ("1-04", "袖型选择"), MJXZ("1-05", "门襟选择"),
    //
    //SXXZ("1-06", "收省选择"), LKYZ("1-07", "着装风格"), KDXZ("1-08", "口袋选择"),
    
    //为分类好的全部信息
    NSDictionary *dict = responseObject[@"data"];
    
    //全10个
    NSString *guiGeCode = @"1-01";
    NSArray *guiGeRoom = dict[guiGeCode];
    self.guiGeRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:guiGeRoom];
    
    if (self.order.resultMap.DINGZHI[guiGeCode]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[guiGeCode];
        
        //找出已经设置的选
        [self.guiGeRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = YES;
                obj.yuSelected = obj.isSelected;
                self.guiGeValue = selelctParaDict[@"name"];
                *stop = YES;
            }
            
        }];
    }
    
    NSArray *zhuoZhuangFengGeRoom = dict[@"1-07"];
    self.zhuoZhuangFengGeRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:zhuoZhuangFengGeRoom];
    if (self.order.resultMap.DINGZHI[@"1-07"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-07"];
        [self.zhuoZhuangFengGeRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                obj.yuSelected = obj.isSelected;
                self.zhuoZhuangFengGeValue = selelctParaDict[@"name"];
                *stop = YES;

            }
            
        }];
    }
    
    //
    NSString *menJinCode = @"1-05";
    NSArray *menJinRoom = dict[menJinCode];
    self.menJinRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:menJinRoom];
    if (self.order.resultMap.DINGZHI[menJinCode]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-05"];
        [self.menJinRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                obj.yuSelected = obj.isSelected;
                self.menJinValue = selelctParaDict[@"name"];
                *stop = YES;

            }
            
        }];
    }
    
    //
    NSString *lingXingCode = @"1-03";
    NSArray *lingXingRoom = dict[@"1-03"];
    self.lingXingRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:lingXingRoom];
    if (self.order.resultMap.DINGZHI[lingXingCode]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[lingXingCode];
        [self.lingXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                obj.yuSelected = obj.isSelected;
                self.lingXingValue = selelctParaDict[@"name"];
                *stop = YES;

            }
            
        }];
    }
    
    //
    NSArray *xiuXingRoom = dict[@"1-04"];
    self.xiuXingRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:xiuXingRoom];
    if (self.order.resultMap.DINGZHI[@"1-04"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-04"];
        [self.xiuXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                obj.yuSelected = obj.isSelected;
                self.xiuXingValue = selelctParaDict[@"name"];
                *stop = YES;

            }
            
        }];
    }
    
    //
    NSArray *kouDaiRoom = dict[@"1-08"];
    self.kouDaiRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:kouDaiRoom];
    if (self.order.resultMap.DINGZHI[@"1-08"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-08"];
        [self.kouDaiRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                obj.yuSelected = obj.isSelected;
                self.kouDaiValue = selelctParaDict[@"name"];
                *stop = YES;

            }
            
        }];
    }
    
    //
    NSArray *shouXingRoom = dict[@"1-06"];
    self.shouXingRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:shouXingRoom];
    if (self.order.resultMap.DINGZHI[@"1-06"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-06"];
        [self.shouXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                obj.yuSelected = obj.isSelected;
                self.shouXingValue = selelctParaDict[@"name"];
                *stop = YES;

            }
            
        }];
    }
    
    
    //*************************** 刺绣开始************************//
    NSArray *fontRoom = dict[@"5-03"];
    self.fontRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:fontRoom];
    if (self.order.resultMap.CIXIU[@"5-03"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-03"];
        [self.fontRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                obj.yuSelected = obj.isSelected;
                self.fontValue = selelctParaDict[@"name"];
                *stop = YES;

            }
            
        }];
    }
    
    //
    NSArray *ciXiuLocationRoom = dict[@"5-02"];
    self.ciXiuLocationRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:ciXiuLocationRoom];
    if (self.order.resultMap.CIXIU[@"5-02"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-02"];
        [self.ciXiuLocationRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                obj.yuSelected = obj.isSelected;
                self.ciXiuLocationValue = selelctParaDict[@"name"];
                *stop = YES;

            }
            
        }];
    }
    
    //刺绣颜色
    NSArray *ciXiuColorRoom = dict[@"5-04"];
    self.ciXiuColorRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:ciXiuColorRoom];
    if (self.order.resultMap.CIXIU[@"5-04"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-04"];
        [self.ciXiuColorRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                obj.yuSelected = obj.isSelected;
                self.ciXiuColorValue = selelctParaDict[@"name"];
                *stop = YES;

            }
            
        }];
    }
    
    //刺绣内容
    TLInputDataModel *cixiuTextModel = [[TLInputDataModel alloc] init];
    self.ciXiuTextRoom = [[NSMutableArray alloc] initWithArray:@[cixiuTextModel]];
    self.ciXiuTextValue = @"";
    if (self.order.resultMap.CIXIU[@"5-01"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-01"];
        [self.ciXiuColorRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
                self.ciXiuTextValue = selelctParaDict[@"code"];
            self.ciXiuTextRoom[0].value = self.ciXiuTextValue;
            *stop = YES;

        }];
    }

    
    
}


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

    if (!self.order || !self.order.productList || self.order.productList.count <= 0) {
        NSLog(@"订单和产品");
        return nil;
    }
    
    
    
    NSMutableArray <NSDictionary *> *productInfoArr = [ @[
                                                          
                                                          @{@"下单产品" :     self.order.productList[0].modelName},
                                                          
                                                          ] mutableCopy];
    
    if (self.order.resultMap.DINGZHI[@"1-02"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-02"];
        
        [productInfoArr addObject:@{@"面料编号" : selelctParaDict[@"code"]}];
        
    }
    
    //订单价格
    if (self.order.amount) {
        NSString *priceStr =  [NSString stringWithFormat:@"￥%@",[self.order.amount convertToRealMoney]];
        [productInfoArr addObject:@{@"订单价格":priceStr}];
    }
    
    if (self.order.payAmount) {
        
        NSString *turePriceStr =  [NSString stringWithFormat:@"￥%@",[self.order.payAmount convertToRealMoney]];
        [productInfoArr addObject:@{@"价格优惠":turePriceStr}];
    }
    
    //--//
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
    
    TLInputDataModel *remarkDataModel =  [[TLInputDataModel alloc] init];
    remarkDataModel.value = self.order.remark;
    self.remarkRoom = [[NSMutableArray alloc] initWithArray:@[remarkDataModel]];
    
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
    
    NSMutableArray <NSDictionary *> *orderInfoArr = [  @[
@{@"物流公司" : self.order.logisticsCompany},
@{@"发货时间" : [self.order.deliveryDatetime convertToDetailDate]},
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
    self.shouHuoAddressRoom = [@[shouHuoDiZHi] mutableCopy];
    if (self.order.resultMap.QITA[@"6-04"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.QITA[@"6-04"];
        shouHuoDiZHi.keyCode = @"6-04";
        shouHuoDiZHi.keyName = @"收货地址";
        shouHuoDiZHi.value = selelctParaDict[@"code"];
        
    }
    
   
    
    TLInputDataModel *remarkDataModel =  [[TLInputDataModel alloc] init];
    remarkDataModel.value = self.order.remark;
    self.remarkRoom = [[NSMutableArray alloc] initWithArray:@[remarkDataModel]];
    
    NSMutableArray <NSDictionary *> *orderInfoArr = [[NSMutableArray alloc] initWithArray:   @[
                                      @{@"客户姓名" : self.order.ltName},
                                      @{@"联系电话" : self.order.applyMobile}
                                      ]];
    

    if (self.order.resultMap.QITA[@"6-01"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.QITA[@"6-01"];

            [orderInfoArr addObject:@{@"年龄" : selelctParaDict[@"code"]}];
    }
    
    //
    if (self.order.resultMap.QITA[@"6-02"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.QITA[@"6-02"];
        [orderInfoArr addObject:@{@"身高" : [NSString stringWithFormat:@"%@ cm",selelctParaDict[@"code"]]}];
        
    }
    
    //
    if (self.order.resultMap.QITA[@"6-03"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.QITA[@"6-03"];
        
        [orderInfoArr addObject:@{@"体重" : [NSString stringWithFormat:@"%@ kg",selelctParaDict[@"code"]]}];
        
    }
    
    //
    if (self.order.resultMap.QITA[@"6-04"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.QITA[@"6-04"];
        [orderInfoArr addObject:@{@"收货地址" : selelctParaDict[@"code"]}];
        
    }
    
  

    
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
