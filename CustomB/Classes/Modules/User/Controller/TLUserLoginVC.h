//
//  ZHUserLoginVC.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHAccountBaseVC.h"

@interface TLUserLoginVC : ZHAccountBaseVC

@property (nonatomic,copy) void(^loginSuccess)();

@end
