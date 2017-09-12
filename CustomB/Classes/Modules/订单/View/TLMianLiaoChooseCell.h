//
//  TLMianLiaoChooseCell.h
//  CustomB
//
//  Created by  tianlei on 2017/9/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLMianLiaoModel;

@interface TLMianLiaoChooseCell : UICollectionViewCell

+ (NSString *)cellReuseIdentifier;
@property (nonatomic, strong) TLMianLiaoModel *mianLiaoModel;

@end
