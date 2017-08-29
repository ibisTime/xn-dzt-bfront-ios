//
//  TLButtonHeaderView.h
//  CustomB
//
//  Created by  tianlei on 2017/8/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLButtonHeaderView;
@protocol TLButtonHeaderViewDelegate <NSObject>

- (void)didSelected:(TLButtonHeaderView *)btnHeaderView section:(NSInteger)secction;

@end

@interface TLButtonHeaderView : UICollectionReusableView


+ (NSString *)headerReuseIdentifier;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, weak) id<TLButtonHeaderViewDelegate> delegate;

/**
 default is "确定"
 */
@property (nonatomic, copy) NSString *title;

@end
