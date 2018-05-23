//
//  HttpClient.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京仝仝科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "Config.h"
#import "AppDelegate.h"

@interface HttpClient()

@property (nonatomic ,strong)NSString * URLString;

@end

@implementation HttpClient


static HttpClient *_shareClient = nil;

static dispatch_once_t onceToken;

+ (instancetype)shareClient
{
    dispatch_once(&onceToken, ^{
        
        _shareClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:[Utils getServer]]];
        _shareClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _shareClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _shareClient.responseSerializer.acceptableContentTypes
        = [_shareClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    });
    
    return _shareClient;
}

+ (void)attempDealloc
{
    onceToken = 0;
    _shareClient = nil;
}

/**
 *  显示模态框请求网络
 *
 *  @param url        <#url description#>
 *  @param parameters <#parameters description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */
- (void)fgPost:(NSString *)url parameters:(id)parameters
       success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *errr)) failure
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *head = [[NSMutableDictionary alloc] init];
    
    [head setObject:@"1" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    head[@"type"] = [[Config shareConfig] getType];
    [head setObject:[[Config shareConfig] getToken] forKey:@"accessToken"];
    [head setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    
    if (parameters)
    {
        [param setObject:parameters forKey:@"body"];
    }
    
    [param setObject:head forKey:@"head"];
    
#ifdef DEBUG
    NSLog(@"zhenhao-----request:%@", param);
#endif
    
    MBProgressHUD *hud = [HUDClass showLoadingHUD];
    
    [self POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
#ifdef DEBUG
        NSLog(@"zhenhao-----response:%@", responseObject);
#endif
  
        [HUDClass hideLoadingHUD:hud];
        
        if ([responseObject objectForKey:@"result"]) {
            success(task, responseObject);
            return;
        }
        
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"rspCode"] isEqualToString:@"0"])
        {
             success(task, responseObject);
        }
        else
        {
            //根据错误信息提示用户
            NSString *msg = nil;
            NSString *rspMsg = [[responseObject objectForKey:@"head"]objectForKey:@"rspMsg"];
            if ([rspMsg containsString:@"系统错误"])
            {
                msg = [rspMsg substringFromIndex:5];
            }
            else
            {
                msg = rspMsg;
            }
            
            
            NSString * msgCode = [[responseObject objectForKey:@"head"]objectForKey:@"rspCode"];
    
            [HUDClass showHUDWithText:msg];
            
            if ([msgCode isEqualToString:@"-9"])
            {
                [self performSelector:@selector(backToLogin) withObject:nil afterDelay:2];
                
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        NSLog(@"zhenhao-----error:%@", error);
#endif
        [HUDClass hideLoadingHUD:hud];
        
        failure(task, error);
    }];
}

/**
 *  已过期
 *
 */
- (void)view:(UIView *)view post:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self fgPost:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        failure(task, errr);
    }];
}


/**
 *  已过期
 *
 */
- (void)post:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType)) failure
{
    [self bgPost:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType) {
        failure(task, errr, failType);
    }];
}

- (void)bgPost:(NSString *)url parameters:(id)parameters
       success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType)) failure
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *head = [[NSMutableDictionary alloc] init];
    
    [head setObject:@"1" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    [head setObject:@"" forKey:@"deviceId"];
    head[@"type"] = [[Config shareConfig] getType];
    [head setObject:[[Config shareConfig] getToken] forKey:@"accessToken"];
    [head setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    
    if (parameters)
    {
        [param setObject:parameters forKey:@"body"];
    }
    
    [param setObject:head forKey:@"head"];
    
#ifdef DEBUG
    NSLog(@"zhenhao-----request:%@", param);
#endif
    
    
    [self POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
#ifdef DEBUG
        NSLog(@"zhenhao-----response:%@", responseObject);
#endif
        
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"rspCode"] isEqualToString:@"0"])
        {
            success(task, responseObject);
        }
        else
        {
            failure(task, responseObject, System_Error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"zhenhao-----error:%@", error);
        
        failure(task, error, Network_Error);
    }];
}


- (void)backToLogin
{

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate.window setRootViewController:controller];
    
    [[Config shareConfig] setToken:@""];
}


@end
