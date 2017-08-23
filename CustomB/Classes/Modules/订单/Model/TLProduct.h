//
//  TLProduct.h
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface TLProduct : TLBaseModel

@property (nonatomic, copy) NSString *advPic;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *desc;

//advPic = "2_1502863432270.jpg";
//code = MO201708161448405541;
//createDatetime = "May 26, 2017 9:45:57 AM";
//description = "<p><img src=\"http://opf6b9y6y.bkt.clouddn.com/2_1502863443876.jpg\" style=\"max-width:100%\"><br></p><p>\U5b9a\U5236\U2014\U2014\U4f60\U7684\U79c1\U4eba\U4e13\U5c5e</p><p><img src=\"http://opf6b9y6y.bkt.clouddn.com/2_1502863443876.jpg\" style=\"max-width:100%\"><br></p><p>\U5b9a\U5236\U2014\U2014\U4f60\U7684\U79c1\U4eba\U4e13\U5c5e</p><p><img src=\"http://opf6b9y6y.bkt.clouddn.com/2_1502863443876.jpg\" style=\"max-width:100%\"><br></p><p>\U5b9a\U5236\U2014\U2014\U4f60\U7684\U79c1\U4eba\U4e13\U5c5e</p><p><img src=\"http://opf6b9y6y.bkt.clouddn.com/2_1502863443876.jpg\" style=\"max-width:100%\"><br></p><p>\U5b9a\U5236\U2014\U2014\U4f60\U7684\U79c1\U4eba\U4e13\U5c5e</p>";
//location = 1;
//name = "\U82b1\U82b1\U516c\U5b50\U886c\U886b   \U77ed\U8896";
//orderNo = 2;
//pic = "499_1493949069841.jpg";
//price = 499000;
//processFee = 0;
//remark = "\U4e0b\U67b6";
//status = 1;
//type = 0;
//updateDatetime = "Aug 21, 2017 3:42:01 PM";
//updater = admin;

@end
