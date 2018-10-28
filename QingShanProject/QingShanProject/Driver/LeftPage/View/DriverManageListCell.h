//
//  DriverManageListCell.h
//  QingShanProject
//
//  Created by gunmm on 2018/10/14.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

typedef void(^PointBtnActBlock)(UserModel *pointUserModel);

@interface DriverManageListCell : UITableViewCell

@property (nonatomic, strong) UserModel *model;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *pointBtn;


@property (nonatomic, copy) PointBtnActBlock pointBtnActBlock;

@property (nonatomic, assign) BOOL isUnBindPage;

@end
