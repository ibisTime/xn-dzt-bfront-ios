//
//  CustomLiuYanModel.m
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CustomLiuYanModel.h"
#import "TLUser.h"

@implementation CustomLiuYanModel

- (ChatModelType)chatType {

    if ([self.commenter isEqualToString:[TLUser user].userId]) {
        
        return ChatModelTypeMe;
    }
    
    return ChatModelTypeOther;

}
@end
