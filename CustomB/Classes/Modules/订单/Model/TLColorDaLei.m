//
//  TLColorDaLei.m
//  CustomB
//
//  Created by  tianlei on 2017/9/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLColorDaLei.h"

@implementation TLColorDaLei

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"colorCraftList" : [TLGuiGeXiaoLei class]};
    
}

- (NSString *)name {

    return self.dvalue;
}

@end
