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
#import "NSNumber+TLAdd.h"

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
    
//    NSArray <NSDictionary *>*typeArr = @[
//
//                                         @{  @"2-01" : @"领围"},
//                                         @{  @"2-02" : @"胸围"},
//                                         @{  @"2-03" : @"中腰围"},
//                                         @{  @"2-04" : @"裤腰围"},
//                                         @{  @"2-05" : @"臀围"},
//                                         @{  @"2-06" : @"大腿围"},
//                                         @{  @"2-07" : @"通档"},
//                                         @{  @"2-08" : @"臂围"},
//                                         @{  @"2-09" : @"总肩宽"},
//                                         @{  @"2-10" : @"袖长"},
//                                         @{  @"2-11" : @"前肩宽"},
//                                         @{  @"2-12" : @"后腰节长"},
//                                         @{  @"2-13" : @"后腰高"},
//                                         @{  @"2-14" : @"后衣长"},
//                                         @{  @"2-15" : @"前腰节长"},
//                                         @{  @"2-16" : @"前腰高"},
//                                         @{  @"2-17" : @"裤长"},
//                                         @{  @"2-18" : @"小腿围"},
//                                         @{  @"2-19" : @"前胸宽"},
//                                         @{  @"2-20" : @"后背宽"},
//                                         @{  @"2-21" : @"腹围"},
//                                         @{  @"2-22" : @"小臂围"},
//                                         @{  @"2-23" : @"前衣长"},
//                                         @{  @"2-24" : @"腕围"}
//                                         ];

    //组装量体信息，如果当前 数据控制器，的订单中测量信息不为空，就读取对应的值
    //在用户详情中，可能也有这些信息，？？怎样处理
    self.measureDataRoom = [[NSMutableArray alloc] init];

//    {
//        dkey = "2-24";
//        dvalue = "\U8155\U56f4";
//        id = 80;
//        parentKey = measure;
//        remark = "";
//        sizeData =                     {
//            ckey = "2-24";
//            cvalue = "\U8155\U56f4";
//            dkey = 10;
//            id = 350;
//            userId = U1111111111111111;
//        };
//        systemCode = "CD-CDZT000009";
//        type = 1;
//        updateDatetime = "Sep 11, 2017 11:12:26 AM";
//        updater = admin;
//    }
    [self.customerStatisticsInfo.measure enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLInputDataModel *model = [[TLInputDataModel alloc] init];
        model.keyCode = obj[@"dkey"]; //1-2
        model.keyName = obj[@"dvalue"];
        
        //是否必填
        model.isMust = obj[@"remark"] && [obj[@"remark"] isEqualToString:@"1"];
        
        if (obj[@"sizeData"]) {
            
            NSDictionary *sizeData = obj[@"sizeData"];
            model.value = sizeData[@"dkey"];

        }
        
        [self.measureDataRoom addObject:model];
        
    }];
    
    
   

    
//    NSArray <NSDictionary *>*typeArr = @[
//
//                                         @{  @"2-01" : @"领围"},
//                                         @{  @"2-02" : @"胸围"},
//                                         @{  @"2-03" : @"中腰围"},
//                                         @{  @"2-04" : @"裤腰围"},
//                                         @{  @"2-05" : @"臀围"},
//                                         @{  @"2-06" : @"大腿围"},
//                                         @{  @"2-07" : @"通档"},
//                                         @{  @"2-08" : @"臂围"},
//                                         @{  @"2-09" : @"总肩宽"},
//                                         @{  @"2-10" : @"袖长"},
//                                         @{  @"2-11" : @"前肩宽"},
//                                         @{  @"2-12" : @"后腰节长"},
//                                         @{  @"2-13" : @"后腰高"},
//                                         @{  @"2-14" : @"后衣长"},
//                                         @{  @"2-15" : @"前腰节长"},
//                                         @{  @"2-16" : @"前腰高"},
//                                         @{  @"2-17" : @"裤长"},
//                                         @{  @"2-18" : @"小腿围"},
//                                         @{  @"2-19" : @"前胸宽"},
//                                         @{  @"2-20" : @"后背宽"},
//                                         @{  @"2-21" : @"腹围"},
//                                         @{  @"2-22" : @"小臂围"},
//                                         @{  @"2-23" : @"前衣长"},
//                                         @{  @"2-24" : @"腕围"}
//                                         ];
//
//    //组装量体信息，如果当前 数据控制器，的订单中测量信息不为空，就读取对应的值
//    //在用户详情中，可能也有这些信息，？？怎样处理
//    self.measureDataRoom = [[NSMutableArray alloc] initWithCapacity:typeArr.count];
//
//    [typeArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//
//        TLInputDataModel *model = [[TLInputDataModel alloc] init];
//        model.keyCode = obj.allKeys[0]; //1-2
//        model.keyName = obj[model.keyCode];
//
//        [self.customerStatisticsInfo.sizeDataList enumerateObjectsUsingBlock:^(TLMeasureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            if ([model.keyCode isEqualToString:obj.ckey]) {
//
//                model.value = obj.dkey;
//                *stop = YES;
//            }
//
//        }];
//
//        [self.measureDataRoom addObject:model];
//
//    }];
}



- (void)configXingTiDataModelWithResp:(id)resp {
    
    self.xingTiRoom = [[NSMutableArray alloc] init];
//    NSArray <NSDictionary *> *xingArr = @[
//
//                                          @{@"4-01" : @"形态"},
//                                          @{@"4-02" : @"背型"},
//                                          @{@"4-03" : @"左肩"},
//                                          @{@"4-05":  @"脖子"},
//                                          @{@"4-04" : @"右肩"},
//                                          @{@"4-06" : @"肤色"},
//                                          @{@"4-07" : @"肚型"},
//                                          @{@"4-08" : @"色彩"},
//                                          @{@"4-09" : @"手臂"},
//                                          @{@"4-10" : @"对比"},
//                                          @{@"4-11" : @"臀型"},
//                                          @{@"4-12" : @"量感"}
//
//                                          ];
    
    //*****************//
    [self.customerStatisticsInfo.figure enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLChooseDataModel *chooseDataModel = [[TLChooseDataModel alloc] init];
        chooseDataModel.type =  obj[@"dkey"];
        chooseDataModel.typeName = obj[@"dvalue"];
        chooseDataModel.parameterModelRoom = [[NSMutableArray alloc] init];
        chooseDataModel.canEdit = YES;
        
        //找出对应的值
        if (obj[@"sizeData"]) {
            NSDictionary *sizeData = obj[@"sizeData"];
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
    
    //******************//
}


- (void)handleUserInfo:(id)resp {

    
    self.userInfoRoom = [[NSMutableArray alloc] init];
    self.vipInfoRoom = [[NSMutableArray alloc] init];
    
    
    //用户信息
    NSMutableArray <NSDictionary *> *userInfoInfoArr = [  @[
                                                         @{@"客户姓名" : self.customerStatisticsInfo.realName},
                                                         @{@"联系电话" : self.customerStatisticsInfo.mobile ? : @""}
                
                                                         ] mutableCopy];
    
    if (self.customerStatisticsInfo.address) {
        [userInfoInfoArr addObject:@{@"收货地址" : self.customerStatisticsInfo.address}];
    }

    //
    if (self.customerStatisticsInfo.other) {
        
        [self.customerStatisticsInfo.other enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj[@"dkey"] isEqualToString:@"6-02"]) {
                
                if (obj[@"sizeData"]) {
                    
                    [userInfoInfoArr addObject:@{@"身高" : [NSString stringWithFormat:@"%@ cm",obj[@"sizeData"][@"dkey"]]
                                                 }];
                }
               
            } else  if ([obj[@"dkey"] isEqualToString:@"6-03"]) {
                
                if (obj[@"sizeData"]) {
                    
                    [userInfoInfoArr addObject:@{@"体重" : [NSString stringWithFormat:@"%@ kg",obj[@"sizeData"][@"dkey"]]
                                                 }];
                }
                
            }
            
        }];
        
    
      }

    

    [userInfoInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLDataModel *model = [[TLDataModel alloc] init];
        model.keyName = obj.allKeys[0];
        model.value = obj[model.keyName];
        [self.userInfoRoom addObject:model];
        
    }];
    
    NSDictionary *vipDict = @{
                           
                           @"1": @"普通用户",
                           @"2": @"银卡会员",
                           @"3": @"金卡会员",
                           @"4": @"铂金会员",
                           @"5": @"钻石会员"
                           
                           };
    
    //
    NSMutableArray <NSDictionary *> *vipInfoInfoArr = nil;
    

    
    
      vipInfoInfoArr  = [  @[
               @{@"会员等级" :vipDict[self.customerStatisticsInfo.level]},
               @{@"会员成长经验" :     [self convertBigDigital: self.customerStatisticsInfo.jyAmount]},
               @{@"会员天数" : self.customerStatisticsInfo.days},
               @{@"升级所需经验" : [self convertBigDigital:self.customerStatisticsInfo.sjAmount]},
               @{@"会员生日" : [self.customerStatisticsInfo getBirthdayStr]},
               @{@"历史总积分" : [self convertBigDigital:@([self.customerStatisticsInfo.conAmount longLongValue] + [self.customerStatisticsInfo.jfAmount longLongValue])]},
               @{@"剩余积分" : [self convertBigDigital:self.customerStatisticsInfo.jfAmount]},
               @{@"已消费积分" : [self convertBigDigital:self.customerStatisticsInfo.conAmount]},
               
               ] mutableCopy];
        
    
    
//    }

    [vipInfoInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLInputDataModel *model = [[TLInputDataModel alloc] init];
        model.keyName = obj.allKeys[0];
        model.value = obj[model.keyName];
        model.canEdit = NO;
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

- (NSString *)convertBigDigital:(NSNumber *)digital {

    long long digitalNumber = [digital longLongValue];
    
    if (digitalNumber > 10000*1000) {
        
        
//        return [NSString stringWithFormat:@"%.2f万",digitalNumber/(10000.0*1000)];
        return [NSString stringWithFormat:@"%.f",[digital longLongValue]/(1000.0)];

    } else {
    
        return [NSString stringWithFormat:@"%.f",[digital longLongValue]/(1000.0)];
        
    }

}

@end
