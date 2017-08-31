//
//  TLDataModel.m
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLDataModel.h"

@implementation TLDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isStatus = NO;
    }
    return self;
}

//
- (CGSize)itemSize {

    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [self contentFrame].size.height + 10);

}

- ( CGRect )contentFrame {

    if (!self.value) {
        return CGRectZero;
    }
    CGSize stringSize;
    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:12],
                           };
    stringSize = [self.value boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 98 - 16 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
   
    stringSize.height =  stringSize.height  > 20 ?  stringSize.height + 5 : 20;
    return CGRectMake(114, 10, ceilf(stringSize.width) ,ceilf(stringSize.height));
    
   
}

@end
