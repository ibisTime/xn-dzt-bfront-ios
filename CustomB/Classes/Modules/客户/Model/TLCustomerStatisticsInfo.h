//
//  TLCustomerStatisticsInfo.h
//  CustomB
//
//  Created by  tianlei on 2017/8/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLUserParameterMap.h"
#import "TLMeasureModel.h"

@interface TLCustomerStatisticsInfo : TLBaseModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, strong) NSNumber *jfAmount;
@property (nonatomic, strong) NSNumber *jyAmount;
@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *level;

//@property (nonatomic, copy) NSArray <TLMeasureModel *>*sizeDataList;
//{
//    figure : [],
//    measure : [],
//    other : []
//}

//dkey = "4-01";
//dvalue = "\U5de6\U80a9";
//id = 81;
//parentKey = figure;
//remark = "";
//sizeData =                     {
//    ckey = "4-01";
//    cvalue = "\U4f53\U578b";
//    dkey = A;
//    dvalue = "\U6b63\U5e38\U4f53\U578b";
//    id = 247;
//    userId = U1111111111111115;
//};
//systemCode = "CD-CDZT000009";
//type = 1;
//updateDatetime = "Sep 11, 2017 11:12:26 AM";
//updater = admin;
@property (nonatomic, assign, readonly) NSArray<NSDictionary *> *figure;
@property (nonatomic, assign, readonly) NSArray<NSDictionary *> *measure;
@property (nonatomic, assign, readonly) NSArray<NSDictionary *> *other;

// SB SB
@property (nonatomic, strong) NSDictionary *sysDictMap;

@property (nonatomic, strong) NSNumber *sjAmount;
- (NSString *)getBirthdayStr;

@property (nonatomic, strong) NSNumber *conAmount;


//address	地址	string
//days	成为会员天数	string
//jfAmount	积分数	string
//jyAmount	经验数	string
//mobile	手机号	string
//realName	真实姓名	string
//sizeDataList	身材数据	array
//sjAmount	升级积分

//sizeDataList =         (
//                        {
//                            ckey = "2-01";
//                            cvalue = "\U9886\U56f4";
//                            dkey = 110;
//                            id = 210;
//                            userId = U201708291024258947121;
//                        },

@end
