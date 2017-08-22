//
//  TLOrderCell.h
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLOrderModel.h"

@interface TLOrderCell : UITableViewCell

@property (nonatomic, strong) TLOrderModel *order;
+ (CGFloat)defaultCellHeight;

@end
