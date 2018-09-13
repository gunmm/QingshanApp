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
@property (nonatomic, copy) NSString *messageId;

//用户收到订单确认 被接单

@property (nonatomic, copy) NSString *driverPhone;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *appointStatus;
@property (nonatomic, copy) NSString *sendAddress;
@property (nonatomic, copy) NSString *receiveAddress;
@property (nonatomic, copy) NSString *plateNumber;
@property (nonatomic, copy) NSString *driverName;




//司机收到新订单
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *sendDetailAddress;
@property (nonatomic, copy) NSString *receiveDetailAddress;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat toSendDistance;


@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *appointTime;



//投诉被确认
@property (nonatomic, copy) NSString *complainId;
@property (nonatomic, copy) NSString *complainType;











@end

