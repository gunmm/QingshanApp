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

@interface StandMainMMController ()
{

}


@end

@implementation StandMainMMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (instancetype)initStandMainMMVC {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyInfo" bundle:nil];
    UIViewController *standLeftPageController = [board instantiateViewControllerWithIdentifier:@"my_main"];
    BaseNavController *leftNav = [[BaseNavController alloc] initWithRootViewController:standLeftPageController];
    StandMainPageController *standMainPageController = [[StandMainPageController alloc] init];
    BaseNavController *mainNav = [[BaseNavController alloc] initWithRootViewController:standMainPageController];
    
    
    __weak StandMainMMController *weakSelf = self;
    standMainPageController.standMainPageShowLeft = ^{
        [weakSelf openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
