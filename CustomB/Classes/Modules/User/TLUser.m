//
//  TLUser.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUser.h"
#import "APICodeHeader.h"
#import "TLNetworking.h"

#define USER_ID_KEY @"user_id_key_zh"
#define TOKEN_ID_KEY @"token_id_key_zh"
#define USER_INFO_DICT_KEY @"user_info_dict_key_zh"

NSString *const kUserLoginNotification = @"kUserLoginNotification_zh";
NSString *const kUserLoginOutNotification = @"kUserLoginOutNotification_zh";
NSString *const kUserInfoChange = @"kUserInfoChange_zh";

@implementation TLUser

+ (instancetype)user {

    static TLUser *user = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        user = [[TLUser alloc] init];
    });
    
    return user;

}


- (void)setUserId:(NSString *)userId {

    _userId = [userId copy];
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)setToken:(NSString *)token {

    _token = [token copy];
    [[NSUserDefaults standardUserDefaults] setObject:_token forKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


- (BOOL)isLogin {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    if (userId && token) {
        
        self.userId = userId;
        self.token = token;
        [self setUserInfoWithDict:[userDefault objectForKey:USER_INFO_DICT_KEY]];
        
        return YES;
    } else {
    
    
        return NO;
    }

}



- (void)loginOut {
    
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([TLUser class], &count);
    // 遍历
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properties[i];
        // 获取属性的名称
        const char *cName = property_getName(property);
        // 转换为Objective
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        //基础数据类型，不能置为nil
//        if ([name isEqualToString:@"isReg"] || [name isEqualToString:@"haveShopInfo"]) {
//            
//            continue;
//        }
        
        [self setValue:nil forKeyPath:name];
    }
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_DICT_KEY];

}


- (void)saveUserInfo:(NSDictionary *)userInfo {

    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO_DICT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}




- (void)updateUserInfo {

    TLNetworking *http = [TLNetworking new];
    http.isShowMsg = NO;
    http.code = USER_INFO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [self setUserInfoWithDict:responseObject[@"data"]];
        [self saveUserInfo:responseObject[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];

}


- (void)setUserInfoWithDict:(NSDictionary *)dict {
    
    [self setValuesForKeysWithDictionary:dict];
 
    
}

// 处理一些基本数据类型
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {


}


- (NSString *)detailAddress {

    if (!self.province) {
        return @"未知";
    }
    return [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.area];

}


@end
