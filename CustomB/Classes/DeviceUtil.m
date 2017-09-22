//
//  DeviceUtil.m
//  CustomB
//
//  Created by  tianlei on 2017/9/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "DeviceUtil.h"

@implementation DeviceUtil

+ (CGFloat)top64 {
    
    if ([self isPhoneX]) {
        
        return 88;
        
    } else {
        
        return 64;
    }
    
}

+ (BOOL)isPhoneX {
    
    return [UIScreen mainScreen].bounds.size.height == 812;
}

+ (CGFloat)bottom49 {
    
    if ([self isPhoneX]) {
        
        return 49 + 34;
        
    } else {
        
        return 49;
    }
    
}

@end
