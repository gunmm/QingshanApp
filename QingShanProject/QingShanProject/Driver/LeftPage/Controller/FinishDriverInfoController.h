//
//  FinishDriverInfoController.h
//  QingShanProject
//
//  Created by gunmm on 2018/10/28.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UserModel.h"

typedef void(^MainPageRefrenshUserDataBlock)(void);


@interface FinishDriverInfoController : BaseTableViewController

@property (nonatomic, strong) UserModel *userModel;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextF;
@property (weak, nonatomic) IBOutlet UITextField *drivingLicenceTextF;
@property (weak, nonatomic) IBOutlet UITextField *specialTextF;

@property (nonatomic, copy) MainPageRefrenshUserDataBlock mainPageRefrenshUserDataBlock;

@end
