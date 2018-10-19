//
//  DriverDetailController.h
//  QingShanProject
//
//  Created by gunmm on 2018/10/17.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UserModel.h"

typedef void(^RefreshDriverBlock)(void);


@interface DriverDetailController : BaseTableViewController

@property (weak, nonatomic) IBOutlet UIImageView *driverImageView;
@property (weak, nonatomic) IBOutlet UILabel *driverNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *driverPhoneBtn;
@property (weak, nonatomic) IBOutlet UITextField *driverIdCardLabel;
@property (weak, nonatomic) IBOutlet UITextField *driverLicenseLabel;
@property (weak, nonatomic) IBOutlet UITextField *driverQualificationLabel;
@property (weak, nonatomic) IBOutlet UITextField *driverScoreLabel;

@property (nonatomic, strong) UserModel *model;

@property (nonatomic, copy) RefreshDriverBlock refreshDriverBlock;



@end
