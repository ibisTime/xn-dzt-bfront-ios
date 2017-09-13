//
//  TLProduct.h
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//  标准产品SPU

#import "TLBaseModel.h"
#import "TLInnerProduct.h"

typedef NS_ENUM(NSUInteger, TLProductType) {
    
    TLProductTypeChenShan,
    TLProductTypeHAdd

    
};

@interface TLProduct : TLBaseModel

@property (nonatomic, copy) NSString *advPic;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign, readonly) TLProductType productType;
@property (nonatomic, assign) NSNumber *processFee; //加工费
@property (nonatomic, strong) NSNumber *loss; //面料消耗


/**
 本类是  3件套：1.西服 2.裤子 3.衬衫                         衬衫：1.只有衬衫
 */
@property (nonatomic, strong) NSArray <TLInnerProduct *> *modelSpecsList;


@end
