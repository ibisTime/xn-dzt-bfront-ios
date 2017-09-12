//
//  TLGongYiChooseVC.h
//  CustomB
//
//  Created by  tianlei on 2017/8/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "TLOrderModel.h"

@protocol TLGongYiChooseVCDelegate <NSObject>

- (void)didFinishChooseWith:(NSMutableArray *)arr dict:(NSMutableDictionary *)dict gongYiPrice:(float)price  vc:(UIViewController *)vc ;
@end

@interface TLGongYiChooseVC : TLBaseVC

@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, strong) TLOrderModel *order;
@property (nonatomic, assign) id<TLGongYiChooseVCDelegate> delegate;


@end
