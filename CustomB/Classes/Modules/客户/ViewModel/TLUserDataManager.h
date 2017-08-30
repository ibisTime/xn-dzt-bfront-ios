//
//  TLUserDataManager.h
//  CustomB
//
//  Created by  tianlei on 2017/8/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLCustomerStatisticsInfo.h"
#import "TLDataModel.h"
#import "TLGroup.h"
@class TLChooseDataModel;
@class TLInputDataModel;

@interface TLUserDataManager : NSObject

@property (nonatomic, strong) NSMutableArray <TLGroup *>*groups;

- (instancetype)init;
@property (nonatomic, strong) TLCustomerStatisticsInfo *customerStatisticsInfo;



/**
 处理用户信息和会员信息
 */
- (void)handleUserInfo:(id)resp;
@property (nonatomic, strong) NSMutableArray<TLDataModel *> *userInfoRoom;
@property (nonatomic, strong) NSMutableArray<TLInputDataModel *> *vipInfoRoom;


//形体
//形体数据
- (void)configXingTiDataModelWithResp:(id)resp;
@property (nonatomic, strong) NSMutableArray <TLChooseDataModel *>*xingTiRoom;

//测量数据
- (void)handMeasureDataWithResp:(id)resp;
@property (nonatomic, strong) NSMutableArray <TLInputDataModel *>*measureDataRoom;

@end
