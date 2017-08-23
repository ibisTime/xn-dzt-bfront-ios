//
//  TLOrderBaseCell.h
//  CustomB
//
//  Created by  tianlei on 2017/8/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLOrderBaseCell : UICollectionViewCell

+ (NSString *)cellReuseIdentifier;

@property (nonatomic, strong) id model;

@end
