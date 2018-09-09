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

typedef void(^CancelOrderBlock)(void);
typedef void(^ServicePayOrderBlock)(void);
typedef void(^OrderTimeOutBlock)(void);

typedef void(^ComplainBlock)(void);
typedef void(^CommentBlock)(void);






@interface DriverOrderDetailView : UIView
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@property (weak, nonatomic) IBOutlet UIButton *reciveNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *reciveCallBtn;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payStatusBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *reciverGoodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *serviceFeeBgView;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *serviceFeeBtnBgView;
@property (weak, nonatomic) IBOutlet UIButton *cancleOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@property (weak, nonatomic) IBOutlet UIButton *complainBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;







@property (nonatomic, strong) OrderModel *model;

@property (nonatomic, strong) BMKDrivingRouteLine *drivingRouteLine;

@property (nonatomic, copy) BeginAppointOrderBlock beginAppointOrderBlock;
@property (nonatomic, copy) ReciverGoodsBlock reciverGoodsBlock;
@property (nonatomic, copy) FinishOrderBlock finishOrderBlock;

@property (nonatomic, copy) CancelOrderBlock cancelOrderBlock;
@property (nonatomic, copy) ServicePayOrderBlock servicePayOrderBlock;
@property (nonatomic, copy) OrderTimeOutBlock orderTimeOutBlock;

@property (nonatomic, copy) ComplainBlock complainBlock;
@property (nonatomic, copy) CommentBlock commentBlock;






@property (nonatomic, copy) NSTimer *timer;



@end
