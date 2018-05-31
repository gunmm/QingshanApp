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
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *personImageUrl;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *plateNumber;
@property (nonatomic, copy) NSString *vehicleType;
@property (nonatomic, copy) NSString *driverCertificationStatus;
@property (nonatomic, copy) NSString *driverLicenseImageUrl;
@property (nonatomic, copy) NSString *driverVehicleImageUrl;
@property (nonatomic, copy) NSString *driverThirdImageUrl;
@property (nonatomic, assign) double nowLatitude;
@property (nonatomic, assign) double nowLongitude;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) float score;

@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) long long lastLoginTime;










@end





