//
//  TLParameterModel.h
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//
// 主要用于大类小类，小类可选
#import "TLBaseModel.h"

@interface TLParameterModel : TLBaseModel

@property (nonatomic, copy) NSString *type; // 1-3 大类对应很多选型，如大领，小领，宽领
@property (nonatomic, copy) NSString *typeName; // 大类姓名


//预选择， isSelected是确定选择
@property (nonatomic, assign) BOOL yuSelected;

//是否为选中
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name; //小类姓名
@property (nonatomic, copy) NSString *pic; //未选中图片


@property (nonatomic, copy,readonly) NSString *selectPic; //未选中图片
@property (nonatomic, copy) NSString *advPic; //未选中图片
@property (nonatomic, strong) NSNumber *price; //对应的价格

//"code":"GY201708231211313165",
//"type":"1-3",
//"name":"大尖领",
//"pic":"领型袖口矢量图方格图-未选中-07_1503461401855.png",
//"price":0,
//"status":"0",
//"updater":"admin",
//"updateDatetime":"Aug 23, 2017 12:11:31 PM",
//"remark":"",
//"modelCode":"MO201708161448405541",

@end
