//
//  TLMianLiaoChooseVC.h
//  CustomB
//
//  Created by  tianlei on 2017/9/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//  面料选择的_VC_

#import "TLBaseVC.h"
@class TLMianLiaoModel;

@protocol TLMianLiaoChooseVCDelegate <NSObject>

- (void)didFinishChooseWithMianLiaoModel:(TLMianLiaoModel *)mianLiaoModel vc:(UIViewController *)vc;

@end

@interface TLMianLiaoChooseVC : TLBaseVC

@property (nonatomic, weak) id<TLMianLiaoChooseVCDelegate> delegate;

@property (nonatomic, copy) NSString *innnerProductCode;

//选择完成的时候根据， productCode 就能判断出是什么产品的，面料费

@end
