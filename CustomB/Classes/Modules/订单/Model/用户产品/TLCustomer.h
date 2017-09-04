//
//  TLCustomer.h
//  CustomB
//
//  Created by  tianlei on 2017/8/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLCustomer : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, copy) NSString *createDatetime;
//@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *level;
//@property (nonatomic, copy) NSString *ljAmount;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *nickname;
//0 未设置交易密码 1已设置
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *updateDatetime;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, copy) NSString *frequent;


@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *lastOrderDatetime;



- (NSString *)getDetailAddress;
- (NSString *)getCustomerTitle;

// 金卡会员，银卡会员
- (NSString *)getVipName;

@property (nonatomic, assign) BOOL is;

//area = "\U4f59\U676d\U533a";
//city = "\U676d\U5dde\U5e02";
//companyCode = "CD-CDZT000009";
//createDatetime = "Aug 17, 2017 3:30:06 PM";
//idNo = 333302201612128529;
//kind = B;
//lastOrderDatetime = "Aug 22, 2017 12:09:00 PM";
//level = 1;
//loginName = song;
//loginPwdStrength = 1;
//mobile = 15738777150;
//nickname = 61085458;
//province = "\U6d59\U6c5f\U7701";
//realName = "\U5b8b\U771f\U771f";
//frequent 活跃度
//refereeUser =                 {
//    appOpenId = 1111111111111;
//    area = "\U4f59\U676d\U533a";
//    city = "\U676d\U5dde\U5e02";
//    companyCode = "CD-CDZT000009";
//    createDatetime = "Aug 17, 2017 11:37:23 AM";
//    divRate = "0.2";
//    idNo = 333302201612128529;
//    kind = PA;
//    lastOrderDatetime = "Aug 22, 2017 12:08:58 PM";
//    level = 1;
//    loginName = "\U4f59\U676d\U5408\U4f19\U4eba";
//    loginPwdStrength = 1;
//    mobile = 15738777150;
//    nickname = 36185567;
//    province = "\U6d59\U6c5f\U7701";
//    realName = szz;
//    roleCode = DZTSR20170000000000hhr;
//    status = 0;
//    systemCode = "CD-CDZT000009";
//    tradepwdFlag = 0;
//    updateDatetime = "Aug 17, 2017 11:37:23 AM";
//    updater = admin;
//    userId = U201708171137236185567;
//};
//roleCode = DZTSR20170000000000lts;
//status = 0;
//systemCode = "CD-CDZT000009";
//tradePwdStrength = 1;
//tradepwdFlag = 0;
//updateDatetime = "Aug 25, 2017 3:15:00 PM";
//updater = "\U4f59\U676d\U5408\U4f19\U4eba";
//userId = U201708171530061085458;
//userReferee = U201708171137236185567;



@end
