//
//  NBBatchReqest.h
//  HTTP
//
//  Created by  tianlei on 2017/7/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBBaseRequest;
@class NBBatchReqest;


typedef void(^NBBatchRequestCompletionBlock)( NBBatchReqest *batchRequest);


@interface NBBatchReqest : NSObject

- (instancetype)initWithReqArray:(NSArray <NBBaseRequest *>*)reqArray;

@property (nonatomic, copy, readonly) NSArray <NBBaseRequest *> *reqArray;

/**
 成功回调
 */
@property (nonatomic, copy) NBBatchRequestCompletionBlock success;

/**
 失败回调
 */
@property (nonatomic, copy) NBBatchRequestCompletionBlock failure;



- (void)startWithSuccess:(NBBatchRequestCompletionBlock)success
                 failure:(NBBatchRequestCompletionBlock)failure;

- (void)clearCompletionBlock;

@end
