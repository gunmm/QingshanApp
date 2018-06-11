//
//  DriverMainMMController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverMainMMController.h"
#import "DriverMainPageController.h"
#import "StandLeftPageController.h"
#import "BaseNavController.h"
#import "DriverDetailController.h"
#import "DriverOrderListController.h"
#import "AppDelegate.h"

@interface DriverMainMMController ()
{
    BaseNavController *mainNav;
}

@end

@implementation DriverMainMMController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (instancetype)initDriverMainMMVC {
    
    DriverMainPageController *driverMainPageController = [[DriverMainPageController alloc] init];
    mainNav = [[BaseNavController alloc] initWithRootViewController:driverMainPageController];
    __weak DriverMainMMController *weakSelf = self;
    driverMainPageController.driverMainPageShowLeft = ^{
        [weakSelf openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
    };
    
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyInfo" bundle:nil];
    StandLeftPageController *standLeftPageController = [board instantiateViewControllerWithIdentifier:@"my_main"];
    standLeftPageController.isDriver = YES;
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
        self.maximumLeftDrawerWidth = kDeviceWidth/5*3;
        
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
        DriverDetailController *driverDetailController = [board instantiateViewControllerWithIdentifier:@"driver_detail"];
        [mainNav pushViewController:driverDetailController animated:YES];

    }else if (cellIndex == 0) {
        DriverOrderListController *driverOrderListController = [[DriverOrderListController alloc] init];
        [mainNav pushViewController:driverOrderListController animated:YES];
    }
}






@end
