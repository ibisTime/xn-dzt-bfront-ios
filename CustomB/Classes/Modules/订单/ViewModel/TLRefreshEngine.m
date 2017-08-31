//
//  TLRefreshEngine.m
//  CustomB
//
//  Created by  tianlei on 2017/8/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLRefreshEngine.h"

@implementation TLRefreshEngine

+ (instancetype)engine {

    static TLRefreshEngine *engine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        engine = [[TLRefreshEngine alloc] init];
        engine.refreshTag = 0;
    });
    
    return engine;
    

}

- (BOOL)canRefresh {
    
    BOOL con1 = self.inMark && self.outMark;
    BOOL con2 = [self.inMark isEqual:self.outMark];
    BOOL con3 = self.refreshTag > 0;
    return con1 && con2 && con3;

}

- (void)clear {

    self.refreshTag = 0;
    self.inMark = nil;
    self.outMark = nil;

}


@end
