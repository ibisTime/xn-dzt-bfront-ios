//
//  AppConfig.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppConfig.h"


void TLLog(NSString *format, ...) {
    
    if ([AppConfig config].runEnv != RunEnvRelease) {
        
        va_list argptr;
        va_start(argptr, format);
        NSLogv(format, argptr);
        va_end(argptr);
    }
    
}

@implementation AppConfig

+ (instancetype)config {

    static dispatch_once_t onceToken;
    static AppConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[AppConfig alloc] init];
        
    });

    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {

    _runEnv = runEnv;
    switch (_runEnv) {
            
        case RunEnvRelease: {
        
           self.qiniuDomain = @"http://omxvtiss6.bkt.clouddn.com";
            
           self.addr = @"http://139.224.200.54:5601"; //test

        }break;
            
        case RunEnvTest: {
            
            self.qiniuDomain = @"http://opf6b9y6y.bkt.clouddn.com";
            self.addr = @"http://118.178.124.16:3301";
            
        } break;
            
            
        case RunEnvDev: {
            
            self.qiniuDomain = @"http://opf6b9y6y.bkt.clouddn.com";
            self.addr = @"http://121.43.101.148:8901";

        } break;
   

    }
    
}

- (NSString *)kind {

    return @"B";
}

- (NSString *)systemCode {

    return @"CD-CDZT000009";
}

- (NSString *)pushKey {

    return @"552c967a30325e9374a6ea2a";
    
}


- (NSString *)aliMapKey {

    return @"1e8db922ea81c423b5f5f9f6471bc599";
}


- (NSString *)wxKey {

    return @"wx9324d86fb16e8af0";
//    return @"wx1c40c1c60500a270";
}

@end
