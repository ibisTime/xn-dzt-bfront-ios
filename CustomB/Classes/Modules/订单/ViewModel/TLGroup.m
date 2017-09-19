//
//  TLGroup.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLGroup.h"
#import "TLChooseDataModel.h"
#import "TLDataModel.h"
#import "TLInputDataModel.h"


@implementation TLGroup {

    CGSize _orgHeaderSize;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.canEdit = YES;
        self.editting = NO;
    }
    return self;
}

- (UIEdgeInsets)edgeInsets {

    if (self.editting) {
        return self.editingEdgeInsets;
    }
    
    return self.editedEdgeInsets;
    
}


- (void)setHeaderSize:(CGSize)headerSize {

    _headerSize = headerSize;
    _orgHeaderSize = headerSize;
}

- (void)groupSetShow {

    self.editting = YES;
    _headerSize = _orgHeaderSize;

}

- (void)groupSetHidden {

//    return;
    self.editting = NO;
    //高度设为0
    //不要调用set
    _headerSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.01);

}


- (NSInteger)itemCount {

    if (!self.dataModelRoom || self.dataModelRoom.count <=0 ) {
        return 0;
    }
    
    if ([self.dataModelRoom[0] isKindOfClass:[TLDataModel class]] || [self.dataModelRoom[0] isKindOfClass:[TLChooseDataModel class]]) {
        
        return self.dataModelRoom.count;
        
    } else {
    
        if (self.editting) {
            
            return self.dataModelRoom.count;
            
        } else {
            
            return 0;
        }
    
    }
 
}



@end
