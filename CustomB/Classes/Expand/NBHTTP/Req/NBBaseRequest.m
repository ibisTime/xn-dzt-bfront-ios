//
//  NBBaseRequest.m
//  HTTP
//
//  Created by  tianlei on 2017/7/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NBBaseRequest.h"
#import "NBNetworkAgent.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NBBaseRequest

- (instancetype)init {

    if (self = [super init]) {
        
        self.ignoreCache = YES;
        self.isHandleRespByDelegate = YES;

    }
    
    return self;
}

- (void)startWithSuccess:(NBRequestCompletionBlock)success
                 failure:(NBRequestCompletionBlock)failure; {


    [self setSuccess:success failure:failure];
    [self start];
    
}

- (void)setSuccess:(NBRequestCompletionBlock)success failure:(NBRequestCompletionBlock)failure {

    self.success = success;
    self.failure = failure;

}

- (void)start {
    
    if (!self.URLString) {
        
        @throw [NSException exceptionWithName:@"URLString不能为空" reason:nil userInfo:nil];
        
    }
    
    //
    NBNetworkAgent *networkAgent = [NBNetworkAgent defaultAgent];
    [networkAgent startReq:self];
    
}

- (NSMutableDictionary<NSString *,id> *)parameters {

    if (!_parameters) {
        _parameters = [[NSMutableDictionary alloc] init];
        
    }
    
    return _parameters;
}


- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.success = nil;
    self.failure = nil;
}


- (NSDictionary<NSString *,NSString *> *)convertParameters {

    return self.parameters;
    
}


- (void)saveCache {

    if (!self.responseObject) {
        return;
    }
    
    //后台线程保存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        id data = [NSKeyedArchiver archivedDataWithRootObject:self.responseObject];
        
        //保存,应该异步保存
        [[NSFileManager defaultManager] createFileAtPath:[self filePath] contents:data attributes:nil];
    });
  
}


- (id)getCache {

//   id resp = [NSKeyedArchiver  archivedDataWithRootObject:@""];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:[self filePath]];
    if (!data) {
        return nil;
    }
    
    id resp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return resp;
    
}


- (BOOL)checkCache {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:[self filePath]];
    if (!isExists) {
       
        return NO;
    }

    return YES;
    
}

#pragma mark- 生成文件路径，包含名称
- (NSString *)filePath {
    
    NSString *requestInfo = [NSString stringWithFormat:@"HTTPMethod:%ld URL:%@ Argument:%@",self.HTTPMethod,self.URLString,[self convertParameters]];
    NSString *fileName = [self md5StringFromString:requestInfo];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self cacheDirectoryPath],fileName];
    
    return filePath;
    
}

#pragma mark- 缓存文件夹路径
- (NSString *)cacheDirectoryPath {

    NSString *path = [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Documents/NBHTTPCache"];
    //
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    return [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Documents/NBHTTPCache"];
    
}


- (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

@end
