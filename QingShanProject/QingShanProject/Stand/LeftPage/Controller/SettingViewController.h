//
//  SettingViewController.h
//  QingShanProject
//
//  Created by gunmm on 2018/8/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SettingViewController : BaseTableViewController

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageAgeLabel;

@end
