//
//  TLGuiGeXiaoLei.m
//  CustomB
//
//  Created by  tianlei on 2017/9/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLGuiGeXiaoLei.h"

@implementation TLGuiGeXiaoLei

- (GuiGeXiaoLeiType)xiaoLeiType {

    return [self.isHit isEqualToString:@"1"] ? GuiGeXiaoLeiTypeDefault : GuiGeXiaoLeiTypeNone;

}
- (NSString *)selectedPic {

    return  self.selected ? : nil;
}

@end
