//
//  StandMainMMController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/4.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "StandMainMMController.h"
#import "StandLeftPageController.h"
#import "StandMainPageController.h"
#import "BaseNavController.h"
#import "OrderListController.h"
#import "AppDelegate.h"
#import "DriverInfoController.h"
#import "SettingViewController.h"


@interface StandMainMMController ()
{
    BaseNavController *mainNav;
}


@end

@implementation StandMainMMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.notifyMsgInfo != nil && appDelegate.notifyMsgInfo.count != 0 ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //发送应用内通知
            NSNotification *notification = [NSNotification notificationWithName:@"concrete_notify" object:nil userInfo:appDelegate.notifyMsgInfo];
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotification:notification];
            appDelegate.notifyMsgInfo = nil;
            
        });
       
    }
}


- (instancetype)initStandMainMMVC {
    
    StandMainPageController *standMainPageController = [[StandMainPageController alloc] init];
    mainNav = [[BaseNavController alloc] initWithRootViewController:standMainPageController];
    __weak typeof(self) weakSelf = self;
    standMainPageController.standMainPageShowLeft = ^{
        [weakSelf openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        }];
        
    };
    
    
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyInfo" bundle:nil];
    StandLeftPageController *standLeftPageController = [board instantiateViewControllerWithIdentifier:@"my_main"];
    BaseNavController *leftNav = [[BaseNavController alloc] initWithRootViewController:standLeftPageController];
    standLeftPageController.standLeftSelectBlock = ^(NSInteger index) {
        [weakSelf closeDrawerAnimated:NO completion:nil];
       
        [weakSelf pushViewControllerWithIndex:index];
    };
    
    standLeftPageController.standLeftCloseBlock = ^{
        [weakSelf closeDrawerAnimated:NO completion:nil];
    };
    
    
    
    self = [super initWithCenterViewController:mainNav leftDrawerViewController:leftNav];
    if (self) {
        //设置左侧滑得最大距离
        self.maximumLeftDrawerWidth = kDeviceWidth/5*4;
        
        //设置出发打开左侧视图的手势类型
        self.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
        
        //设置关闭侧滑视图的出发手势类型
        self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
        
    }
    return self;
}



- (void)pushViewControllerWithIndex:(NSInteger)cellIndex {
    if (cellIndex == -1) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"DriverInformation" bundle:nil];
        DriverInfoController *driverInfoController = [board instantiateViewControllerWithIdentifier:@"driver_info"];
        [mainNav pushViewController:driverInfoController animated:YES];
    }else if (cellIndex == 0) {
        OrderListController *orderVc = [[OrderListController alloc] init];
        [mainNav pushViewController:orderVc animated:YES];
    }else if (cellIndex == 1) {
        
    }else if (cellIndex == 2) {
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"0913-2580118"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
    }else if (cellIndex == 3) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyInfo" bundle:nil];
        SettingViewController *settingViewController = [board instantiateViewControllerWithIdentifier:@"my_setting"];
        [mainNav pushViewController:settingViewController animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
