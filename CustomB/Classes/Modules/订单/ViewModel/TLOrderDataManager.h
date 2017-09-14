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
#import "TLInputDataModel.h"

@class TLGuiGeDaLei;
@class TLChooseDataModel;

@interface TLOrderDataManager : NSObject

- (instancetype)initWithOrder:(TLOrderModel *)order;
- (instancetype)init;

@property (nonatomic, strong) NSMutableArray <TLGroup *>*groups;
@property (nonatomic, strong) TLOrderModel *order;

//形体数据
- (void)configXingTiDataModelWithResp:(id)resp;
@property (nonatomic, strong) NSMutableArray <TLChooseDataModel *>*xingTiRoom;

//测量数据
- (void)handMeasureDataWithResp:(id)resp;
@property (nonatomic, strong) NSMutableArray <TLInputDataModel *>*measureDataRoom;

//刺绣文字
//- (NSMutableArray <TLCiXiuTextInputCell *>*)configCiXiuTextDataModel;

//除形体之外的可选参数, 拉出全部选型
- (void)handleParameterData:(id)responseObject;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*zhuoZhuangFengGeRoom;
@property (nonatomic, strong) NSString  *zhuoZhuangFengGeValue;

@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*guiGeRoom;
@property (nonatomic, strong) NSString  *guiGeValue;

@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*menJinRoom;
@property (nonatomic, strong) NSString  *menJinValue;

@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*lingXingRoom;
@property (nonatomic, strong) NSString  *lingXingValue;

@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*xiuXingRoom;
@property (nonatomic, strong) NSString  *xiuXingValue;

@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*kouDaiRoom;
@property (nonatomic, strong) NSString  *kouDaiValue;

@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*shouXingRoom;
@property (nonatomic, strong) NSString  *shouXingValue;

/****************************** 刺绣相关 ******************************************/
- (void)handleCiXiu:(NSMutableArray <TLGuiGeDaLei *>*)room;
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*fontRoom;
@property (nonatomic, strong) NSString  *fontValue;

@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*ciXiuLocationRoom;
@property (nonatomic, strong) NSString  *ciXiuLocationValue;

@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*ciXiuColorRoom;
@property (nonatomic, strong) NSString  *ciXiuColorValue;

//
@property (nonatomic, strong) NSMutableArray <TLInputDataModel *>*ciXiuTextRoom;
@property (nonatomic, strong) NSString  *ciXiuTextValue;

/****************************** 杂项 ******************************************/
//备注
@property (nonatomic, strong) NSMutableArray <TLInputDataModel *>*remarkRoom;
@property (nonatomic, strong) NSString  *remarkValue;

//收货
@property (nonatomic, strong) NSMutableArray <TLInputDataModel *>*shouHuoAddressRoom;
@property (nonatomic, strong) NSString  *shouHuoValue;

//面料
- (void)handleMianLiaoData:(id)responseObject;
@property (nonatomic, strong) NSMutableArray < TLParameterModel*>*mianLiaoRoom;
@property (nonatomic, strong) NSString  *mianLiaoValue;


/**
 配置不变的 如订单信息，物流信息 客户，此类信息较固定
 */
- (NSMutableArray <TLDataModel *>*)configConstOrderInfoDataModel;

- (NSMutableArray <TLDataModel *>*)configConstUserInfoDataModel; // 用户信息

- (NSMutableArray <TLDataModel *>*)configProductInfoDataModel; //产品信息

- (NSMutableArray *)configConstLogisticsInfoDataModel; //物流

- (NSMutableArray *)configDefaultModel;

@end
