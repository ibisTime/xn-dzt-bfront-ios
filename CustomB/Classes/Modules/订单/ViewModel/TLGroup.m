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

@implementation TLGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.editting = NO;
    }
    return self;
}

- (NSInteger)itemCount {

    if (self.dataModelRoom.count <=0 ) {
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
