//
//  MessageModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/7.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *messageType;
@property (nonatomic, copy) NSString *receiveUserId;
@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *orderAppointStatus;
@property (nonatomic, copy) NSString *secondTitle;
@property (nonatomic, copy) NSString *isRead;
@property (nonatomic, assign) long long createTime;
@end
