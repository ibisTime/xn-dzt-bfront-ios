//
//  NBNetworkAgent.m
//  HTTP
//
//  Created by  tianlei on 2017/7/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NBNetworkAgent.h"
#import <AFNetworking/AFNetworking.h>
#import "NBNetworkConfig.h"
#import "NBBaseRequest.h"
#import "NBCDRequest.h"

@implementation NBNetworkAgent


+ (instancetype)defaultAgent {

    static NBNetworkAgent *agent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        agent = [[NBNetworkAgent alloc] init];
    });
    
    return agent;
}

+ (AFHTTPSessionManager *)HTTPSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer.timeoutInterval = 30.0;
    NSSet *set = manager.responseSerializer.acceptableContentTypes;
    
    set = [set setByAddingObject:@"text/plain"];
    set = [set setByAddingObject:@"text/html"];
    set = [set setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    manager.responseSerializer.acceptableContentTypes = [set setByAddingObject:@"text/plain"];
    
    return manager;
}

- (void)startReq:(__kindof NBBaseRequest *)req {

    AFHTTPSessionManager *manager = [NBNetworkAgent HTTPSessionManager];
//    id manager = nil;
    //转换URLString
    NSString *URLString = nil;
    id parameters = req.parameters;
    
    if ([req isKindOfClass:[NBCDRequest class]]) {
        
        URLString = [NBNetworkConfig config].baseUrl;
        
    } else {
    
        if ([NBNetworkConfig config].baseUrl) {
            
            if ([req.URLString hasPrefix:@"http"] || [req.URLString hasPrefix:@"https"]) {
                
                URLString = req.URLString;
                
            } else {
                
                URLString = [[NBNetworkConfig config].baseUrl stringByAppendingString:req.URLString];
                
            }
            
        } else {
            
            URLString = req.URLString;
            
        }
    
    }
    
    //转换parameters
    if ([req respondsToSelector:@selector(convertParameters)]) {
        
        parameters = [req convertParameters];

    } else {
    
        @throw [NSException exceptionWithName:@"请实现 convertParameters 方法" reason:nil userInfo:nil];
    
    }
//    NSLog(@"%@\n%@",URLString,parameters);
    //请求
    
    //此处请求开始的回调
    switch (req.HTTPMethod) {
        
        case NBRequestMethodPOST: {
        
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleSuccessWithReq:req task:task responseObject:responseObject];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self handleFailureWithReq:req task:task error:error];


            }];
           
        }  break;
        
            
        case NBRequestMethodGET: {
            
            [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleSuccessWithReq:req task:task responseObject:responseObject];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self handleFailureWithReq:req task:task error:error];
                
                
            }];
          
        }  break;

        //
        default: {
        
            @throw [NSException exceptionWithName:@"不支持的请求方法" reason:nil userInfo:nil];
            
        }  break;
           
    }
    
}


- (void)handleSuccessWithReq:(NBBaseRequest *)req task:(NSURLSessionDataTask *)task responseObject:(id)responseObject {
    
    req.responseObject = responseObject;
    req.task = task;
    req.error = nil;
    
    //请求结束的回调
    
    if (req.isHandleRespByDelegate) {
       
        //实现了代理让代理，去处理返回对象
        if ([NBNetworkConfig config].respDelegate && [[NBNetworkConfig config].respDelegate respondsToSelector:@selector(handleHttpSuccessWithReq:task:resp:)]) {
            
            [[NBNetworkConfig config].respDelegate handleHttpSuccessWithReq:req task:task resp:responseObject];
            
        } else {
            
            @throw [NSException exceptionWithName:@"[NBNetworkConfig config].respDelegate 未发现代理" reason:@"[NBNetworkConfig config].respDelegate 为配置代理对象" userInfo:nil];
        
        }
        
    } else {
    
       //无过滤，直接处理
       if (req.success) {
        
          req.success(req);
        
       }
        
    }
    
    if (!req.ignoreCache) {
        
        [req saveCache];
        
    }
    
    [req clearCompletionBlock];

}


- (void)handleFailureWithReq:(NBBaseRequest *)req task:(NSURLSessionDataTask *)task error:(NSError *)error {
    
    req.responseObject = nil;
    req.task = task;
    req.error = error;
    
    //此处应先隐藏掉 进度指示，然后 进行alert 提示。SVProgressHUD dismiss 会把所有的dimiss掉
    
    if (req.isHandleRespByDelegate) {
        
        //实现了代理让代理，去处理返回对象
        if ([NBNetworkConfig config].respDelegate && [[NBNetworkConfig config].respDelegate respondsToSelector:@selector(handleHttpFailureWithReq:task:error:)]) {
            
            [[NBNetworkConfig config].respDelegate handleHttpFailureWithReq:req task:task error:error];
            
        } else {
        
            @throw [NSException exceptionWithName:@"[NBNetworkConfig config].respDelegate 未发现代理" reason:@"[NBNetworkConfig config].respDelegate 未配置代理对象" userInfo:nil];
            
        }
        
    } else {
    
        if (req.failure) {
            
            req.failure(req);
            
        }
        
    }

    //
    [req clearCompletionBlock];

}


@end
