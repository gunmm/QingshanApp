//
//  UserModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/25.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject


@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accessToken;



@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *personImageUrl;
@property (nonatomic, copy) NSString *belongSiteId;
@property (nonatomic, copy) NSString *belongSiteName;


@property (nonatomic, copy) NSString *loginPlate;

@property (nonatomic, copy) NSString *type;  // 0：超级管理员，1：平台管理员，2：平台投诉业务处理人员，3：站点管理员，4：站点业务员，5：货源方，6：司机
@property (nonatomic, copy) NSString *userIdCardNumber;   //身份证号

@property (nonatomic, copy) NSString *status;  //状态       司机是否在拉货  1：在拉货 0：未拉货  2：下班
@property (nonatomic, copy) NSString *vehicleId;   //车辆id
@property (nonatomic, copy) NSString *plateNumber;  // 车牌号
@property (nonatomic, copy) NSString *vehicleType; //车辆类型
@property (nonatomic, copy) NSString *vehicleTypeName;
@property (nonatomic, copy) NSString *driverLicenseNumber; //司机驾驶证号
@property (nonatomic, copy) NSString *driverQualificationNumber; //司机资格证号

@property (nonatomic, copy) NSString *bankCardNumber; //银行卡号

@property (nonatomic, copy) NSString *mainGoodsName; //主要经营货物名称
@property (nonatomic, copy) NSString *businessCardNumber; //营业执照号

@property (nonatomic, assign) float score;   //分值。默认2：   投诉一次减0.1


@property (nonatomic, copy) NSString *blackStatus;    //是否被拉黑
@property (nonatomic, copy) NSString *deleteStatus;  //是否被删除


@property (nonatomic, copy) NSString *gpsType;  // gps类型
@property (nonatomic, copy) NSString *gpsTypeName;
@property (nonatomic, copy) NSString *gpsSerialNumber;   // gps序列号


@property (nonatomic, copy) NSString *drivingCardNumber;  // 行驶证号
@property (nonatomic, copy) NSString *vehicleRegistrationNumber;  // 车辆登记证号
@property (nonatomic, copy) NSString *operationCertificateNumber;  // 营运证号
@property (nonatomic, copy) NSString *insuranceNumber;      // 登记保险证号
@property (nonatomic, copy) NSString *vehicleIdCardNumber;   // 车主身份证
@property (nonatomic, copy) NSString *businessLicenseNumber;    //  营业执照号
@property (nonatomic, copy) NSString *vehicleBrand;     // 车辆品牌
@property (nonatomic, copy) NSString *vehicleModel;     // 车辆型号
@property (nonatomic, copy) NSString *vehiclePhoto;     // 车辆图片
@property (nonatomic, copy) NSString *loadWeight;       // 车辆载重
@property (nonatomic, copy) NSString *vehicleMakeDate;       // 车辆出厂日期


@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) long long lastLoginTime;
@property (nonatomic, assign) long long updateTime;





















@end






