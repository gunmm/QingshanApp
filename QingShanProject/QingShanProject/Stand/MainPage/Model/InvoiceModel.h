//
//  InvoiceModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/9/8.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoiceModel : NSObject


@property (nonatomic, strong) NSString *invoiceId;
@property (nonatomic, strong) NSString *status;  //发票状态   0:未开  1：已开 9:订单取消

@property (nonatomic, strong) NSString *invoiceType;  //发票类型  1：个人  2：单位
@property (nonatomic, strong) NSString *receiverName;   //收票人姓名
@property (nonatomic, strong) NSString *receiverPhone;   //收票人电话
@property (nonatomic, strong) NSString *receiverAddress;   //收票人地址
@property (nonatomic, strong) NSString *companyName;    //公司名
@property (nonatomic, strong) NSString *companyNumber;  //纳税人识别号
@property (nonatomic, strong) NSString *expressCompanyName;   //快递公司
@property (nonatomic, strong) NSString *expressNumber;   //运单号

@property (nonatomic, strong) NSString *orderId;   // 订单完成时间

@property (nonatomic, strong) NSString *orderStatus;   //订单状态 0：刚新建未被接单 1:已被抢单  2：已被接单  3：已发货  4：发货完成  9：订单取消  8：司机投诉


@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) long long updateTime;
@property (nonatomic, assign) long long finishTime;



@end
