//
//  TLOrderModel.h
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

typedef NS_ENUM(NSUInteger, TLOrderType) {
    
    TLOrderTypeChenShan,
    TLOrderTypeHAdd,
    TLOrderTypeProductUnChoose
    
};

@interface TLOrderModel : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *createDatetime;
@property (nonatomic, copy) NSString *applyMobile;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *applyName;

@property (nonatomic, copy) NSString *ltProvince;
@property (nonatomic, copy) NSString *ltCity;
@property (nonatomic, copy) NSString *ltArea;
@property (nonatomic, copy) NSString *ltAddress;
@property (nonatomic, copy) NSString *ltDatetime;

@property (nonatomic, copy) NSString *remark;

//0为衬衫订单，1为H+ 为空时
@property (nonatomic, copy) NSString *type;



- (TLOrderType)getOrderType;

- (NSString *)getDetailAddress;


- (NSString *)getStatusName;

@end


//applyMobile = 18868824532;
//applyName = "\U5434\U8054\U8bf74";
//applyUser = U201708071922132277071;
//code = DD201708221013261186;
//createDatetime = "Aug 22, 2017 10:13:26 AM";
//ltAddress = mmmm;
//ltArea = "\U767d\U94f6\U533a";
//ltCity = "\U767d\U94f6\U5e02";
//ltDatetime = "Aug 21, 2017 12:00:00 AM";
//ltProvince = "\U7518\U8083\U7701";
//reMobile = 18868824532;
//receiver = "\U5434\U8054\U8bf74";
//status = 11;
//toUser = 0;
//updateDatetime = "Aug 22, 2017 10:13:54 AM";
//updater = U201708071922132277071;
