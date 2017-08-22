//
//  TLGroup.h
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TLGroup : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) BOOL editting;
@property (nonatomic, copy) NSString *cellReuseIdentifier;
@property (nonatomic, copy) NSString *headerReuseIdentifier;


//@property (nonatomic, copy) NSString *headerReuseIdentifier;

@property (nonatomic, copy) void(^action)();

@property (nonatomic, assign) CGSize headerSize;


@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;





@end
