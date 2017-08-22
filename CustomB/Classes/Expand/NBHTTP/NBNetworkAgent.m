//
//  NBNetworkAgent.m
//  HTTP
//
//  Created by  tianlei on 2017/7/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NBNetworkAgent.h"
#import "TLAlert.h"

//#if __has_include(<AFNetworking/AFNetworking.h>)
//#import <AFNetworking/AFNetworking.h>
//#else
//#import "AFNetworking.h"
//#endif

#import <AFNetworking/AFNetworking.h>
#import "NBNetworkConfig.h"
//#import "NBRespFilter.h"
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
            
            if ([req.URLString hasPrefix:@"http"] || [req.URLString hasPrefix:@"http"]) {
                
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
    
    //请求
    switch (req.HTTPMethod) {
        
        case NBRequestMethodPOST: {
        
//            [manager POSt];
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

        
        default: {
        
            @throw [NSException exceptionWithName:@"不支持的请求方法" reason:nil userInfo:nil];
            
        }  break;
           
    }
    
 
}


- (void)handleSuccessWithReq:(NBBaseRequest *)req task:(NSURLSessionDataTask *)task responseObject:(id)responseObject {
    
    req.responseObject = responseObject;
    req.task = task;
    req.error = nil;
    
  
    
    //0.是否满则全局单一成功过滤,满足
    if ([req isKindOfClass:[NBCDRequest class]]) {
        //我方请求
  
        if([responseObject[@"errorCode"] isEqual:@"0"]){ //成功
            
            if(req.success){
                req.success(req);
            }
            
        } else {
            
         
            
            if (req.failure) {
                req.failure(req);
            }
            
            if ([responseObject[@"errorCode"] isEqual:@"4"]) {
                //token错误  4
                
//                [TLAlert alertWithTitile:nil message:@"为了您的账户安全，请重新登录" confirmAction:^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
//                }];
//                return;
                
            }
            
                [TLAlert alertWithInfo:responseObject[@"errorInfo"]];
                
            
        }
        
        
        return;
    }
    
    if (!req.ignoreCache) {
        
        [req saveCache];
        
    }
    
    
    if (req.success) {
        
        req.success(req);
        [req clearCompletionBlock];

    }

}


- (void)handleFailureWithReq:(NBBaseRequest *)req task:(NSURLSessionDataTask *)task error:(NSError *)error {
    
    req.responseObject = nil;
    req.task = task;
    req.error = error;
    
    if (req.failure) {
        
        req.failure(req);
        
    }
    
    //
    [req clearCompletionBlock];

}


@end
