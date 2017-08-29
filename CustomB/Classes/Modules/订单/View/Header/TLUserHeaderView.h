//
//  TLUserHeaderView.h
//  CustomB
//
//  Created by  tianlei on 2017/8/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLUserHeaderView : UICollectionReusableView

+ (NSString *)headerReuseIdentifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UILabel *contentLbl;
@end
