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
#import "DriverDetailController.h"


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
//    WiseCloudCRMAppDelegate *appDelegate = (WiseCloudCRMAppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (appDelegate.notifyMsgInfo != nil && appDelegate.notifyMsgInfo.count != 0 ) {
//        [appDelegate jumpToMessageAboutController];
//        appDelegate.notifyMsgInfo = nil;
//    }
}


- (instancetype)initStandMainMMVC {
    
    StandMainPageController *standMainPageController = [[StandMainPageController alloc] init];
    mainNav = [[BaseNavController alloc] initWithRootViewController:standMainPageController];
    __weak StandMainMMController *weakSelf = self;
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
        DriverDetailController *driverDetailController = [board instantiateViewControllerWithIdentifier:@"driver_detail"];
        [mainNav pushViewController:driverDetailController animated:YES];
    }else if (cellIndex == 0) {
        OrderListController *orderVc = [[OrderListController alloc] init];
        [mainNav pushViewController:orderVc animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
