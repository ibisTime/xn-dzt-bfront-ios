//
//  TLChooseDataModel.h
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//  只用于形体信息

#import <Foundation/Foundation.h>
#import "TLParameterModel.h"

@interface TLChooseDataModel : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *typeValue;

//
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*parameterModelRoom;

@end
