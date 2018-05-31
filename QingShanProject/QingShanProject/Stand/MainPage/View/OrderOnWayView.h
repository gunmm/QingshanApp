//
//  OrderOnWayView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/24.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "OrderModel.h"
#import <BaiduMapAPI_Search/BMKRouteSearch.h>


@interface OrderOnWayView : UIView
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UILabel *plateNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *druverLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) OrderModel *orderModel;

@property (nonatomic, strong) BMKDrivingRouteLine *drivingRouteLine;





@end
