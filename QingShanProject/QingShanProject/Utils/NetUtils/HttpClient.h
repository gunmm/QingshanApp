//
//  HttpClient.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京仝仝科技有限公司. All rights reserved.
//

#ifndef HttpClient_h
#define HttpClient_h

//#import <AFNetworking.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, Fail_Type)
{
    Network_Error,  //网络错误
    System_Error    //业务逻辑错误
};

@interface HttpClient : AFHTTPSessionManager

+ (void)attempDealloc;

+ (instancetype)shareClient;

/**
 *  显示模态框执行网络请求
 *
 *  @param view       nil
 *  @param url        url
 *  @param parameters NSDictionary
 *  @param success    block
 *  @param failure    block
 */
- (void)view:(UIView *)view post:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *errr)) failure;
//__deprecated_msg("已过期");

/**
 *  显示模态框执行网络请求
 *
 *  @param url        url
 *  @param parameters NSDictionary
 *  @param success    block
 *  @param failure    block
 */
- (void)fgPost:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *errr)) failure;


/**
 *  后台执行网络请求
 *
 *  @param url        url
 *  @param parameters NSDictionary
 *  @param success    block
 *  @param failure    block
 */
- (void)post:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType)) failure;
//__deprecated_msg("已过期");

/**
 *  后台执行网络请求
 *
 *  @param url        url
 *  @param parameters NSDictionary
 *  @param success    block
 *  @param failure    block
 */
- (void)bgPost:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType)) failure;


@end

#endif /* HttpClient_h */
