//
//  NetWorking.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/4.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id result);
typedef void (^FailedBlock)(NSString *errorResult);

@interface NetWorking : NSObject


//添加进度的post请求
+ (void)postDataWithParameters:(NSDictionary *)paramets withUrl:(NSString *)urlstr withBlock:(SuccessBlock)block withFailedBlock:(FailedBlock)fBlock;

//login页面post请求
+ (void)loginPostDataWithParameters:(NSDictionary *)paramets withUrl:(NSString *)urlstr withBlock:(SuccessBlock)block withFailedBlock:(FailedBlock)fBlock;


//后台post请求
+ (void)bgPostDataWithParameters:(NSDictionary *)paramets withUrl:(NSString *)urlstr withBlock:(SuccessBlock)block withFailedBlock:(FailedBlock)fBlock;



@end
