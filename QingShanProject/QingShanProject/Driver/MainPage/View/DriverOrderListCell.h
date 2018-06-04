//
//  DriverOrderListCell.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^BeginAppointOrderBlock)(OrderModel *model);
typedef void(^ReciverGoodsBlock)(OrderModel *model);
typedef void(^FinishOrderBlock)(OrderModel *model);




@interface DriverOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *createTimeIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *sendSingView;
@property (weak, nonatomic) IBOutlet UIView *reciverSignView;
@property (weak, nonatomic) IBOutlet UILabel *sendAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *reciverAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *reciveGoodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendSignViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendAddressLabelTop;


@property (nonatomic, strong) OrderModel *model;

@property (nonatomic, copy) BeginAppointOrderBlock beginAppointOrderBlock;
@property (nonatomic, copy) ReciverGoodsBlock reciverGoodsBlock;
@property (nonatomic, copy) FinishOrderBlock finishOrderBlock;




@end
