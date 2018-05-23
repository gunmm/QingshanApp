//
//  DriverMainMMController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverMainMMController.h"
#import "DriverMainPageController.h"
#import "DriverLeftPageController.h"
#import "BaseNavController.h"

@interface DriverMainMMController ()

@end

@implementation DriverMainMMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (instancetype)initDriverMainMMVC {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyInfo" bundle:nil];
    UIViewController *standLeftPageController = [board instantiateViewControllerWithIdentifier:@"my_main"];
    BaseNavController *leftNav = [[BaseNavController alloc] initWithRootViewController:standLeftPageController];
//    DriverLeftPageController *driverLeftPageController = [[DriverLeftPageController alloc] init];
//    BaseNavController *leftNav = [[BaseNavController alloc] initWithRootViewController:driverLeftPageController];
    DriverMainPageController *driverMainPageController = [[DriverMainPageController alloc] init];
    BaseNavController *mainNav = [[BaseNavController alloc] initWithRootViewController:driverMainPageController];

    
    
    __weak DriverMainMMController *weakSelf = self;
    driverMainPageController.driverMainPageShowLeft = ^{
        [weakSelf openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
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






@end
