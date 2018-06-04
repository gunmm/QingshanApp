//
//  DriverMainPageController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^DriverMainPageShowLeft)(void);


@interface DriverMainPageController : BaseViewController

@property (nonatomic, copy) DriverMainPageShowLeft driverMainPageShowLeft;


- (void)loadDataWithAppear;


@end
