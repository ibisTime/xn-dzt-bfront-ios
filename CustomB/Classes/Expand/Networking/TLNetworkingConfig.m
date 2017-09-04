//
//  TLNetworkingConfig.m
//  CustomB
//
//  Created by  tianlei on 2017/9/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLNetworkingConfig.h"

@implementation TLNetworkingConfig

+ (instancetype)config {

    static TLNetworkingConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        config = [[TLNetworkingConfig alloc] init];
        
    });
    
    return config;

}


@end
