//
//  AddOrderController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>


typedef void(^DismissBlock)(CLLocationCoordinate2D pt, long long createTime, NSString *orderId);
typedef void(^BackDismissBlock)(void);



@interface AddOrderController : BaseViewController


@property (nonatomic, copy) NSString *sendAddress;
@property (nonatomic, copy) NSString *receiveAddress;

@property (nonatomic, assign) CLLocationCoordinate2D sendPt;
@property (nonatomic, assign) CLLocationCoordinate2D receivePt;

@property (nonatomic, copy) NSString *sendDetailAddress;
@property (nonatomic, copy) NSString *receiveDetailAddress;

@property (nonatomic, assign) BOOL isNow;

@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, copy) BackDismissBlock backDismissBlock;







@end
