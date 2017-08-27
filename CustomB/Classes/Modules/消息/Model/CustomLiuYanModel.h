//
//  CustomLiuYanModel.h
//  CustomB
//
//  Created by  tianlei on 2017/8/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

typedef NS_ENUM(NSUInteger, ChatModelType) {
    ChatModelTypeMe,
    ChatModelTypeOther
};



@interface CustomLiuYanModel : TLBaseModel

@property (nonatomic, copy) NSString *commentDatetime;
@property (nonatomic, copy) NSString *commentMobile;
@property (nonatomic, copy) NSString *commentName;
@property (nonatomic, copy) NSString *commentPhoto;
@property (nonatomic, copy) NSString *commenter;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *receivePhoto;
@property (nonatomic, copy) NSString *receiveName;
@property (nonatomic, copy) NSString *receiveMobile;

@property (nonatomic, assign,readonly) ChatModelType chatType;




//code = JL201708271917079706;
//commentDatetime = "Aug 27, 2017 7:17:07 PM";
//commentMobile = 18868824532;
//commentName = "\U5434\U8054\U8bf7";
//commentPhoto = "http://wx.qlogo.cn/mmopen/ajNVdqHZLLDKttVuk2tbm7ViacRCoBcp414d22yMTPco2O5c2ndyib5sDVNq5DJ4AxXmNyYpIiaJCce8ibEDvvrhvQ/0";
//commenter = U201708231336531301754;
//content = fdsfadfa;
//orderNo = 24;
//receiveMobile = 13868074590;
//receiveName = 36311425;
//receivePhoto = "IOS_1503816222261769_3000_2002.jpg";
//receiver = U201708220942536311425;
//status = 0;
//type = 1;

@end
