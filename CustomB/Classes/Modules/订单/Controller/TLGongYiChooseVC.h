//
//  TLGongYiChooseVC.h
//  CustomB
//
//  Created by  tianlei on 2017/8/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "TLOrderModel.h"
#import "TLInnerProduct.h"
@class TLGuiGeXiaoLei;

@protocol TLGongYiChooseVCDelegate <NSObject>

- (void)didFinishChooseWith:(NSMutableArray <TLGuiGeXiaoLei *> *)arr ciXiuDict:(NSDictionary *)ciXiuDict  vc:(UIViewController *)vc;

@end

@interface TLGongYiChooseVC : TLBaseVC

@property (nonatomic, strong) TLInnerProduct *innerProduct;
@property (nonatomic, strong) TLOrderModel *order;
@property (nonatomic, assign) id<TLGongYiChooseVCDelegate> delegate;


@end
