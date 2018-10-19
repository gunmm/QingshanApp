//
//  StandLeftPageController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void(^StandLeftSelectBlock)(NSInteger index);
typedef void(^StandLeftCloseBlock)(void);


@interface StandLeftPageController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UILabel *orderIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverManageIconLabel;


@property (nonatomic, copy) StandLeftSelectBlock standLeftSelectBlock;
@property (nonatomic, copy) StandLeftCloseBlock standLeftCloseBlock;



@property (nonatomic, assign) BOOL isDriver;

@end
