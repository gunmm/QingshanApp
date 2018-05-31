//
//  DriverInfoController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/29.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UserModel.h"

@interface DriverInfoController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextF;

@property (weak, nonatomic) IBOutlet UIImageView *card1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *card2ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *card3ImageView;
@property (weak, nonatomic) IBOutlet UITextField *carTypeTextF;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextF;


@property (nonatomic, strong) UserModel *userModel;

@end