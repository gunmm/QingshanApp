//
//  DriverOnWayController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/24.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

typedef void(^OrderCompleteBlock)(OrderModel *model);


@interface DriverOnWayController : BaseViewController

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) OrderCompleteBlock orderCompleteBlock;



- (void)loadData;


@end
