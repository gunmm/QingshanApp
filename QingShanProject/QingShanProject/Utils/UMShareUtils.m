//
//  UMShareUtils.m
//  QingShanProject
//
//  Created by gunmm on 2018/11/17.
//  Copyright © 2018 gunmm. All rights reserved.
//

#import "UMShareUtils.h"
#import <UShareUI/UShareUI.h>


@implementation UMShareUtils
{
    UIImage *shareimage;
}

+ (instancetype)shareConfig {
    static UMShareUtils *config = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        config = [[UMShareUtils alloc] init];
    });
    
    return config;
}


- (void)shareWeb {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    
  
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【庆山物流】" descr:@"【庆山物流】专注于服务大车货运的工具类软件！" thumImage:[UIImage imageNamed:@"1024"]];
    //设置网页地址
    shareObject.webpageUrl = @"http://39.107.113.157/downLoadPage.html";

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[UIViewController new] completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);

            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
        [self alertWithError:error];

    }];
}



- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功！"];
    }
    else{
        if ([[error.userInfo objectForKey:@"message"] isEqualToString:@"Check APP UrlSchema Fail"]) {
            result = [NSString stringWithFormat:@"未安装目标APP,分享失败！"];
        }
        else{
            result = [NSString stringWithFormat:@"分享失败！"];
        }
    }
}






@end
