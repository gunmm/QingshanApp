//
//  DriverListController.h
//  QingShanProject
//
//  Created by gunmm on 2018/10/14.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ManageListRefrenshBlock)(void);

@interface DriverListController : BaseViewController

@property (nonatomic, copy) ManageListRefrenshBlock manageListRefrenshBlock;


@end
