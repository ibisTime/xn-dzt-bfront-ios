//
//  TLRefreshEngine.h
//  CustomB
//
//  Created by  tianlei on 2017/8/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLRefreshEngine : NSObject

+ (instancetype)engine;

// 大于0就要刷新
@property (nonatomic, assign) NSInteger refreshTag;

@property (nonatomic, copy) NSString *inMark;
@property (nonatomic, copy) NSString *outMark;

- (BOOL)canRefresh;

//状态还原
- (void)clear;


@end
