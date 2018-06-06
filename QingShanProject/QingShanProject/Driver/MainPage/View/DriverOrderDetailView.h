//
//  DriverOrderDetailView.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/5.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import <BaiduMapAPI_Search/BMKRouteSearch.h>

typedef void(^BeginAppointOrderBlock)(void);
typedef void(^ReciverGoodsBlock)(void);
typedef void(^FinishOrderBlock)(void);


@interface DriverOrderDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payStatusBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *reciverGoodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) OrderModel *model;

@property (nonatomic, strong) BMKDrivingRouteLine *drivingRouteLine;

@property (nonatomic, copy) BeginAppointOrderBlock beginAppointOrderBlock;
@property (nonatomic, copy) ReciverGoodsBlock reciverGoodsBlock;
@property (nonatomic, copy) FinishOrderBlock finishOrderBlock;

@end
