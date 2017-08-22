//
//  NBNetworkAgent.h
//  HTTP
//
//  Created by  tianlei on 2017/7/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBBaseRequest;

@interface NBNetworkAgent : NSObject

+ (instancetype)defaultAgent;

- (void)startReq:(__kindof NBBaseRequest *)req;

@end
