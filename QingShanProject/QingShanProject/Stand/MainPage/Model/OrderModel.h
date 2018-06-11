//
//  OrderModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/24.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *appointStatus;
@property (nonatomic, copy) NSString *createManId;
@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *linkMan;
@property (nonatomic, copy) NSString *linkPhone;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *carTypeName;

@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *sendAddress;
@property (nonatomic, assign) double sendLatitude;
@property (nonatomic, assign) double sendLongitude;
@property (nonatomic, copy) NSString *receiveAddress;
@property (nonatomic, assign) double receiveLatitude;
@property (nonatomic, assign) double receiveLongitude;

@property (nonatomic, assign) double price; //费用
@property (nonatomic, assign) double distance; //距离
@property (nonatomic, copy) NSString *payType; //支付方式   1:支付宝支付    2:微信支付   3:现金支付
@property (nonatomic, copy) NSString *payStatus; //支付状态   0:未支付   1:已支付

@property (nonatomic, copy) NSString *commentContent; //评价内容
@property (nonatomic, assign) double commentStar; //评价星级


@property (nonatomic, copy) NSString *siteComplaint;
@property (nonatomic, copy) NSString *driverComplaint;

@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) long long updateTime;
@property (nonatomic, assign) long long appointTime;


@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *personImageUrl;
@property (nonatomic, assign) double nowLatitude;
@property (nonatomic, assign) double nowLongitude;
@property (nonatomic, copy) NSString *plateNumber;
@property (nonatomic, assign) float score;







@end


//@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
//private Date createTime; // 创建时间
//
//@DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
//private Date appointTime; //预约时间
