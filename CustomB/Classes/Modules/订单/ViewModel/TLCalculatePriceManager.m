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
    
    float price1 = 2.06*(self.kuaiDiPrice + self.baoZhuangPrice);
    float price2 = 1.76*(self.mianLiaoPrice*self.mianLiaoCount + self.jiaGongPrice + self.gongYiPrice);
 
    float price =  price1 + price2;
    return  price*self.times;
    
}


@end
