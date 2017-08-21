//
//  ZHSettingUpCell.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLSettingModel.h"

@interface TLSettingCell : UITableViewCell

+ (CGFloat)defaultCellHeight;
@property (nonatomic, strong) TLSettingModel *model;

@end
