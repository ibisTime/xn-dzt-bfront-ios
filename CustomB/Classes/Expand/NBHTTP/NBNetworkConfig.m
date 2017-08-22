//
//  NBNetworkConfig.m
//  HTTP
//
//  Created by  tianlei on 2017/7/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NBNetworkConfig.h"

@implementation NBNetworkConfig

+ (instancetype)config {
    
    static NBNetworkConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        config = [[self alloc] init];
        
    });
    
    return config;

}


//- (NSMutableArray<NBRespFilter *> *)abnormalRespFilter {
//
//    if (!_abnormalRespFilter) {
//        
//        _abnormalRespFilter = [[NSMutableArray alloc] init];
//        
//    }
//    
//    return _abnormalRespFilter;
//
//}

@end
