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
    
//    NSArray <NSDictionary *>*arr = responseObject[@"data"];
//    self.measureDataRoom = [[NSMutableArray alloc] initWithCapacity:arr.count];
//    
//    [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        TLDataModel *model = [[TLDataModel alloc] init];
//        model.keyName = obj[@"dvalue"];
//        model.keyCode = obj[@"dkey"];
//        model.value = @"-";
//        [self.measureDataRoom addObject:model];
//        
//    }];
    
    self.measureDataRoom = [[NSMutableArray alloc] initWithCapacity:typeArr.count];
    
    [typeArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLDataModel *model = [[TLDataModel alloc] init];
        
        model.keyCode = obj.allKeys[0];
        model.keyName = obj[model.keyCode];
        model.value = @"-";
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

        
        
        //
        NSString *code = obj.allKeys[0]; //1-2
//           "4-10" =         {
//        A = "\U6b63\U5e38";
//        B = "\U5f3a\U5bf9\U6bd4";
//        C = "\U5f31\U5bf9\U6bd4";
//        };
        NSDictionary *paraDict = dict[code];

        [paraDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TLParameterModel *model = [[TLParameterModel alloc] init];
            
            model.code = key;
            model.name = paraDict[key];
            model.type = code;
            model.typeName = obj[code];
            
            [chooseDataModel.parameterModelRoom addObject:model];
        }];
       
        [self.xingTiRoom addObject:chooseDataModel];

    }];
    
    
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



- (void)handleParameterData:(id)responseObject {

    if (!responseObject) {
        
        NSLog(@"规格信息不能为空");
        return;
    }
    
    NSDictionary *dict = responseObject[@"data"];
    
    //全10个
    //产品规格
    //暂时缺少风格
    
    NSString *guiGeCode = @"1-1";
    NSArray *guiGeRoom = dict[guiGeCode];
    self.guiGeRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:guiGeRoom];
    
    //
    NSArray *menJinRoom = dict[@"1-5"];
    self.menJinRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:menJinRoom];

    //
    NSArray *lingXingRoom = dict[@"1-3"];
    self.lingXingRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:lingXingRoom];

    //
    NSArray *xiuXingRoom = dict[@"1-4"];
    self.xiuXingRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:xiuXingRoom];

    //
    NSArray *kouDaiRoom = dict[@"1-9"];
    self.kouDaiRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:kouDaiRoom];

    //
    NSArray *shouXingRoom = dict[@"1-7"];
    self.shouXingRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:shouXingRoom];

    //
    NSArray *fontRoom = dict[@"5-3"];
    self.fontRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:fontRoom];

    //
    NSArray *ciXiuLocationRoom = dict[@"5-2"];
    self.ciXiuLocationRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:ciXiuLocationRoom];

    //
    NSArray *ciXiuColorRoom = dict[@"5-4"];
    self.ciXiuColorRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:ciXiuColorRoom];
    
    NSArray *zhuoZhuangFengGeRoom = dict[@"1-8"];
    self.zhuoZhuangFengGeRoom = [TLParameterModel tl_objectArrayWithDictionaryArray:zhuoZhuangFengGeRoom];

    


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

    return [NSMutableArray new];

}


- (NSMutableArray *)configDefaultModel {

    return [NSMutableArray new];

}

@end
