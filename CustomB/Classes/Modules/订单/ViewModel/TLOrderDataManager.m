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

@implementation TLOrderDataManager

- (instancetype)initWithOrder:(TLOrderModel *)order {

    if (self = [super init]) {
        
        self.groups = [[NSMutableArray alloc] init];
        self.order = order;
    }
    
    return self;


}


- (void)handMeasureData:(id)responseObject {

 NSArray <NSDictionary *>*typeArr = @[
  @{
      @"2-1" : @"领围"},
  @{@"2-2" : @"胸围"},
  @{@"2-3" : @"中腰围"},
  @{@"2-4" : @"裤腰围"},
  
  @{  @"2-5" : @"臀围"},
  @{   @"2-6" : @"大腿围"},
  @{   @"2-7" : @"通档"},
  @{   @"2-8" :  @"臀围"},
  @{  @"2-9" :  @"总肩宽"},
  @{   @"2-10" :  @"袖长"},
  @{  @"2-11" :  @"前肩宽"},
  @{  @"2-12" :  @"后腰节长"},
  @{  @"2-13" :   @"后腰高"},
  @{   @"2-14" : @"后衣高"},
  @{  @"2-15" : @"前腰节长"},
  @{   @"2-16" : @"前腰高"},
  @{   @"2-17" : @"裤长"},
  @{    @"2-18" : @"小腿围"},
      
  @{   @"2-19" : @"前胸宽"},
  @{   @"2-20" : @"后背宽"},
  @{   @"2-21" : @"腹围"},
  @{   @"2-22" :  @"小臂围"},
  @{  @"2-23" :  @"前衣长"},
  @{    @"2-24" :  @"腕围"}
      ];
    
    self.measureDataRoom = [[NSMutableArray alloc] initWithCapacity:typeArr.count];
    
    [typeArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLDataModel *model = [[TLDataModel alloc] init];
        
        model.keyCode = obj.allKeys[0]; //1-2
        model.keyName = obj[model.keyCode];
        
        model.value = @"-";

        if (self.order.resultMap.CELIANG && self.order.resultMap.CELIANG[model.keyCode]) {
            
            NSDictionary *dict = self.order.resultMap.CELIANG[model.keyCode];
            model.value =   dict[@"code"] ? dict[@"code"] : @"-";
        }
        [self.measureDataRoom addObject:model];
        
    }];
    
    

}

- (void)configXingTiDataModelWithResp:(id)resp {

    self.xingTiRoom = [[NSMutableArray alloc] init];
    NSArray <NSDictionary *> *xingArr = @[
                                 
                                 @{@"4-1" : @"形态"},
                                 @{@"4-2" : @"背型"},
                                 @{@"4-3" : @"左肩"},
                                 @{@"4-5":  @"脖子"},
                                 @{@"4-4" : @"右肩"},
                                 @{@"4-6" : @"肤色"},
                                 @{@"4-7" : @"肚型"},
                                 @{@"4-8" : @"色彩"},
                                 @{@"4-9"  : @"手臂"},
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
                chooseDataModel.typeValue = model.name;
            }
            
            [chooseDataModel.parameterModelRoom addObject:model];
        }];
       
        [self.xingTiRoom addObject:chooseDataModel];

    }];
    //---//
    
    
}


- (void)handleM {
    
    //形体信息
//    4-1       体型
//    4-2       背型
//    4-3       左肩
//    4-4       右肩
    
//    4-5       脖子
//    4-6       肤色
//    4-7       肚型
//    4-8       色彩
//    4-9       手臂
//    4-10       对比
//    4-11       臀型
//    4-12       量感
    

    
    


    
 


//    NSArray *arr = @[
//                     @{@"2-1" : @"领围"},
//                     @{@"2-1" : @"领围"},
//                     @{@"2-1" : @"领围"},
//                     @{@"2-1" : @"领围"},
//                     @{@"2-1" : @"领围"},
//
//                     
//                     ];
//    NSDictionary *dict = @{
//                           []
//                           
//                           };
//    
//    @"2-2"  : @"胸围"
//    @"2-3"  : @"中腰围"
//    @"2-4"  : @"裤腰围"
//    2-5       臀围
//    2-6       大腿围
//    2-7       通档
//    2-8       臀围
//    2-9       总肩宽
//    2-10       袖长
//    2-11       前肩宽
//    2-12       后腰节长
//    2-13       后腰高
//    2-14       后衣高
//    2-15       前腰节长
//    2-16       前腰高
//    2-17       裤长
//    2-18       小腿围

}

- (void)handleMianLiaoData:(id)responseObject {

    self.mianLiaoRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];

    [self.mianLiaoRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.name = @"面料";
    }];
}



- (void)handleParameterData:(id)responseObject {

    if (!responseObject) {
        
        NSLog(@"规格信息不能为空");
        return;
    }
    
    //
    NSDictionary *dict = responseObject[@"data"];
    
    //全10个
    NSString *guiGeCode = @"1-1";
    NSArray *guiGeRoom = dict[guiGeCode];
    self.guiGeRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:guiGeRoom];
    
    if (self.order.resultMap.DINGZHI[guiGeCode]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[guiGeCode];
        [self.guiGeRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                self.guiGeValue = selelctParaDict[@"name"];
            }
            
        }];
    }
    
    NSArray *zhuoZhuangFengGeRoom = dict[@"1-8"];
    self.zhuoZhuangFengGeRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:zhuoZhuangFengGeRoom];
    if (self.order.resultMap.DINGZHI[@"1-8"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-8"];
        [self.zhuoZhuangFengGeRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                self.zhuoZhuangFengGeValue = selelctParaDict[@"name"];
                
            }
            
        }];
    }
    
    //
    NSString *menJinCode = @"1-5";
    NSArray *menJinRoom = dict[menJinCode];
    self.menJinRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:menJinRoom];
    if (self.order.resultMap.DINGZHI[menJinCode]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-5"];
        [self.menJinRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                self.menJinValue = selelctParaDict[@"name"];

            }
            
        }];
    }
    
    //
    NSString *lingXingCode = @"1-3";
    NSArray *lingXingRoom = dict[@"1-3"];
    self.lingXingRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:lingXingRoom];
    if (self.order.resultMap.DINGZHI[lingXingCode]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[lingXingCode];
        [self.lingXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                self.lingXingValue = selelctParaDict[@"name"];

            }
            
        }];
    }
    
    //
    NSArray *xiuXingRoom = dict[@"1-4"];
    self.xiuXingRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:xiuXingRoom];
    if (self.order.resultMap.DINGZHI[@"1-4"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-4"];
        [self.xiuXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                self.xiuXingValue = selelctParaDict[@"name"];

            }
            
        }];
    }
    
    //
    NSArray *kouDaiRoom = dict[@"1-9"];
    self.kouDaiRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:kouDaiRoom];
    if (self.order.resultMap.DINGZHI[@"1-9"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-9"];
        [self.kouDaiRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                self.kouDaiValue = selelctParaDict[@"name"];
                
            }
            
        }];
    }
    
    //
    NSArray *shouXingRoom = dict[@"1-7"];
    self.shouXingRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:shouXingRoom];
    if (self.order.resultMap.DINGZHI[@"1-7"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.DINGZHI[@"1-7"];
        [self.shouXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                self.shouXingValue = selelctParaDict[@"name"];
                
            }
            
        }];
    }
    
    
    //*************************** 刺绣开始************************//
    NSArray *fontRoom = dict[@"5-3"];
    self.fontRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:fontRoom];
    if (self.order.resultMap.CIXIU[@"5-3"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-3"];
        [self.fontRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                self.fontValue = selelctParaDict[@"name"];
                
            }
            
        }];
    }
    
    //
    NSArray *ciXiuLocationRoom = dict[@"5-2"];
    self.ciXiuLocationRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:ciXiuLocationRoom];
    if (self.order.resultMap.CIXIU[@"5-2"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-2"];
        [self.ciXiuLocationRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                self.ciXiuLocationValue = selelctParaDict[@"name"];
                
            }
            
        }];
    }
    
    //刺绣颜色
    NSArray *ciXiuColorRoom = dict[@"5-4"];
    self.ciXiuColorRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:ciXiuColorRoom];
    if (self.order.resultMap.CIXIU[@"5-4"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-4"];
        [self.ciXiuColorRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([selelctParaDict[@"code"] isEqualToString:obj.code]) {
                
                obj.isSelected = [selelctParaDict[@"code"] isEqualToString:obj.code];
                self.ciXiuColorValue = selelctParaDict[@"name"];
                
            }
            
        }];
    }
    
    //刺绣内容
    TLInputDataModel *cixiuTextModel = [[TLInputDataModel alloc] init];
    self.ciXiuTextRoom = [[NSMutableArray alloc] initWithArray:@[cixiuTextModel]];
    self.ciXiuTextValue = @"";
    if (self.order.resultMap.CIXIU[@"5-1"]) {
        
        NSDictionary *selelctParaDict = self.order.resultMap.CIXIU[@"5-1"];
        [self.ciXiuColorRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
                self.ciXiuTextValue = selelctParaDict[@"code"];
            self.ciXiuTextRoom[0].value = self.ciXiuTextValue;
            
        }];
    }

    
    
}


- (NSMutableArray <TLDataModel *>*)configConstOrderInfoDataModel {

    if (!self.order) {
        NSLog(@"订单不能为空");
        return nil;
    }
    
    
  NSArray <NSDictionary *>*arr =  @[
      
      @{@"订单编号" : self.order.code},
      @{@"下单时间" : [self.order.createDatetime convertToDetailDate]},
      @{@"订单状态" : [self.order getStatusName]},
      
      ];
    
    NSMutableArray *thenArr = [[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLDataModel *model = [[TLDataModel alloc] init];
        model.keyName = obj.allKeys[0];
        model.value = obj[model.keyName];
        [thenArr addObject:model];
    
    }];
    
    return thenArr;
    
    
}

- (NSMutableArray <TLCiXiuTextInputCell *>*)configCiXiuTextDataModel {

    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
    [arr addObject:[[TLInputDataModel alloc] init]];
    return arr;

}


- (NSMutableArray *)configConstLogisticsInfoDataModel {

    return [NSMutableArray new];

}

- (NSMutableArray *)configConstUserInfoDataModel {

    if (!self.order) {
        NSLog(@"订单不能为空");
        return nil;
    }
    
    TLInputDataModel *remarkDataModel =  [[TLInputDataModel alloc] init];
    remarkDataModel.value = self.order.remark;
    self.remarkRoom = [[NSMutableArray alloc] initWithArray:@[remarkDataModel]];
    
    NSArray <NSDictionary *>*arr =  @[
                                      @{@"客户姓名" : self.order.ltName},
                                      @{@"联系电话" : self.order.applyMobile}
                                      ];
    
    NSMutableArray *thenArr = [[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
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
