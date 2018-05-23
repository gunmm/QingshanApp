//
//  NetWorking.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/4.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "NetWorking.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetWorking




//POST请求
+ (void)postDataWithParameters:(NSDictionary *)paramets withUrl:(NSString *)urlstr withBlock:(SuccessBlock)block withFailedBlock:(FailedBlock)fBlock {
    
    NSMutableDictionary *head = [NSMutableDictionary dictionary];
    [head setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    [head setObject:[[Config shareConfig] getToken] forKey:@"token"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:head forKey:@"head"];
    [parameters setObject:paramets forKey:@"body"];

    
    //创建manger
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    MBProgressHUD *hud = [HUDClass showLoadingHUD];
    [manager POST:[NetWorking netUrlWithStr:urlstr] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HUDClass hideLoadingHUD:hud];
        NSString *runStatus = [responseObject objectForKey:@"result_code"];
        NSString *reason = [responseObject objectForKey:@"reason"];

        if ([runStatus isEqualToString:@"1"]) {
            block(responseObject);
        }else {
            [HUDClass showHUDWithText:reason];
            fBlock(reason);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HUDClass hideLoadingHUD:hud];
        NSLog(@"error---%@",error);
        if ([[error.userInfo allKeys]containsObject:@"NSLocalizedDescription"]) {
            fBlock([error.userInfo objectForKey:@"NSLocalizedDescription"]);
        }else{
            fBlock(@"error");
        }
    }];
}

//Login页面POST请求
+ (void)loginPostDataWithParameters:(NSDictionary *)paramets withUrl:(NSString *)urlstr withBlock:(SuccessBlock)block withFailedBlock:(FailedBlock)fBlock {
    
    //创建manger
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"body":paramets};
    MBProgressHUD *hud = [HUDClass showLoadingHUD];
    [manager POST:[NetWorking netUrlWithStrLogin:urlstr] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HUDClass hideLoadingHUD:hud];
        NSString *runStatus = [responseObject objectForKey:@"result_code"];
        NSString *result = [responseObject objectForKey:@"result"];
        
        if ([runStatus isEqualToString:@"1"]) {
            block(responseObject);
        }else {
            [HUDClass showHUDWithText:result];
            fBlock(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HUDClass hideLoadingHUD:hud];
        NSLog(@"error---%@",error);
        if ([[error.userInfo allKeys]containsObject:@"NSLocalizedDescription"]) {
            fBlock([error.userInfo objectForKey:@"NSLocalizedDescription"]);
        }else{
            fBlock(@"error");
        }
    }];
}

+ (NSString *)netUrlWithStr:(NSString *)url {
    return [NSString stringWithFormat:@"%@mobile/%@",[Utils getServer],url];
}

+ (NSString *)netUrlWithStrLogin:(NSString *)url {
    return [NSString stringWithFormat:@"%@%@",[Utils getServer],url];
}


@end
