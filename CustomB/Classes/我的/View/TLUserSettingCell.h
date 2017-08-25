//
//  TLUserSettingCell.h
//  CustomB
//
//  Created by  tianlei on 2017/8/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLSettingModel.h"

typedef NS_ENUM(NSUInteger, TLUserSettingCellType) {
    TLUserSettingCellTypeDefault,
    TLUserSettingCellTypePhoto
    
};

@interface TLUserSettingCell : UITableViewCell

@property (nonatomic, strong) TLSettingModel *model;

@property (nonatomic, assign) TLUserSettingCellType type;

+ (CGFloat)defaultCellHeight;

@end
