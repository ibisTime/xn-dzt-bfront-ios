//
//  CustomBankCardCell.h
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHBankCard.h"

@interface CustomBankCardCell : UITableViewCell

@property (nonatomic, strong) ZHBankCard *bankCard;

@property (nonatomic, strong) UILabel *bankNameLbl;
@property (nonatomic, strong) UILabel *markLbl;
@property (nonatomic, strong) UILabel *bankCardNumLbl;

@end
