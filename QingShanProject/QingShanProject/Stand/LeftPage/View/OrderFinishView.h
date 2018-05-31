//
//  OrderFinishView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/29.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderFinishView : UIView

@property (nonatomic, strong) OrderModel *model;

@property (weak, nonatomic) IBOutlet UILabel *plateNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *driverBtn;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *complaintBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabl;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
