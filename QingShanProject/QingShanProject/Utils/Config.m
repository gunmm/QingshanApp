//
//  Config.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/28.
//  Copyright © 2016年 北京仝仝科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@implementation Config

+ (instancetype)shareConfig
{
    static Config *config = nil;

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        config = [[Config alloc] init];
    });
    
    return config;
}
- (void)cleanUserInfo
{
    [self setToken:@""];
}

//设置和获取用户图像
- (void)setUserImage:(NSString *)userImage {
    [self setValue:userImage key:@"user_image"];
}

- (NSString *)getUserImage {
    return [self getValueWithKey:@"user_image"];
}

- (void)setUserName:(NSString *)userName
{
    [self setValue:userName key:@"user_name"];
}

- (NSString *)getUserName
{
    return [self getValueWithKey:@"user_name"];
}

//设置和获取角色id
- (void)setType:(NSString *)type {
    [self setValue:type key:@"type"];
}

- (NSString *)getType {
    return [self getValueWithKey:@"type"];
}


- (void)setToken:(NSString *)token
{
    [self setValue:token key:@"token"];
}

- (NSString *)getToken
{
    NSString *token = [self getValueWithKey:@"token"];
    
    if (nil == token)
    {
        token = @"";
    }
    
    return token;
}

//设置和获取bankCardNumber
- (void)setBankCardNumber:(NSString *)bankCardNumber {
    [self setValue:bankCardNumber key:@"bankCardNumber"];
}

- (NSString *)getBankCardNumber {
    return [self getValueWithKey:@"bankCardNumber"];
}

- (void)setUserId:(NSString *)userId
{
    [self setValue:userId key:@"user_id"];
}

- (NSString *)getUserId
{
    NSString *userId = [self getValueWithKey:@"user_id"];
    
    if (nil == userId)
    {
        userId = @"";
    }
    return userId;
}

- (void)setName:(NSString *)name
{
    [self setValue:name key:@"name"];
}

- (NSString *)getName
{
    return [self getValueWithKey:@"name"];
}



//设置和获取server
- (void)setServer:(NSString *)server
{
    [self setValue:server key:@"server"];
}

- (NSString *)getServer
{
    return [self getValueWithKey:@"server"];
}



#pragma mark -- common method

- (void)setValue:(NSObject *)value key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (id)getValueWithKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
