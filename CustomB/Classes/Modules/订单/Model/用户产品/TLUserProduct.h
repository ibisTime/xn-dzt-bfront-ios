//
//  TLUserProduct.h
//  CustomB
//
//  Created by  tianlei on 2017/8/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLUserParameterModel.h"

@interface TLUserProduct : TLBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *modelCode;
@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, copy) NSString *modelPic;
@property (nonatomic, copy) NSString *advPic;

@property (nonatomic, strong) NSNumber *price;
//@property (nonatomic, strong) NSMutableArray <TLUserParameterModel *>*productSpecsList;


- (NSString *)getPriceStr;
@end

//"code":"PD201708232132013489",
//"orderCode":"DD201708171511465585",
//"modelCode":"MO201708161448405541",
//"modelName":"花花公子衬衫 短袖",
//"modelPic":"499_1493949069841.jpg",
//"advPic":"2_1502863432270.jpg",
//"description":"<p><img src="http://opf6b9y6y.bkt.clouddn.com/2_1502863443876.jpg" style="max-width:100%"><br></p><p>定制——你的私人专属</p><p><img src="http://opf6b9y6y.bkt.clouddn.com/2_1502863443876.jpg" style="max-width:100%"><br></p><p>定制——你的私人专属</p><p><img src="http://opf6b9y6y.bkt.clouddn.com/2_1502863443876.jpg" style="max-width:100%"><br></p><p>定制——你的私人专属</p><p><img src="http://opf6b9y6y.bkt.clouddn.com/2_1502863443876.jpg" style="max-width:100%"><br></p><p>定制——你的私人专属</p>",
//"processFee":0,
//"price":499000,
//"quantity":1,
//"productSpecsList
