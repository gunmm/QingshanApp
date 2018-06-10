//
//  RobOrderController.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/10.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^RobSuccessBlock)(NSString *orderId);

@interface RobOrderController : BaseViewController

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) RobSuccessBlock robSuccessBlock;



@end
