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
@property (nonatomic, copy) NSString *plateNumber;    //车牌号
@property (nonatomic, copy) NSString *driverId;       //司机
@property (nonatomic, copy) NSString *nickname;        //
@property (nonatomic, copy) NSString *phoneNumber;       //
@property (nonatomic, copy) NSString *personImageUrl;       //
@property (nonatomic, assign) float score;       //
@property (nonatomic, assign) double nowLatitude;       //车辆当前经纬度
@property (nonatomic, assign) double nowLongitude;       //

@property (nonatomic, copy) NSString *createManId;       //发布人id
@property (nonatomic, copy) NSString *linkMan;       //联系人
@property (nonatomic, copy) NSString *linkPhone;       //联系电话
@property (nonatomic, copy) NSString *receiveMan;      //收货人
@property (nonatomic, copy) NSString *receivePhone;       //收货联系电话


@property (nonatomic, copy) NSString *sendAddress;       //
@property (nonatomic, copy) NSString *sendDetailAddress;       //
@property (nonatomic, assign) double sendLatitude;       //
@property (nonatomic, assign) double sendLongitude;       //

@property (nonatomic, copy) NSString *receiveAddress;       //
@property (nonatomic, copy) NSString *receiveDetailAddress;       //
@property (nonatomic, assign) double receiveLatitude;       //
@property (nonatomic, assign) double receiveLongitude;       //

@property (nonatomic, copy) NSString *freightFeePayId;       //运费 支付号
@property (nonatomic, copy) NSString *freightFeePayStatus;       ////运费 支付状态   0:未支付   1:已支付
@property (nonatomic, copy) NSString *freightFeePayType;       // 运费  支付方式   1:支付宝支付    2:微信支付   3:现金支付

@property (nonatomic, copy) NSString *serviceFeePayId;       ///服务费  支付方式   1:支付宝支付    2:微信支付
@property (nonatomic, copy) NSString *serviceFeePayStatus;       //服务费 支付状态   0:未支付   1:已支付
@property (nonatomic, copy) NSString *serviceFeePayType;       //服务费 支付号

@property (nonatomic, copy) NSString *status;       // 订单状态 0：刚新建未被接单 1:已被抢单  2：已被接单  3：已发货  4：发货完成  9：订单取消
@property (nonatomic, copy) NSString *type;       // 订单类型  1：实时  2：预约
@property (nonatomic, copy) NSString *appointStatus;       //预约状态    预约订单司机方的执行状态   0：未开始   1：已开始
@property (nonatomic, copy) NSString *carType;       //车辆类型
@property (nonatomic, copy) NSString *carTypeName;       //车辆类型
@property (nonatomic, assign) double price; //费用
@property (nonatomic, assign) double servicePrice; //服务费

@property (nonatomic, assign) double distance; //距离
@property (nonatomic, copy) NSString *invoiceId;       //发票ID
@property (nonatomic, copy) NSString *note;       //订单备注

@property (nonatomic, copy) NSString *commentContent; //评价内容
@property (nonatomic, assign) double commentStar; //评价星级

@property (nonatomic, copy) NSString *siteComplaint;
@property (nonatomic, copy) NSString *driverComplaint;

@property (nonatomic, copy) NSString *withdrawMoneyStatus;

@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) long long updateTime;
@property (nonatomic, assign) long long appointTime;
@property (nonatomic, assign) long long timeOut;





@end










