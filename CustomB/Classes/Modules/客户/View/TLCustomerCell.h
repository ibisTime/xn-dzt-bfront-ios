//
//  TLCustomerCell.h
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLCustomer;

@interface TLCustomerCell : UITableViewCell

+ (CGFloat)defaultCellHeight;

@property (nonatomic, strong) TLCustomer *customer;

@end
