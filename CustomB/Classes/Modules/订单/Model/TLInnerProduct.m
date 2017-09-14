//
//  TLInnerProduct.m
//  CustomB
//
//  Created by  tianlei on 2017/9/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLInnerProduct.h"
#import "TLMianLiaoModel.h"
#import "NSNumber+TLAdd.h"
#import "TLGuiGeXiaoLei.h"

@implementation TLInnerProduct

- (NSMutableArray<TLGuiGeXiaoLei *> *)guiGeXiaoLeiRoom {

    if (!_guiGeXiaoLeiRoom) {
        
        _guiGeXiaoLeiRoom = [[NSMutableArray alloc] init];
    }
    
    return _guiGeXiaoLeiRoom;
    
}

- (float)calculateGongYiPrice {

    if (self.guiGeXiaoLeiRoom.count <= 0) {
        return 0;
    }
    
    __block long long gongYiPrice = 0;
    [self.guiGeXiaoLeiRoom enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        gongYiPrice += [obj.price longLongValue];
        
        
    }];
    
    return [[@(gongYiPrice) convertToRealMoney] floatValue];

}

- (float)calculateMianLiaoPrice {

    if (!self.mianLiaoModel) {
        return 0;
    }
    //
    return [[self.mianLiaoModel.price convertToRealMoney] floatValue];

}

- (float)calculateTotalPrice {

    return [self calculateMianLiaoPrice] + [self calculateGongYiPrice];
    

}

@end
