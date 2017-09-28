//
//  TLSwitchScrollView.m
//  CustomB
//
//  Created by  tianlei on 2017/9/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLSwitchScrollView.h"

@interface TLSwitchScrollView()<UIScrollViewDelegate>

@end

@implementation TLSwitchScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

//_delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
}

#pragma mark- 操作上面
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //找出会停在第几页
    NSInteger index = (targetContentOffset -> x)/scrollView.frame.size.width;
    
    //告诉外界
    
    
    
    //    //拖动结束
//    if ([scrollView isEqual:self.smallChooseScrollView]) {
//        
//        //取出离中点最近的一个按钮
//        
//    } else {
//        
//        NSInteger index = (targetContentOffset -> x)/SCREEN_WIDTH;
//        UIButton *currentBtn = (UIButton *)[self.smallChooseScrollView viewWithTag:1000 + index];
//        if ([self.lasBtn isEqual:currentBtn]) {
//            return;
//        }
//        
//        [currentBtn setTitleColor:SELECT_TITLE_COLOR forState:UIControlStateNormal];
//        [self.lasBtn setTitleColor:NORMAL_TITLE_COLOR forState:UIControlStateNormal];
//        self.lasBtn = currentBtn;
//        [self smallScroll:currentBtn];
//        
//    }
    
    
    
}
@end
