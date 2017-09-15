//
//  TLUserProductXiaoJian.m
//  CustomB
//
//  Created by  tianlei on 2017/9/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUserProductXiaoJian.h"

@implementation TLUserProductXiaoJian

- (void)setProductSpecs:(NSArray *)productSpecs {

    _productSpecs = [productSpecs copy];
    if (!_productSpecs || _productSpecs.count <= 0) {
        return;
    }
    
    self.mianLiaoModel = [TLMianLiaoModel tl_objectWithDictionary:_productSpecs[0]];

}


- (void)setProductCategory:(NSArray *)productCategory {

    _productCategory = [productCategory copy];
    self.guiGeDaLeiRoom = [TLGuiGeDaLei tl_objectArrayWithDictionaryArray:_productCategory];

}



@end
