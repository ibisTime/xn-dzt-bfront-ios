//
//  TLOrderModel.h
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLCustomer.h"
#import "TLUser.h"
#import "TLUserProduct.h"
#import "TLUserParameterMap.h"

typedef NS_ENUM(NSUInteger, TLOrderType) {
    
    TLOrderTypeChenShanDidDingJia,
    TLOrderTypeChenShanUnDingJia,
    TLOrderTypeHAddDidDingJia,
    TLOrderTypeHAddUnDingJia,
    TLOrderTypeProductUnChoose
    

    
};

@interface TLOrderModel : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *ltName;

//量体信息
@property (nonatomic, copy) NSString *ltProvince;
@property (nonatomic, copy) NSString *ltCity;
@property (nonatomic, copy) NSString *ltArea;
@property (nonatomic, copy) NSString *ltAddress;
@property (nonatomic, copy) NSString *ltDatetime;

@property (nonatomic, copy) NSString *applyName;
@property (nonatomic, copy) NSString *applyMobile;

//
@property (nonatomic, copy) NSString *deliverer;
@property (nonatomic, copy) NSString *deliveryDatetime;
@property (nonatomic, copy) NSString *logisticsCode;
@property (nonatomic, copy) NSString *logisticsCompany;

//产品信息
@property (nonatomic, copy) NSString *modelCode;
@property (nonatomic, copy) NSString *modelName;


@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *payAmount;
@property (nonatomic, strong) NSNumber *originalAmount;


@property (nonatomic, copy) NSString *remark;
@property (nonatomic, strong) NSNumber *times;

//0为衬衫订单，1为H+ 为空时
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSMutableArray <TLUserProduct *>*productList;

@property (nonatomic, strong) TLUserParameterMap *resultMap;
//量体用户
@property (nonatomic, strong) TLCustomer *ltUserDO;


- (TLOrderType)getOrderType;


- (NSString *)getDetailAddress;


- (NSString *)getStatusName;


/**
 定制信息是否可以改变
 */
- (BOOL)canEditDingZhi;

/**
 形体是否可以编辑
 */
- (BOOL)canEditXingTi;

/**
 是否可以提交复核
 */
- (BOOL)canSubmitCheck;

/**
 是否可以提交数据，待录入状态的可以
 */
- (BOOL)canSubmitData;

@end

//"code":"DD201708171511465585",
//"type":"0",
//"toUser":"0",
//"applyUser":"U201708171354515884944",
//"applyName":"szz",
//"applyMobile":"15738777150",
//"ltDatetime":"Aug 19, 2017 12:00:00 AM",
//"ltProvince":"浙江省",
//"ltCity":"杭州市",
//"ltArea":"下城区",
//"ltAddress":"梦想小镇",
//"applyNote":"bbb",
//"createDatetime":"Aug 17, 2017 3:11:42 PM",
//"status":"3",
//"ltUser":"U201708220942536311425",
//"ltName":"田磊",
//"amount":499000,
//"payDatetime":"Aug 23, 2017 9:32:16 PM",
//"payAmount":499000,
//"receiver":"szz",
//"reMobile":"15738777150",
//"reAddress":"12",
//"updater":"admin",
//"updateDatetime":"Aug 23, 2017 9:35:35 PM",
//"remark":"ios remark",

