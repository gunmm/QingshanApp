//
//  DriverMainPageController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverMainPageController.h"

@interface DriverMainPageController ()

@end

@implementation DriverMainPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavBar];
}

- (void)initNavBar {

    self.title = @"司机主页面";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化按钮
    UIButton *personBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    personBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [NavBgImage showIconFontForView:personBtn iconName:@"\U0000e62f" color:mainColor font:25];
    
    [personBtn addTarget:self action:@selector(personAct) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *personItem = [[UIBarButtonItem alloc] initWithCustomView:personBtn];
    self.navigationItem.leftBarButtonItem = personItem;
}

- (void)personAct {
    if (self.driverMainPageShowLeft) {
        self.driverMainPageShowLeft();
    }
}



@end
