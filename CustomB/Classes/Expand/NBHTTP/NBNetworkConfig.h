//
//  NBNetworkConfig.h
//  HTTP
//
//  Created by  tianlei on 2017/7/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NBRespFilter;


@interface NBNetworkConfig : NSObject

+ (instancetype)config;

@property (nonatomic, copy) NSString *baseUrl;

/**
 成功过滤，请求满足这个，过滤器直接进行回调
 */
@property (nonatomic, strong) NBRespFilter *successFilter;

/**
 异常，为所有请求过滤数据
 */
@property (nonatomic, strong) NBRespFilter *abnormalRespFilter;


//@property (nonatomic, strong) NSMutableArray <NBRespFilter *> *abnormalRespFilter;


@end
