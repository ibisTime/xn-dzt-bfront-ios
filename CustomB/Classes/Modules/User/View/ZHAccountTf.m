//
//  ZHAccountTf.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHAccountTf.h"
#import "UIView+Frame.h"
#import "UIColor+Extension.h"

@interface ZHAccountTf()




@end
@implementation ZHAccountTf

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.font = [UIFont systemFontOfSize:14];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;

        
        UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, frame.size.height)];
        
        _leftIconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 20, 20)];
        _leftIconView.contentMode = UIViewContentModeCenter;
        _leftIconView.centerY = leftBgView.height/2.0;
        _leftIconView.contentMode = UIViewContentModeScaleAspectFit;
        //_leftIconView.backgroundColor = [UIColor orangeColor];
        [leftBgView addSubview:_leftIconView];
        
        self.leftView = leftBgView;

        
    }
    return self;

}

- (void)setZh_placeholder:(NSString *)zh_placeholder {

    _zh_placeholder = [zh_placeholder copy];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_zh_placeholder attributes:@{
                                                                                                          NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#b3b3b3"]
                                                                                                         }];
    self.attributedPlaceholder = attrStr;

}


//
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    
//    return [self newRect:bounds];
//}
//
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    
//    return [self newRect:bounds];
//}
//
//- (CGRect)placeholderRectForBounds:(CGRect)bounds {
//
//    return [self newRect:bounds];
//}

//- (CGRect)newRect:(CGRect)oldRect {
//
//    CGRect newRect = oldRect;
//    newRect.origin.x = newRect.origin.x + 64;
//    return newRect;
//}

@end
