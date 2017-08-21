//
//  ZHSegmentView.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHSegmentView.h"
#import "TLUIHeader.h"
#import "UIColor+theme.h"

#define NORMAL_TITLE_COLOR  [UIColor colorWithHexString:@"#b3b3b3"]
#define SELECT_TITLE_COLOR  [UIColor themeColor]

@interface ZHSegmentView()

@property (nonatomic,strong) UIButton *lastBtn;


@end

@implementation ZHSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    }
    return self;
}

- (void)changeAction:(UIButton *)btn {
    
        if ([self.lastBtn isEqual:btn]) {
            return;
        }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentSwitch:)]) {
        
        //---//
        
        if ([self.delegate segmentSwitch:btn.tag - 1000]) { //底线跟着切换
            
            [btn setTitleColor:SELECT_TITLE_COLOR  forState:UIControlStateNormal];
     
            [self.lastBtn setTitleColor:NORMAL_TITLE_COLOR forState:UIControlStateNormal];
            self.lastBtn = btn;
            
        } else { //底线不切换
            
            
        }
        
    }
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

    _selectedIndex = selectedIndex;
    
    UIButton *btn = (UIButton *)[self viewWithTag:1000 + selectedIndex];
    if (btn) {
        [self changeAction:btn];
    }

}

- (void)reloadTagNameWithArray:(NSArray *)tagNames {

    if (!tagNames || tagNames.count <= 0) {
        return;
    }
    //找出按钮,重新赋值
    for (NSInteger i = 0; i < tagNames.count; i++) {
     UIButton *btn =  (UIButton *)[self viewWithTag:1000 + i];
        
        [btn setTitle:tagNames[i] forState:UIControlStateNormal];
        
    }

}


- (void)setTagNames:(NSArray *)tagNames {

    _tagNames = [tagNames copy];
    self.userInteractionEnabled = YES;
    NSInteger count = tagNames.count;
    
    CGFloat w = (SCREEN_WIDTH - 5)/(count*1.0);
    CGFloat h = self.height;
    //
    
//    self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    NSArray *names = _tagNames;
    
    for (NSInteger i = 0; i < names.count; i ++) {
        
        CGFloat x = w*i + 10;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, w, h) title:names[i] backgroundColor:self.backgroundColor];
        [self addSubview:btn];
        
        btn.tag = 1000 + i;
        btn.titleLabel.font = [UIFont secondFont];
        [btn setTitleColor:NORMAL_TITLE_COLOR forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        if (0 == i) {
            
            [btn setTitleColor:SELECT_TITLE_COLOR forState:UIControlStateNormal];
            self.lastBtn = btn;
        }
    }

}

@end
