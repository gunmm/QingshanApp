//
//  DriverInfoController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/29.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UserModel.h"

typedef void(^InfoEditBlock)(void);

@interface DriverInfoController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextF;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextF;
@property (weak, nonatomic) IBOutlet UITextField *belongSiteTextF;
@property (weak, nonatomic) IBOutlet UITextField *scoreTextF;
@property (weak, nonatomic) IBOutlet UITextField *bankCardTextF;


@property (weak, nonatomic) IBOutlet UILabel *plateNumberKeyLabel;


@property (weak, nonatomic) IBOutlet UITextField *plateNumberTextF;
@property (weak, nonatomic) IBOutlet UITextField *carTypeTextF;
@property (weak, nonatomic) IBOutlet UITextField *gpsTypeTextF;
@property (weak, nonatomic) IBOutlet UITextField *gpsNumberTextF;

@property (weak, nonatomic) IBOutlet UIButton *editBankBtn;




@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, copy) InfoEditBlock infoEditBlock;


@end
