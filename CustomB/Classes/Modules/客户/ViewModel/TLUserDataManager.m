//
//  TLUserDataManager.m
//  CustomB
//
//  Created by  tianlei on 2017/8/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUserDataManager.h"
#import "TLChooseDataModel.h"
#import "TLInputDataModel.h"

@implementation TLUserDataManager

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
//        model.value = @"111";

        
        if (self.customerStatisticsInfo.resultMap && self.customerStatisticsInfo.resultMap.CELIANG) {
            
            model.value =  self.customerStatisticsInfo.resultMap.CELIANG[model.keyCode] ?  : @"-";
            
//            [self.customerStatisticsInfo.sizeDataList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                if ([obj[@"ckey"] isEqualToString:model.keyCode]) {
//                    
//                    model.value = obj[@"dkey"];
//                    *stop = YES;
//                }
//                
//            }];

        }

        
        if (!resp) {
            //查询订单中信息进行赋值
//            if (self.order.resultMap.CELIANG && self.order.resultMap.CELIANG[model.keyCode]) {
//                
//                NSDictionary *dict = self.order.resultMap.CELIANG[model.keyCode];
//                model.value =   dict[@"code"] ? dict[@"code"] : @"-";
//            }
            
        } else {
            
            //根据传入的结果进行估值
            //用在用户信息界面
            
        }
        
        [self.measureDataRoom addObject:model];
        
    }];

    
}



- (void)configXingTiDataModelWithResp:(id)resp {
    
    self.xingTiRoom = [[NSMutableArray alloc] init];
    NSArray <NSDictionary *> *xingArr = @[
                                          
                                          @{@"4-01" : @"形态"},
                                          @{@"4-02" : @"背型"},
                                          @{@"4-03" : @"左肩"},
                                          @{@"4-05":  @"脖子"},
                                          @{@"4-04" : @"右肩"},
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
        chooseDataModel.canEdit = YES;
        
        //形体对应的类
//     NSDictionary *valueDict =
        
        if (self.customerStatisticsInfo.resultMap.TIXIN) {
            //找出对应小类的Value
            // 如 A
            NSString *selectValueCode = self.customerStatisticsInfo.resultMap.TIXIN[chooseDataModel.type];
            
            //在去resp 中把value取出来
//            "4-02" =         {
//                A = "\U6b63\U5e38";
//                B = "\U9a7c\U80cc";
//            };
            chooseDataModel.typeValue = selectValueCode;
            
            NSDictionary *perDict = dict[chooseDataModel.type]; // key  "4-02"
            chooseDataModel.typeValueName = perDict[selectValueCode];
            
        }
        
        
        //
        NSString *code = obj.allKeys[0]; //1-2
        NSDictionary *paraDict = dict[code];
        
        //组装下部大类 后 跟着的选项
        [paraDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TLParameterModel *model = [[TLParameterModel alloc] init];
            
            model.code = key;
            model.name = paraDict[key];
            model.type = code;
            model.typeName = obj[code];
            
            //找出已经选择 的
//            [self.customerStatisticsInfo.sizeDataList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                if ([obj[@"ckey"] isEqualToString:model.type]) {
//                    
//                    chooseDataModel.typeValue = obj[@"dkey"];
//                    chooseDataModel.typeValueName = obj[@"dvalue"];
//                    *stop = YES;
//                }
//                
//            }];
            
            
//            if (selectValueCode && [selectValueCode isEqualToString:model.code]) {
//                chooseDataModel.typeValue = model.name;
//            }
            
            [chooseDataModel.parameterModelRoom addObject:model];
            
        }];
        
        [self.xingTiRoom addObject:chooseDataModel];
        
    }];
    //---//
    
    
}


- (void)handleUserInfo:(id)resp {

    
    self.userInfoRoom = [[NSMutableArray alloc] init];
    self.vipInfoRoom = [[NSMutableArray alloc] init];
    
    
    //用户信息
    NSMutableArray <NSDictionary *> *userInfoInfoArr = [  @[
                                                         @{@"客户姓名" : self.customerStatisticsInfo.realName},
                                                         @{@"联系电话" : self.customerStatisticsInfo.mobile}
                
                                                         ] mutableCopy];
    
    if (self.customerStatisticsInfo.address) {
        [userInfoInfoArr addObject:@{@"收货地址" : self.customerStatisticsInfo.address}];
    }

    //
    if (self.customerStatisticsInfo.resultMap.QITA[@"6-02"]) {
            
        
            [userInfoInfoArr addObject:@{@"身高" : [NSString stringWithFormat:@"%@ cm",self.customerStatisticsInfo.resultMap.QITA[@"6-02"]]}];
            
      }
        
     //
     if (self.customerStatisticsInfo.resultMap.QITA[@"6-03"]) {
            
         
            [userInfoInfoArr addObject:@{@"体重" : [NSString stringWithFormat:@"%@ kg",self.customerStatisticsInfo.resultMap.QITA[@"6-03"]]}];
            
      }
    //
    

    [userInfoInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLDataModel *model = [[TLDataModel alloc] init];
        model.keyName = obj.allKeys[0];
        model.value = obj[model.keyName];
        [self.userInfoRoom addObject:model];
        
    }];
    
    
    
    //
    NSMutableArray <NSDictionary *> *vipInfoInfoArr = [  @[
                                                            @{@"会员等级" : self.customerStatisticsInfo.level},
                                                            @{@"会员成长经验" : self.customerStatisticsInfo.jyAmount},
                                                            @{@"会员天数" : self.customerStatisticsInfo.days},
                                                              @{@"升级所需经验" : self.customerStatisticsInfo.sjAmount},
                                                             @{@"剩余积分" : self.customerStatisticsInfo.jfAmount},
                                                            
                                                            ] mutableCopy];
    
    


    [vipInfoInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLInputDataModel *model = [[TLInputDataModel alloc] init];
        model.keyName = obj.allKeys[0];
        model.value = obj[model.keyName];
        [self.vipInfoRoom addObject:model];
        
    }];
    //address	地址	string
    //days	成为会员天数	string
    
    //jfAmount	积分数	string
    //jyAmount	经验数	string
    
    //mobile	手机号	string
    //realName	真实姓名	string
    //sizeDataList	身材数据	array
    
    //sjAmount	升级积分


}

@end
