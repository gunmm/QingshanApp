//
//  NotfiModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/23.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotfiApsModel.h"

@interface NotfiModel : NSObject

@property (nonatomic, copy) NSString *_j_msgid;
@property (nonatomic, copy) NSString *_j_business;
@property (nonatomic, copy) NSString *_j_uid;

@property (nonatomic, copy) NSString *notifyType;  // 有新的订单newOrderNotify    被接单OrderBeReceivedNotify     订单被用户取消 OrderBeCanceledNotify
@property (nonatomic, strong) NotfiApsModel *aps;

//用户收到订单确认 被接单

@property (nonatomic, copy) NSString *driverPhone;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *appointStatus;
@property (nonatomic, copy) NSString *sendAddress;
@property (nonatomic, copy) NSString *receiveAddress;
@property (nonatomic, copy) NSString *plateNumber;
@property (nonatomic, copy) NSString *driverName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *appointTime;



//司机收到新订单
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *linkMan;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *carTypeName;

@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *orderId;


//订单被用户取消







@end

