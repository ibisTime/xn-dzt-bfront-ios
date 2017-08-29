//
//  TLCalculatePriceManager.m
//  CustomB
//
//  Created by  tianlei on 2017/8/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLCalculatePriceManager.h"

@implementation TLCalculatePriceManager


/**
 
 */
- (float)calculate {

    float price = 1.76*(self.mianLiaoPrice*self.mianLiaoCount + self.jiaGongPrice + self.gongYiPrice) + 2.06*(self.kuaiDiPrice + self.baoZhuangPrice);
    return  price*self.times;
    
}


@end
