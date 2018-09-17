//
//  ComplainModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/9/8.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComplainModel : NSObject
@property (nonatomic, copy) NSString *recordId;

@property (nonatomic, copy) NSString *createManId;  //投诉人
@property (nonatomic, copy) NSString *createManName;//投诉人姓名

@property (nonatomic, copy) NSString *complainedManId;//被投诉人id
@property (nonatomic, copy) NSString *complainedManName; //被投诉人姓名


@property (nonatomic, copy) NSString *orderId;//订单
@property (nonatomic, copy) NSString *orderStatus;//订单状态
@property (nonatomic, assign) double price;//总运费用
@property (nonatomic, assign) double servicePrice;//服务费
@property (nonatomic, assign) double distance;//距离

@property (nonatomic, copy) NSString *type;//投诉类型 1:货主投诉司机   2：司机投诉货主
@property (nonatomic, copy) NSString *note;//投诉详情
@property (nonatomic, copy) NSString *manageMan; //操作员
@property (nonatomic, copy) NSString *manageManName;   //操作员姓名
@property (nonatomic, copy) NSString *manageStatus;//处理状态   0:待处理  1：司机减分  2：货主减分   3：拉黑司机   4.拉黑货主
@property (nonatomic, copy) NSString *manageDetail;//处理详情 (文字描述)
@property (nonatomic, copy) NSString *manageDriver;               //处理司机 0：不处理  1：评分减一  2：拉黑
@property (nonatomic, copy) NSString *manageMaster;               //处理货主 0：不处理  1：评分减一  2：拉黑
@property (nonatomic, copy) NSString *manageOrder;               //处理订单 0：不处理  1：变为取消状态  2：变为异常状态

@property (nonatomic, assign) long long createTime;// 创建时间
@property (nonatomic, assign) long long updateTime;// 更新时间





@end
