//
//  UIColor+theme.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "UIColor+theme.h"
#import "UIColor+Extension.h"

@implementation UIColor (theme)




+ (UIColor *)themeColor {

    return [self colorWithHexString:@"#062745"];
}

+ (UIColor *)textColor {

    return [self colorWithHexString:@"#4d4d4d"];
}

+ (UIColor *)textColor2 {

    return [self colorWithHexString:@""];
}

+ (UIColor *)lineColor {
    
    return [self colorWithHexString:@"#9f9f9f"];
    
}

+ (UIColor *)backgroundColor {

    return [self colorWithHexString:@"#fafafa"];
}




@end
