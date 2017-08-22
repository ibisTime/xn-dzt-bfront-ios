//
//  TLOrderBGTitleHeader.h
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLOrderBGTitleHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLbl;

+ (NSString *)headerReuseIdentifier;

@end
