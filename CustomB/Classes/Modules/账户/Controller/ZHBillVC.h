//
//  ZHBillVC.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface ZHBillVC : TLBaseVC

@property (nonatomic, assign) BOOL displayHeader;

@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic,copy) NSString *accountNumber;

@end
