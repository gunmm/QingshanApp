//
//  DriverOnWayController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/24.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"



@interface DriverOnWayController : BaseViewController

@property (nonatomic, copy) NSString *orderId;

- (void)loadData;


@end
