//
//  TLOrderInfoCell.h
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLOrderBaseCell.h"

@class TLStatusView;
@interface TLOrderInfoCell : TLOrderBaseCell

@property (nonatomic, strong) TLStatusView *statusView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;


@end
