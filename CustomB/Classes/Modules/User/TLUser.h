 //
//  TLUser.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface TLUser : TLBaseModel

+ (instancetype)user;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *ljAmount;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *nickname;
//0 未设置交易密码 1已设置  
@property (nonatomic, strong) NSNumber *tradepwdFlag;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *idNo;

//推荐人
//@property (nonatomic, copy) NSString *userRefereeName;

@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *totalFansNum;
@property (nonatomic, copy) NSString *totalFollowNum;
@property (nonatomic, copy) NSString *updateDatetime;
@property (nonatomic, copy) NSString *updater;

@property (nonatomic,copy) NSString *photo;

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;


/**
 量体师编号
 */
@property (nonatomic, copy) NSString *roleCode;

//是否为需要登录，如果已登录，取出用户信息
- (BOOL)isLogin;

- (void)loginOut;

//存储用户信息
- (void)saveUserInfo:(NSDictionary *)userInfo;

//设置出tokenId 和 userId 之外的用户信息
- (void)setUserInfoWithDict:(NSDictionary *)dict;

- (void)updateUserInfo;

- (NSString *)detailAddress;
@end

FOUNDATION_EXTERN  NSString *const kUserLoginNotification;
FOUNDATION_EXTERN  NSString *const kUserLoginOutNotification;
FOUNDATION_EXTERN  NSString *const kUserInfoChange;

