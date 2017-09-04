//
//  TLNetworkingConfig.h
//  CustomB
//
//  Created by  tianlei on 2017/9/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLNetworkingConfig : NSObject

+ (instancetype)config;

@property (nonatomic, copy) NSString *systemCode;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *kind;

@end
