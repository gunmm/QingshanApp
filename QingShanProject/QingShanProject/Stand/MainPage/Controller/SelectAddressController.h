//
//  SelectAddressController.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>


typedef void(^CellClickBlock)(NSString *name, NSString *address, CLLocationCoordinate2D pt);


@interface SelectAddressController : BaseViewController

@property (nonatomic, copy) CellClickBlock cellClickBlock;

@property (nonatomic, copy) NSString *beginSerchString;
@property (nonatomic, assign) CLLocationCoordinate2D beginSerchPt;
@property (nonatomic, copy) NSString *nowCityString;




@end
