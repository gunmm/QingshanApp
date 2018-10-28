//
//  Config.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/28.
//  Copyright © 2016年 北京仝仝科技有限公司. All rights reserved.
//

#ifndef Config_h
#define Config_h

@interface Config : NSObject

+ (instancetype)shareConfig;

//设置和获取用户图像
- (void)setUserImage:(NSString *)userImage;

- (NSString *)getUserImage;

//设置和获取用户名
- (void)setUserName:(NSString *)userName;

- (NSString *)getUserName;

//设置和获取角色id
- (void)setType:(NSString *)type;

- (NSString *)getType;

//司机类型 //1: 车主司机  2:小司机
- (void)setDriverType:(NSString *)driverType;
- (NSString *)getDriverType;


//设置和获取accessToken
- (void)setToken:(NSString *)token;

- (NSString *)getToken;

//设置和获取bankCardNumber
- (void)setBankCardNumber:(NSString *)bankCardNumber;

- (NSString *)getBankCardNumber;


//设置和获取userId
- (void)setUserId:(NSString *)userId;

- (NSString *)getUserId;

//设置和获取用户姓名
- (void)setName:(NSString *)name;

- (NSString *)getName;



//设置和获取server
- (void)setServer:(NSString *)server;

- (NSString *)getServer;

- (void)cleanUserInfo;


@end


#endif /* Config_h */
