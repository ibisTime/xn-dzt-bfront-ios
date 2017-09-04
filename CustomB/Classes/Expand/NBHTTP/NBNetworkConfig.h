//
//  NBNetworkConfig.h
//  HTTP
//
//  Created by  tianlei on 2017/7/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBBaseRequest;

@protocol NBRespDelegate <NSObject>

- (void)handleHttpSuccessWithReq:(NBBaseRequest *)req task:(NSURLSessionDataTask *)task resp:(id)responseObject  ;

- (void)handleHttpFailureWithReq:(NBBaseRequest *)req task:(NSURLSessionDataTask *)task error:(NSError *)error ;

@end

@interface NBNetworkConfig : NSObject

+ (instancetype)config;

@property (nonatomic, copy) NSString *baseUrl;

/**
 响应处理的delegate
 */
@property (nonatomic, weak)  id<NBRespDelegate> respDelegate;


@end
