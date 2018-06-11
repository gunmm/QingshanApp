//
//  AppDelegate.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/2.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "DriverMainMMController.h"
#import "StandMainMMController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>




@interface AppDelegate (){
    BMKMapManager *_mapManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    
   
    NSString *token = [[Config shareConfig] getToken];
    if (0 == token.length)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];
        _window.rootViewController = controller;
    }else{
    
        NSString *type = [Config shareConfig].getType;
        if ([type isEqualToString:@"1"]) {
            StandMainMMController *standMainVC = [[StandMainMMController alloc] initStandMainMMVC];
            _window.rootViewController = standMainVC;
        }else if ([type isEqualToString:@"2"]) {
            DriverMainMMController *driverMainVC = [[DriverMainMMController alloc] initDriverMainMMVC];
            _window.rootViewController = driverMainVC;
        }
    }
    
    [self initBaiduMap];


    //注册jpush
    [self registerJPushWithOptions:launchOptions];
    
    
    
    return YES;
}

- (void)initBaiduMap {
    //百度地图
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:BM_KEY generalDelegate:nil];
    
    if (ret) {
        NSLog(@"BMMap manager start successfully");
        
    } else {
        NSLog(@"BMMap manager start failed");
    }
}



- (void)registerJPushWithOptions:(NSDictionary *)launchOptions
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    
    CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (version >= 10.0)
    {
        [JPUSHService
         registerForRemoteNotificationTypes:UNAuthorizationOptionSound | UNAuthorizationOptionAlert
         categories:nil];
    }
    else if (version >= 8.0)
    {
        [JPUSHService
         registerForRemoteNotificationTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert
         categories:nil];
    }
    else
    {
        [JPUSHService
         registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert
         categories:nil];
        
    }
    
    
#else
    
    [JPUSHService
     registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert
     categories:nil];
    
#endif
    
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY channel:@"ios" apsForProduction:0];
    
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        _notifyMsgInfo = userInfo;
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
    NSLog(@"fail to register for remote notifications with error:%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"remote notificaiton:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    
    //发送应用内通知
    NSNotification *notification = [NSNotification notificationWithName:@"concrete_notify" object:nil userInfo:userInfo];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center postNotification:notification];
    
}

@end
