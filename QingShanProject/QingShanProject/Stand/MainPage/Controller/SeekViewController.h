//
//  SeekViewController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/18.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>


@interface SeekViewController : BaseViewController

@property (nonatomic, assign) CLLocationCoordinate2D sendPt;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, copy) NSString *orderId;


- (void)loadData;







@end
