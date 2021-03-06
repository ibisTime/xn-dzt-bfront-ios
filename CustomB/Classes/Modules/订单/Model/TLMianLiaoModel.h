//
//  TLMianLiaoModel.h
//  CustomB
//
//  Created by  tianlei on 2017/9/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface TLMianLiaoModel : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *advPic;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *modelNum;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy) NSString *yarn;

/**
 所属产品编号
 */
@property (nonatomic, copy) NSString *modelSpecsCode;

/**
 所属大类产品编号
 */
@property (nonatomic, copy) NSString *modelCode;


@property (nonatomic, assign) BOOL isSelected;

//advPic = "YDP-PC20220_1493951308202.jpg";
//brand = "\U82b1\U82b1\U516c\U5b50";
//code = BL00008;
//color = 4;
//flowers = 2;
//form = 2;
//location = 1;
//modelCode = MO201708161448405541;
//modelNum = "YDP-PC20220";
//orderNo = 2;
//pic = "YDP-PC20220_1493951308202.jpg";
//price = 0;
//status = 1;
//type = 2;
//updateDatetime = "Sep 11, 2017 11:12:27 AM";
//updater = admin;
//weight = 0;
//yarn = 1;

@end
