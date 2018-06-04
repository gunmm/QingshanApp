//
//  OrderListCell.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/28.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"


@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *sendSignView;
@property (weak, nonatomic) IBOutlet UIView *reciverSignView;
@property (weak, nonatomic) IBOutlet UILabel *timeIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *reciverAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *appointTimeIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLbel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendIconTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendAddressLabelTop;

@property (nonatomic, strong) OrderModel *model;

@end
