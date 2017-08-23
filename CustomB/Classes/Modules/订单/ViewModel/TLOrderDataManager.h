//
//  TLOrderDataManager.h
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLGroup.h"
#import "TLOrderModel.h"
#import "TLDataModel.h"
#import "TLParameterModel.h"
#import "TLCiXiuTextInputCell.h"
@class TLChooseDataModel;

@interface TLOrderDataManager : NSObject

@property (nonatomic, strong) NSMutableArray <TLGroup *>*groups;
@property (nonatomic, strong) TLOrderModel *order;


//形体数据
- (void)configXingTiDataModelWithResp:(id)resp;
@property (nonatomic, strong) NSMutableArray <TLChooseDataModel *>*xingTiRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*xingTaiRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*beiXingRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*zuoJianRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*boZiRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*youJianRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*fuSeRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*duXingRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*seCaiRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*shouBiRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*duiBiRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*tunXingRoom;
//@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*liangGanRoom;



- (NSMutableArray <TLCiXiuTextInputCell *>*)configCiXiuTextDataModel;

/**
 配置不变的 如订单信息，物流信息 客户
 */
- (NSMutableArray <TLDataModel *>*)configConstOrderInfoDataModel;
- (NSMutableArray *)configConstLogisticsInfoDataModel;
- (NSMutableArray *)configConstUserInfoDataModel;


- (NSMutableArray *)configDefaultModel;

//

- (void)handMeasureData:(id)responseObject;
@property (nonatomic, strong) NSMutableArray <TLDataModel *>*measureDataRoom;


//以下必须先调方法，然后数组才会有初始化的值
- (void)handleParameterData:(id)responseObject;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*zhuoZhuangFengGeRoom;

@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*guiGeRoom;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*menJinRoom;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*lingXingRoom;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*xiuXingRoom;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*kouDaiRoom;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*shouXingRoom;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*fontRoom;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*ciXiuLocationRoom;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*ciXiuColorRoom;



@end
