//
//  TLInputDataModel.h
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLInputDataModel : NSObject

- (instancetype)init;

@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic, copy) NSString *keyName;
@property (nonatomic, copy) NSString *keyCode; //1-4
@property (nonatomic, copy) NSString *value;

@end
