//
//  NBBatchReqest.m
//  HTTP
//
//  Created by  tianlei on 2017/7/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NBBatchReqest.h"
#import "NBBaseRequest.h"
#import "NBNetworkAgent.h"

@implementation NBBatchReqest {

    NSMutableArray <NBBaseRequest *>*_privateReqArray;
    NSInteger _successCount;

}

- (void)dealloc {

    
}

- (instancetype)initWithReqArray:(NSArray  <NBBaseRequest *>*)reqArray {

    if (!reqArray || reqArray.count <= 0 ) {
        
        @throw [NSException exceptionWithName:@"NBBatchReqest 初始化请求对象必须传入有效数组" reason:nil userInfo:nil];
    }
    
    if (self = [super init]) {
        
        _privateReqArray = [[NSMutableArray alloc] initWithArray:reqArray];

    }
    
    return self;

}

- (NSArray<NBBaseRequest *> *)reqArray {

    return _privateReqArray;
    
}



- (void)startWithSuccess:(NBBatchRequestCompletionBlock)success failure:(NBBatchRequestCompletionBlock)failure {
    
    
    self.success = success;
    self.failure = failure;

    //
    NSInteger reqCount = _privateReqArray.count;
    
    [_privateReqArray enumerateObjectsUsingBlock:^(NBBaseRequest * _Nonnull req, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [req clearCompletionBlock];
        
        //
        [req startWithSuccess:^(__kindof NBBaseRequest *request) {
            
            //伪代码实现
            _successCount ++;
            if (_successCount == reqCount) {
                
                if (success) {
                    success(self);
                    [self clearCompletionBlock];
                }
                
            }

            
        } failure:^(__kindof NBBaseRequest *request) {
            
            if (failure) {
                failure(self);
                [self clearCompletionBlock];
            }
            
        }];
        
    }];
    
    
}

- (void)clearCompletionBlock {

    self.success = nil;
    self.failure = nil;
    

}


@end
