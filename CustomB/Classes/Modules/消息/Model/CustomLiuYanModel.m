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

- (NSString *)otherUserName {

    if (self.chatType == ChatModelTypeMe) {
        
        return self.receiveName;
        
    } else {
    
        return self.commentName;
        
    }

}

- (NSString *)otherUserId {

    if (self.chatType == ChatModelTypeMe) {
        
        return self.receiver;
        
    } else {
        
        return self.commenter;
        
    }

}
@end
