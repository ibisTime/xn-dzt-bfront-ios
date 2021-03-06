//
//  TLPriceHeaderView.h
//  CustomB
//
//  Created by  tianlei on 2017/8/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLInnerProduct;
@class TLPriceHeaderView;

@protocol TLPriceHeaderViewDelegate <NSObject>

- (void)didSelected:(NSInteger)section priceHeaderView:(TLPriceHeaderView *)priceHeaderView;

@end

@class TLGroup;
@interface TLPriceHeaderView : UICollectionReusableView

+ (NSString *)headerReuseIdentifier;

@property (nonatomic, assign) id<TLPriceHeaderViewDelegate> delegate;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) TLGroup *group;
//@property (nonatomic, strong) TLInnerProduct *innerProduct;

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end
