//
//  TLSwitchHeaderView.h
//  CustomB
//
//  Created by  tianlei on 2017/9/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLGroup.h"

@class TLSwitchHeaderView;

@protocol TLSwitchHeaderViewDelegate <NSObject>

- (void)didSwitchWith:(TLSwitchHeaderView *)switchHeaderView selectedIdx:(NSInteger)idx;

@end

@interface TLSwitchHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<TLSwitchHeaderViewDelegate> delegate;

+ (NSString *)headerReuseIdentifier;
@property (nonatomic, strong) TLGroup *group;

@end

