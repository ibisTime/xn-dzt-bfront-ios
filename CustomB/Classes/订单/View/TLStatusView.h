//
//  TLStatusView.h
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TLStatusViewType) {
    TLStatusViewTypeYellow,
    TLStatusViewTypeTheme
};

@interface TLStatusView : UIView

@property (nonatomic, strong) UILabel *contentLbl;
- (instancetype)init;

@property (nonatomic, assign) TLStatusViewType type;

@end
