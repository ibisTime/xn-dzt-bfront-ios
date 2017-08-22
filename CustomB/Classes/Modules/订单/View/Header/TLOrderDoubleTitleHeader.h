//
//  TLOrderDoubleTitleHeader.h
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLOrderDoubleTitleHeader : UICollectionReusableView


@property (nonatomic, copy) NSString *title;

+ (NSString *)headerReuseIdentifier;

@end
