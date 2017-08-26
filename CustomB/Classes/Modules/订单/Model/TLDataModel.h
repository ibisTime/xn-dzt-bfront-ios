//
//  TLDataModel.h
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//  针对只做展示得信息，不做输入和选择

#import <Foundation/Foundation.h>

@interface TLDataModel : NSObject

@property (nonatomic, copy) NSString *keyName;
@property (nonatomic, copy) NSString *keyCode;
@property (nonatomic, copy) NSString *value;

//该model 是非为状态
@property (nonatomic, assign) BOOL isStatus;

@end
