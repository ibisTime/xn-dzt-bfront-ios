//
//  TLOrderCollectionViewHeader.h
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLGroup.h"


@class TLOrderCollectionViewHeader;

typedef NS_ENUM(NSUInteger, EditType) {
    
    EditTypeGoEdit,
    EditTypeCancle,
    EditTypeConfirm
    
};

@protocol TLOrderEditHeaderDelegate <NSObject>

- (void)actionWithView:(TLOrderCollectionViewHeader *)reusableView type:(EditType)type;

@end

@interface TLOrderCollectionViewHeader : UICollectionReusableView

@property (nonatomic, strong) TLGroup *group;

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;


+ (NSString *)headerReuseIdentifier;

@property (nonatomic, weak) id<TLOrderEditHeaderDelegate> delegate;

//当前所处的分组
@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancleBtn;

- (void)editing;
- (void)edited;

@end
