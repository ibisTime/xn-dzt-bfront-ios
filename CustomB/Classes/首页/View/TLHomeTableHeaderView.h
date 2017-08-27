//
//  TLHomeTableHeaderView.h
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLHomeTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, copy) void(^action)(NSInteger section);



@end
