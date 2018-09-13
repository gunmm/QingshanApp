//
//  ComplainDetailController.h
//  QingShanProject
//
//  Created by gunmm on 2018/9/8.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ComplainDetailController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UILabel *complainStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *complainDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *manageManLabel;
@property (weak, nonatomic) IBOutlet UILabel *manageTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *manageDetailLabel;


@property (nonatomic, copy) NSString *complainId;
@property (nonatomic, copy) NSString *type;



- (void)loadData;


@end
