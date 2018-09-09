//
//  PriceDeatilView.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarTypeModel.h"
#import "OrderModel.h"
#import <BaiduMapAPI_Search/BMKRouteSearch.h>

typedef void(^CloseBtnActBlock)(void);

@interface PriceDeatilView : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *despLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPriceKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPriceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


//下单时候用
@property (nonatomic, strong) NSArray *carTypeList;
@property (nonatomic, copy) NSString *carTypeValueStr;
@property (nonatomic, strong) BMKDrivingRouteLine *routeLine;

@property (nonatomic, copy) CloseBtnActBlock closeBtnActBlock;

//看详情时候用
@property (nonatomic, strong) CarTypeModel *carTypeModel;
@property (nonatomic, strong) OrderModel *orderModel;


@end
