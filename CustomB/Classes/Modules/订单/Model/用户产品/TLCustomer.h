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
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *ljAmount;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *nickname;
//0 未设置交易密码 1已设置
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *updateDatetime;
@property (nonatomic, copy) NSString *updater;

@end
