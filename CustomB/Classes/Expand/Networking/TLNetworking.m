//
//  TLNetworking.m
//  WeRide
//
//  Created by  tianlei on 2016/11/28.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLNetworking.h"
#import "TLProgressHUD.h"
#import "TLAlert.h"
#import "TLUser.h"
#import "TLNetworkingConfig.h"
#import "NBNetwork.h"

@implementation TLNetworking


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


//+ (NSString *)serveUrl {
//    
//    return [TLNetworkingConfig config].baseUrl;
////    return [[self baseUrl] stringByAppendingString:@"/forward-service/api"];
//}



//+ (NSString *)baseUrl {
//
//    return [AppConfig config].addr;
//    
//}


//
//+ (NSString *)systemCode {
//    
//    return [TLNetworkingConfig config].systemCode;
////    return [AppConfig config].systemCode;
//}


//
//+ (NSString *)kindType {
//    
//    return [TLNetworkingConfig config].kind;
//    
//}

- (instancetype)init{

    if(self = [super init]){
    
       _manager = [[self class] HTTPSessionManager];
        _isShowMsg = YES;
        _isDeliverCompanyCode = YES;
        self.parameters = [NSMutableDictionary dictionary];
        
    }
    return self;

}

//- (void)post2WithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure {
//
//    if(self.showView){
//        
//        [TLProgressHUD show];
//    }
//    
//    if(self.code && self.code.length > 0){
//        
//        if (!(self.url && self.url.length > 0)) {
//            
//            self.url = [TLNetworkingConfig config].baseUrl;
//        }
//        
//        self.parameters[@"systemCode"] = [TLNetworkingConfig config].systemCode;
//        
//#warning -- 公司编码，祸害
//        if (self.isDeliverCompanyCode) {
//            
//            self.parameters[@"companyCode"] = [TLNetworkingConfig config].systemCode;
//            
//        }
//        
//        NSString *kind =  self.parameters[@"kind"];
//        if (!kind || kind.length <=0 ) {
//            self.parameters[@"kind"] = [TLNetworkingConfig config].kind;
//            
//        }
//
//        
//    }
//    
//    if (!self.url || !self.url.length) {
//        NSLog(@"url 不存在啊");
//        if (self.showView) {
//            
//            [TLProgressHUD dismiss];
//        }
//        return ;
//    }
//    
//    //把原来的替换掉
//    NBCDRequest *cdReq = [[NBCDRequest alloc] init];
//    cdReq.code = self.code;
//    cdReq.parameters = self.parameters;
//    [cdReq startWithSuccess:^(__kindof NBBaseRequest *request) {
//        
//        //确保 dismiss掉， NBCDRequest 暂时未添加进度指示功能
//        if(self.showView){
//            
//            [TLProgressHUD dismiss];
//            
//        }
//        
//        if (success) {
//            success(request.responseObject);
//        }
//        
//        
//    } failure:^(__kindof NBBaseRequest *request) {
//        
//        if(self.showView){
//            [TLProgressHUD dismiss];
//        }
//        
//        if (self.isShowMsg) {
//            
//            [TLProgressHUD showErrorWithStatus:@"网络异常"];
//            [TLProgressHUD dismissWithDelay:3];
//            
//        }
//        
//        if (failure) {
//            failure(request.error);
//        }
//        
//    }];
//
//}


- (NSURLSessionDataTask *)postWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //如果想要设置其它 请求头信息 直接设置 HTTPSessionManager 的 requestSerializer 就可以了，不用直接设置 NSURLRequest
        
    if(self.showView){
    
        [TLProgressHUD show];
    }
    
    if(self.code && self.code.length > 0){
    
        if (!(self.url && self.url.length > 0)) {
            
            self.url = [TLNetworkingConfig config].baseUrl;
        }
        
        self.parameters[@"systemCode"] = [TLNetworkingConfig config].systemCode;
     
#warning -- 公司编码，祸害
        if (self.isDeliverCompanyCode) {
            
            self.parameters[@"companyCode"] = [TLNetworkingConfig config].systemCode;

        }
        
        NSString *kind =  self.parameters[@"kind"];
        if (!kind || kind.length <=0 ) {
            self.parameters[@"kind"] = [TLNetworkingConfig config].kind;

        }
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.parameters options:NSJSONWritingPrettyPrinted error:nil];
        self.parameters = [NSMutableDictionary dictionaryWithCapacity:2];
        self.parameters[@"code"] = self.code;
        self.parameters[@"json"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    
    if (!self.url || !self.url.length) {
        NSLog(@"url 不存在啊");
        if (self.showView) {
            
            [TLProgressHUD dismiss];
        }
        return nil;
    }
    
  //
  return [self.manager POST:self.url parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

      if(self.showView){
          
          [TLProgressHUD dismiss];
          
      }
      
      if([responseObject[@"errorCode"] isEqual:@"0"]){ //成功
          
          if(success){
              success(responseObject);
          }
          
      } else {
          
          if ([responseObject[@"errorBizCode"] isEqualToString:@"M000001"]) {
              
              if (success) {
                  success(responseObject);
              }
              
              return ;
          }
          
          if (failure) {
              failure(nil);
          }
          
          if ([responseObject[@"errorCode"] isEqual:@"4"]) {
              //token错误  4
              
              [TLAlert alertWithTitile:nil message:@"为了您的账户安全，请重新登录" confirmAction:^{
                  [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
              }];
              return;
              
          }
          
          if(self.isShowMsg) { //异常也是失败
              [TLAlert alertWithInfo:responseObject[@"errorInfo"]];

          }
      
      }
      
 
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       if(self.showView){
           [TLProgressHUD dismiss];
       }
       
       if (self.isShowMsg) {

           [TLProgressHUD showErrorWithStatus:@"网络异常"];
           [TLProgressHUD dismissWithDelay:3];

       }
       
       if(failure){
           failure(error);
       }
       
       if (error.code == -1009) { //网路断开连接
           
           
       }
       
   }];
   
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id responseObject))success
                       failure: (void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    
    return [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(failure){
            
            failure(error);
            
        }
        
    }];


}


//+ (NSURLSessionDataTask *)POST:(NSString *)URLString
//                       parameters:(NSDictionary *)parameters
//                          success:(void (^)(id responseObject))success
//                      abnormality:(void (^)(NSString *msg))abnormality
//                          failure:(void (^)(NSError * _Nullable  error))failure {
//    //先检查网络
//    
//    AFHTTPSessionManager *manager = [self HTTPSessionManager];
//    
//    return [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//       
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        if(failure){
//            failure(error);
//        }
//        
//    }];
//    
//}


//#pragma mark - GET
//+ (NSURLSessionDataTask *)GET:(NSString *)URLString
//                      parameters:(NSDictionary *)parameters
//                         success:(void (^)(NSString *msg,id data))success
//                     abnormality:(void (^)())abnormality
//                         failure:(void (^)(NSError *error))failure;
//{
//    AFHTTPSessionManager *manager = [self HTTPSessionManager];
//    
//    return [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        if (success) {
//            success(@"",responseObject);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        if (failure) {
//            failure(error);
//        }
//        
//    }];
//    
//}



@end
