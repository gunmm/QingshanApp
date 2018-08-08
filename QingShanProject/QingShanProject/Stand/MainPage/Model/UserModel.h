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
@property (nonatomic, copy) NSString *userIdCardNumber;   //身份证号

@property (nonatomic, copy) NSString *loginPlate;
@property (nonatomic, copy) NSString *blackStatus;
@property (nonatomic, copy) NSString *deleteStatus;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) float score;

@property (nonatomic, copy) NSString *belongSiteId;
@property (nonatomic, copy) NSString *siteType;


@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *vehicleId;
@property (nonatomic, copy) NSString *vehicleType;
@property (nonatomic, copy) NSString *driverLicenseNumber;
@property (nonatomic, copy) NSString *driverQualificationNumber;

@property (nonatomic, copy) NSString *bankCardNumber;



@property (nonatomic, copy) NSString *businessCardNumber;
@property (nonatomic, copy) NSString *mainGoodsName;

@property (nonatomic, assign) double nowLatitude;
@property (nonatomic, assign) double nowLongitude;

@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) long long lastLoginTime;
@property (nonatomic, assign) long long updateTime;





@end






