//
//  StandLeftPageController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void(^StandLeftSelectBlock)(NSInteger index);

@interface StandLeftPageController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UILabel *orderIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingIconLabel;


@property (nonatomic, copy) StandLeftSelectBlock standLeftSelectBlock;


@property (nonatomic, assign) BOOL isDriver;

@end
