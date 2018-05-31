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
#import "DriverInfoController.h"

@interface DriverMainMMController ()
{
    BaseNavController *mainNav;
}

@end

@implementation DriverMainMMController

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
    
   
    
    
    self = [super initWithCenterViewController:mainNav leftDrawerViewController:leftNav];
    if (self) {
        //设置左侧滑得最大距离
        self.maximumLeftDrawerWidth = kDeviceWidth/5*3;
        
        //设置出发打开左侧视图的手势类型
        self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
        
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
    }else if (cellIndex == 1) {
        
    }
}






@end
