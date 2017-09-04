//
//  RespHandler.m
//  CustomB
//
//  Created by  tianlei on 2017/9/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "RespHandler.h"
#import "NBNetwork.h"
#import "TLAlert.h"
#import "TLUser.h"

@interface RespHandler()


@end

@implementation RespHandler

- (void)handleHttpSuccessWithReq:(NBBaseRequest *)req task:(NSURLSessionDataTask *)task resp:(id)responseObject {

    
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
                
               [TLAlert alertWithTitile:nil message:@"为了您的账户安全，请重新登录" confirmAction:^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
                                }];
                                return;
                
            }
            
            [TLAlert alertWithInfo:responseObject[@"errorInfo"]];
            
            
        }
        
        
        return;
    }
    

}

//--网络请求失败的处理对象
- (void)handleHttpFailureWithReq:(NBBaseRequest *)req task:(NSURLSessionDataTask *)task error:(NSError *)error  {

    //
    if (req.failure) {
        
        req.failure(req);
        
    }

}

@end
