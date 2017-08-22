//
//  TLOrderParameterCell.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderParameterCell.h"
#import "TLUIHeader.h"

@interface TLOrderParameterCell()

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation TLOrderParameterCell

+ (NSString *)cellReuseIdentifier {
    
    return @"TLOrderParameterCellID";
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.bgImageView];
        self.bgImageView.layer.cornerRadius = 10;
        self.bgImageView.backgroundColor = [UIColor whiteColor];
        self.bgImageView.layer.masksToBounds = YES;
        self.bgImageView.layer.borderColor = [UIColor colorWithHexString:@"#a0a0a0"].CGColor;
        self.bgImageView.layer.borderWidth = 0.5;

      
        
    }
    return self;
}

@end
