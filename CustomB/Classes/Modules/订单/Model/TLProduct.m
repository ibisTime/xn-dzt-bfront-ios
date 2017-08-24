//
//  TLProduct.m
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLProduct.h"

@implementation TLProduct


+ (NSDictionary *)tl_replacedKeyFromPropertyName
{
    return @{ @"description" : @"desc" };
    
}

- (TLProductType)productType {

    if ([self.type isEqualToString:@"0"]) {
    
        return TLProductTypeChenShan;
        
    } else if([self.type isEqualToString:@"1"]) {
    
        return TLProductTypeHAdd;

    }
    
    return TLProductTypeChenShan;
}

@end
