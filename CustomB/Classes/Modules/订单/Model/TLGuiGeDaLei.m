//
//  TLGuiGeDaLei.m
//  CustomB
//
//  Created by  tianlei on 2017/9/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLGuiGeDaLei.h"

@implementation TLGuiGeDaLei

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"craftList" : [TLGuiGeXiaoLei class],
             @"colorPcList" : [TLColorDaLei class]
             };
    
}

- (GuiGeDaLeiType)guiGeLeiBie {

//0 工艺 2着装风格    1刺绣， 3刺绣内容 4刺绣颜色
    
    if ([self.kind isEqualToString:@"0"]) {
        
        return GuiGeDaLeiTypeDefaultGongYi;
    
    } else if ([self.kind isEqualToString:@"1"]) {
    
        return GuiGeDaLeiTypeCiXiuOther;
        
    } else if ([self.kind isEqualToString:@"3"]) {
        
        return GuiGeDaLeiTypeCiXiuText;
        
    } else if([self.kind isEqualToString:@"4"])  {
        
        return GuiGeDaLeiTypeCiXiuColor;

    } else {
    
        return GuiGeDaLeiTypeZhuoZhuangFengGe;

    }

}

- (BOOL)isHaveColorMark {

    return self.colorPcList && self.colorPcList.count > 0;

}

- (void)setProductCategory:(NSDictionary *)productCategory {

    _productCategory = productCategory;
    self.colorDaLei = [TLGuiGeDaLei tl_objectWithDictionary:_productCategory];
    
}

@end
