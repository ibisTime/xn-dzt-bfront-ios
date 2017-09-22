//
//  TLGroup.h
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class TLDataModel;

@interface TLGroup : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign,readonly) NSInteger itemCount;
@property (nonatomic, assign) BOOL editting;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, copy) NSString *cellReuseIdentifier;
@property (nonatomic, copy) NSString *headerReuseIdentifier;


//@property (nonatomic, copy) NSString *headerReuseIdentifier;

@property (nonatomic, copy) void(^action)();

@property (nonatomic, assign) CGSize headerSize;


@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign, readonly) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) UIEdgeInsets editingEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets editedEdgeInsets;

@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

//比如地址这些存的是TLDataModel,  有选择的存的是 TLParameterModel
@property (nonatomic, strong) NSMutableArray *dataModelRoom;

- (void)groupSetHidden;
- (void)groupSetShow;

/**
 规格为无的时候颜色隐藏，不需验证, default Yes
 */
@property (nonatomic, assign) BOOL shouldCheckEdit;



/**
 尽量不要使用该字段，（在定价界面，面料和工艺中有使用）
 */
@property (nonatomic, strong) NSString *mark;


/**
 和mark 相同，自己定义规则
 */
@property (nonatomic, strong) id dateModel;


@end
