//
//  DriverWithdrawalListModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/8/26.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverWithdrawalListModel : NSObject

@property (nonatomic, copy) NSString *driverWithdrawalId;           //提现记录Id
@property (nonatomic, copy) NSString *driverWithdrawalAmount;           //提现金额
@property (nonatomic, copy) NSString *toBankNumber;           //提现银行卡
@property (nonatomic, copy) NSString *toUserId;           //提现的用户ID
@property (nonatomic, copy) NSString *toUserName;           //提现的用户Name
@property (nonatomic, copy) NSString *oprationUserId;           //操作员Id
@property (nonatomic, copy) NSString *oprationUserName;           //操作员Name

@property (nonatomic, copy) NSString *driverWithdrawalStatus; //司机提现状态 0：已提交  1：管理员已打款
@property (nonatomic, assign) long long driverWithdrawalTime;   //提现时间

@end
