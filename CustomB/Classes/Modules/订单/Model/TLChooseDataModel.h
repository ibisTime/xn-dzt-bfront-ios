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

@property (nonatomic, assign) BOOL canEdit;


@property (nonatomic, copy) NSString *type;      //type 对应的  eg:4-02
@property (nonatomic, copy) NSString *typeName;  //type对应的名称

@property (nonatomic, copy) NSString *typeValue; //eg:4-02 对应b B
@property (nonatomic, copy) NSString *typeValueName; //如B长脖子

//
@property (nonatomic, strong) NSMutableArray <TLParameterModel *>*parameterModelRoom;

@end
