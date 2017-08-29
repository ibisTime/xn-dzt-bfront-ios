//
//  TLMsgCell.h
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLiuYanModel.h"
#import "TLSysMsg.h"

@interface TLMsgCell : UITableViewCell


@property (nonatomic, strong) CustomLiuYanModel *model;
@property (nonatomic, strong) TLSysMsg *sysMsg;

@end
