//
//  NBCDRequest.m
//  HTTP
//
//  Created by  tianlei on 2017/7/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NBCDRequest.h"
#import "NBNetworkAgent.h"

@implementation NBCDRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.HTTPMethod = NBRequestMethodPOST;
    }
    return self;
}
#pragma mark- Over
- (void)start {

    if (!self.URLString && !self.code) {
        
        @throw [NSException exceptionWithName:@"URLString 和Code 都不能为空" reason:nil userInfo:nil];
        
    }

    //
    NBNetworkAgent *networkAgent = [NBNetworkAgent new];
    [networkAgent startReq:self];
    
}


/**
  只支持post
 */
- (NBRequestMethod)HTTPMethod {

    return NBRequestMethodPOST;
    
}


- (NSDictionary<NSString *,NSString *> *)convertParameters {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    dict[@"code"] = self.code;
    dict[@"json"] = @""; //default
    
    //   {
    //     "code" : 000,
    //     "json" : {
    //                ...
    //              }
    //    }
    if (self.parameters) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.parameters options:NSJSONWritingPrettyPrinted error:nil];
        dict[@"json"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    
    return self.parameters;
    
}
@end
