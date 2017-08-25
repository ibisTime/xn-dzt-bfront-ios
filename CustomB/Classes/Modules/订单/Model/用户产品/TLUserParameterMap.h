//
//  TLUserParameterMap.h
//  CustomB
//
//  Created by  tianlei on 2017/8/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface TLUserParameterMap : TLBaseModel
//
//"CIXIU":Object{...},
//"CELIANG":Object{...},
//"DINZHI":Object{...},
//"TIXIN":Object{...}

@property (nonatomic, strong) NSDictionary *CIXIU; //刺绣
@property (nonatomic, strong) NSDictionary *CELIANG; //测量
@property (nonatomic, strong) NSDictionary *DINGZHI; //定制
@property (nonatomic, strong) NSDictionary *TIXIN; //
@property (nonatomic, strong) NSDictionary *QITA; //


@end
