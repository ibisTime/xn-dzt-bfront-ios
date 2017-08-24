//
//  TLUserProduct.m
//  CustomB
//
//  Created by  tianlei on 2017/8/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUserProduct.h"
#import "NSNumber+TLAdd.h"

@implementation TLUserProduct

+ (NSDictionary *)mj_objectClassInArray {

    return @{
             
             @"productSpecsList" : [TLUserParameterModel class]
             
             };

}

- (NSString *)getPriceStr {

    return [NSString stringWithFormat:@"%@|%@",self.modelName,[self.price convertToRealMoney]];

}



+ (NSDictionary *)tl_replacedKeyFromPropertyName
{
    return @{ @"description" : @"desc" };
    
}

@end
