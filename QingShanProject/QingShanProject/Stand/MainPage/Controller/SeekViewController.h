//
//  SeekViewController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/18.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

typedef void(^SeekPopBlock)(NSString *orderId, NSString *orderType);


@interface SeekViewController : BaseViewController

@property (nonatomic, assign) CLLocationCoordinate2D sendPt;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) SeekPopBlock seekPopBlock;

- (void)popActWithOrderType:(NSString *)type;







@end
