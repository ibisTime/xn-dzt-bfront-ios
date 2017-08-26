//
//  ZHChangeMobileVC.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface ZHChangeMobileVC : TLBaseVC


@property (nonatomic,copy) void(^changeMobileSuccess)(NSString *mobile);

@end
