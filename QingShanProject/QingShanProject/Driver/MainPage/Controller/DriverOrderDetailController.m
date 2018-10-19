//
//  DriverOrderDetailController.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/5.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverOrderDetailController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "FinishOrderRes.h"
#import "DriverOrderDetailView.h"
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPolylineView.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "UIImage+Rotate.h"
#import "RouteAnnotation.h"
#import "JZLocationConverter.h"
#import <MapKit/MKMapItem.h>
#import <MapKit/MKTypes.h>
#import "PayDetailView.h"
#import "ComplaintView.h"
#import "CommentView.h"
#import "ComplainDetailController.h"






#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]



@interface DriverOrderDetailController () <BMKMapViewDelegate, BMKRouteSearchDelegate, BMKLocationServiceDelegate>
{
    BMKLocationService *_locService;
}

@property (strong, nonatomic) BMKMapView *mapView;
@property (nonatomic, strong) OrderModel *model;
@property (nonatomic, strong) DriverOrderDetailView *driverOrderDetailView;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger nowCount;

@property (strong, nonatomic) UIBarButtonItem *daohaongBtn;


@property (strong, nonatomic) CustomIOS7AlertView *customIOS7AlertView;






@end

@implementation DriverOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    [self firstLoadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _locService.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
    [_timer invalidate];

}
- (void)initNavBar {
    self.title = @"订单详情";
    self.view.backgroundColor = bgColor;
    _daohaongBtn = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(daohangBtnClicked)];
    [_daohaongBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
//    [self.navigationItem setRightBarButtonItem:_daohaongBtn];
}

- (void)daohangBtnClicked {
    __weak typeof(self) weakSelf = self;

    NSMutableArray *titleArray = [NSMutableArray array];
    [titleArray addObject:@"苹果地图"];
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        [titleArray addObject:@"百度地图"];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        [titleArray addObject:@"高德地图"];
    }
    
    [[CustomSelectAlertView alloc] initAlertWithTitleArray:[titleArray mutableCopy] withBtnSelectBlock:^(NSInteger tagg) {
        if (tagg == titleArray.count+1) {
            return;
        }
        NSString *str = titleArray[tagg - 1];
        if ([str isEqualToString:@"苹果地图"]) {
            CLLocationCoordinate2D coor;
            
            if ([weakSelf.model.status isEqualToString:@"1"]) {
                coor.latitude =  weakSelf.model.sendLatitude;
                coor.longitude =  weakSelf.model.sendLongitude;
            }else {
                coor.latitude =  weakSelf.model.receiveLatitude;
                coor.longitude =  weakSelf.model.receiveLongitude;
            }
            
            
            CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:coor];
            
            MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
            NSArray *items = @[currentLoc,toLocation];
            NSDictionary *dic = @{
                                  MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                                  MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                                  MKLaunchOptionsShowsTrafficKey : @(YES)
                                  };
            
            [MKMapItem openMapsWithItems:items launchOptions:dic];
        }else if ([str isEqualToString:@"百度地图"]){
            NSString *urlString = @"";;
            
            if ([weakSelf.model.status isEqualToString:@"2"]) {
                urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving",
                              weakSelf.model.sendLatitude, weakSelf.model.sendLongitude, weakSelf.model.sendAddress]
                             stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }else {
                urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving",
                              weakSelf.model.receiveLatitude, weakSelf.model.receiveLongitude, weakSelf.model.receiveAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {}];
        }else if ([str isEqualToString:@"高德地图"]){
            CLLocationCoordinate2D coor;
            
            if ([weakSelf.model.status isEqualToString:@"2"]) {
                coor.latitude =  weakSelf.model.sendLatitude;
                coor.longitude =  weakSelf.model.sendLongitude;
            }else {
                coor.latitude =  weakSelf.model.receiveLatitude;
                coor.longitude =  weakSelf.model.receiveLongitude;
            }
            
            
            CLLocationCoordinate2D gcj = [JZLocationConverter bd09ToGcj02:coor];
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",
                                    @"导航功能", [weakSelf.model.status isEqualToString:@"1"] ? weakSelf.model.sendAddress : weakSelf.model.receiveAddress, gcj.latitude, gcj.longitude]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {}];
        }
    }];
}

- (void)initView {
    [self initMapView];
    [self initDetailView];
}

- (void)firstLoadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.orderId forKey:@"orderId"];
    [NetWorking postDataWithParameters:param withUrl:@"getBigOrderInfo" withBlock:^(id result) {
        FinishOrderRes *finishOrderRes = [FinishOrderRes mj_objectWithKeyValues:result];
        self.model = finishOrderRes.object;
        [self setView];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.orderId forKey:@"orderId"];
    [NetWorking bgPostDataWithParameters:param withUrl:@"getBigOrderInfo" withBlock:^(id result) {
        FinishOrderRes *finishOrderRes = [FinishOrderRes mj_objectWithKeyValues:result];
        self.model = finishOrderRes.object;
        [self setView];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)setView {
    if (self.model.orderId.length == 0) {
        [HUDClass showHUDWithText:@"订单不存在！"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    _driverOrderDetailView.model = self.model;
    
    if ([_model.status isEqualToString:@"1"]) {//已抢单
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
        [self.navigationItem setRightBarButtonItem:nil];
        
    }else if ([_model.status isEqualToString:@"2"]) { //已接单
        if ([_model.appointStatus isEqualToString:@"0"]) {
            [self addPointForMap];
            [_timer invalidate];
            [self.navigationItem setRightBarButtonItem:nil];
        }else{
            [self routePlan];
            [self startLocation];
            [_timer invalidate];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
            [self.navigationItem setRightBarButtonItem:self.daohaongBtn];
        }
        
    }else if ([_model.status isEqualToString:@"3"]){ //运送中
        [self routePlan];
        [self startLocation];
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
        [self.navigationItem setRightBarButtonItem:self.daohaongBtn];

    }else if ([_model.status isEqualToString:@"4"] || [_model.status isEqualToString:@"9"] || [_model.status isEqualToString:@"8"]){ //已完成 或者已取消  或者被司机要投诉
        [self addPointForMap];
        [_timer invalidate];
        [self.navigationItem setRightBarButtonItem:nil];
    }
}

- (void)timerAct {
    _nowCount ++;
    if (_nowCount > 30) {
        [self loadData];
        _nowCount = 0;
    }
}

- (void)addPointForMap {
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    
    BMKPointAnnotation *sendPointAnnotation = [[BMKPointAnnotation alloc] init];
    sendPointAnnotation.coordinate = CLLocationCoordinate2DMake(_model.sendLatitude, _model.sendLongitude);
    sendPointAnnotation.title = @"发货位置";
    [_mapView addAnnotation:sendPointAnnotation];
    
    BMKPointAnnotation *reciverPointAnnotation = [[BMKPointAnnotation alloc] init];
    reciverPointAnnotation.coordinate = CLLocationCoordinate2DMake(_model.receiveLatitude, _model.receiveLongitude);
    reciverPointAnnotation.title = @"收货位置";
    [_mapView addAnnotation:reciverPointAnnotation];
    
    CGFloat zoom = [self BMapSetPointCenterWithPoint11:sendPointAnnotation.coordinate withPoint2:reciverPointAnnotation.coordinate];
    CLLocationCoordinate2D center = [self BMapGetCenterWithPoint11:sendPointAnnotation.coordinate withPoint2:reciverPointAnnotation.coordinate];
    
    _mapView.zoomLevel = zoom;
    [_mapView setCenterCoordinate:center animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mapView.zoomLevel = zoom;
        [self.mapView setCenterCoordinate:center animated:YES];
        
    });
    
}

- (void)initDetailView {
    _driverOrderDetailView = [[[NSBundle mainBundle] loadNibNamed:@"DriverOrderDetailView" owner:nil options:nil] lastObject];
    _driverOrderDetailView.frame = CGRectMake(0, 0, kDeviceWidth-10, 281);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, _mapView.bottom+5, kDeviceWidth-10, 281)];
    [self.view addSubview:bgView];
    
    [bgView addSubview:_driverOrderDetailView];
    
    __weak typeof(self) weakSelf = self;

    _driverOrderDetailView.beginAppointOrderBlock = ^{
        [weakSelf beginAppointOrder];
    };
    
    _driverOrderDetailView.reciverGoodsBlock = ^{
        [weakSelf updateOrderWithStatus:@"3"];
    };
    
    _driverOrderDetailView.finishOrderBlock = ^{
        [weakSelf updateOrderWithStatus:@"4"];
    };
    
    _driverOrderDetailView.servicePayOrderBlock = ^{
        [weakSelf servicePayBlockAct];
    };
    
    _driverOrderDetailView.cancelOrderBlock = ^{
        [weakSelf cancelBlockAct];
    };
    
    _driverOrderDetailView.orderTimeOutBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    _driverOrderDetailView.complainBlock = ^{
        if (weakSelf.model.driverComplaintId.length > 0) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"StandBoard" bundle:nil];
            ComplainDetailController *complainDetailController = [board instantiateViewControllerWithIdentifier:@"stand_complain"];
            complainDetailController.complainId = weakSelf.model.driverComplaintId;
            complainDetailController.type = @"2";
            [weakSelf.navigationController pushViewController:complainDetailController animated:YES];
        }else {
            [weakSelf complainBlockAct];
        }
    };
    _driverOrderDetailView.commentBlock = ^{
        [weakSelf commentBlockAct];
    };
    
    
}

- (void)complainBlockAct {
    
    [AlertView alertViewWithTitle:@"提示" withMessage:@"发起投诉后订单会被置为投诉状态，平台介入处理核实信息后会进行退费或处罚操作" withConfirmTitle:@"继续投诉" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        ComplaintView *complaintView = [[[NSBundle mainBundle] loadNibNamed:@"ComplaintView" owner:nil options:nil] lastObject];
        complaintView.frame = CGRectMake(0, 0, kDeviceWidth, 239+TABBAR_BOTTOM_HEIGHT);
        complaintView.closeBtnActBlock = ^{
            [self.customIOS7AlertView close];
        };
        
        complaintView.submitBtnActBlock = ^(NSString *contentStr) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:[[Config shareConfig] getUserId] forKey:@"createManId"];
            [param setObject:self.orderId forKey:@"orderId"];
            [param setObject:@"2" forKey:@"type"];
            [param setObject:contentStr forKey:@"note"];
            
            [NetWorking postDataWithParameters:param withUrl:@"addComplain" withBlock:^(id result) {
                [HUDClass showHUDWithText:@"投诉成功！系统会在五个工作日内处理"];
                [self.customIOS7AlertView close];
                [self loadData];
            } withFailedBlock:^(NSString *errorResult) {
                
            }];
        };
        
        
        
        self.customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
        self.customIOS7AlertView.tapClose = NO;
        [self.customIOS7AlertView setButtonTitles:nil];
        [self.customIOS7AlertView setContainerView:complaintView];
        [self.customIOS7AlertView showFromBottom];
    } withCancelBlock:^{
        
    }];
   
}

- (void)commentBlockAct {
    CommentView *commentView = [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:nil options:nil] lastObject];
    commentView.isDriver = YES;
    commentView.model = self.model;
    commentView.frame = CGRectMake(0, 0, kDeviceWidth, 303+TABBAR_BOTTOM_HEIGHT);
    commentView.closeBtnActBlock = ^{
        [self.customIOS7AlertView close];
    };
    
    commentView.commitBtnActBlock = ^(NSInteger starNumber, NSString *contentStr) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.orderId forKey:@"orderId"];
        [param setObject:[NSNumber numberWithInteger:starNumber] forKey:@"driverCommentStar"];
        [param setObject:contentStr forKey:@"driverCommentContent"];
        
        [NetWorking postDataWithParameters:param withUrl:@"driverCommentOrder" withBlock:^(id result) {
            [HUDClass showHUDWithText:@"评价成功，感谢评价！"];
            [self.customIOS7AlertView close];
            [self loadData];
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    };
    
    
    self.customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
    self.customIOS7AlertView.tapClose = NO;
    [self.customIOS7AlertView setButtonTitles:nil];
    [self.customIOS7AlertView setContainerView:commentView];
    [self.customIOS7AlertView showFromBottom];
}

- (void)servicePayBlockAct {
    
    PayDetailView *payDetailView = [[[NSBundle mainBundle] loadNibNamed:@"PayDetailView" owner:nil options:nil] lastObject];
    payDetailView.frame = CGRectMake(0, 0, kDeviceWidth, 256+TABBAR_BOTTOM_HEIGHT);
    self.customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
    [self.customIOS7AlertView setButtonTitles:nil];
    [self.customIOS7AlertView setContainerView:payDetailView];
    [self.customIOS7AlertView showFromBottom];
    CGFloat serviceFee = self.model.price * 0.03;
    if (serviceFee > 300) {
        serviceFee = 300;
    }
    payDetailView.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", serviceFee];
    
    __weak typeof(self) weakSelf = self;
    payDetailView.payBtnActBlock = ^(NSString *payType) {
        [weakSelf.customIOS7AlertView close];
        CGFloat serviceFee = weakSelf.model.price * 0.03;
        if (serviceFee > 300) {
            serviceFee = 300;
        }
        if ([payType isEqualToString:@"1"]) {
            //跳转支付宝支付
            
            [weakSelf servicePayWithPayType:@"1" withPayId:@"zfb-zfid-0002"];
        }else if ([payType isEqualToString:@"2"]) {
            //跳转微信支付
            [weakSelf servicePayWithPayType:@"2" withPayId:@"wx-wxid-0002"];
        }
    };
}

- (void)servicePayWithPayType:(NSString *)type withPayId:(NSString *)payId {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.model.orderId forKey:@"orderId"];
    [param setObject:type forKey:@"serviceFeePayType"];
    [param setObject:payId forKey:@"serviceFeePayId"];
    
    [NetWorking postDataWithParameters:param withUrl:@"driverPayOrderServiceFee" withBlock:^(id result) {
        [self loadData];
        self.nowCount = 0;
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)cancelBlockAct {
    [AlertView alertViewWithTitle:@"提示" withMessage:@"确认放弃该订单\n 取消已抢到的订单\n会导致\n信用分降低" withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
        [param setObject:self.model.orderId forKey:@"orderId"];
        
        [NetWorking postDataWithParameters:param withUrl:@"driverGiveUpOrder" withBlock:^(id result) {
            [self.navigationController popViewControllerAnimated:YES];
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    } withCancelBlock:^{
        
    }];
}

- (void)beginAppointOrder {
    [AlertView alertViewWithTitle:@"提示" withMessage:@"确认开始执行该预约订单" withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
        [param setObject:self.model.orderId forKey:@"orderId"];
        
        [NetWorking postDataWithParameters:param withUrl:@"setAppointOrderBegin" withBlock:^(id result) {
            [self loadData];
            self.nowCount = 0;
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    } withCancelBlock:^{
        
    }];
    
}


- (void)updateOrderWithStatus:(NSString *)status {
    
    [AlertView alertViewWithTitle:@"提示" withMessage:[NSString stringWithFormat:@"%@", [status isEqualToString:@"3"] ? @"确认接到货物" : @"确认订单完成"] withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.model.orderId forKey:@"orderId"];
        [param setObject:status forKey:@"status"];
        
        [NetWorking postDataWithParameters:param withUrl:@"updateOrderStatus" withBlock:^(id result) {
            [self loadData];
            self.nowCount = 0;


        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    } withCancelBlock:^{
        
    }];
    
}

- (void)initMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT-291-TABBAR_BOTTOM_HEIGHT)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    _mapView.showMapScaleBar = YES;
    [self.view addSubview:_mapView];
    
    _locService = [[BMKLocationService alloc] init];

}


#pragma mark-------BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation *)annotation];
    }
    
    if ([annotation.title isEqualToString:@"发货位置"]) {
        BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location2"];
        annotationView.image = [UIImage imageNamed:@"begin"];
        annotationView.centerOffset = CGPointMake(0, -20);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, 50, 100, 0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _model.sendAddress;
        label.font = [UIFont boldSystemFontOfSize:12];
        [label sizeToFit];
        label.left = -label.width/2+16.5;
        [annotationView addSubview:label];
        return annotationView;
    }else if ([annotation.title isEqualToString:@"收货位置"]) {
        BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location2"];
        annotationView.image = [UIImage imageNamed:@"end"];
        annotationView.centerOffset = CGPointMake(0, -20);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, 50, 100, 0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _model.receiveAddress;
        label.font = [UIFont boldSystemFontOfSize:12];
        [label sizeToFit];
        label.left = -label.width/2+16.5;
        [annotationView addSubview:label];
        return annotationView;
    }
    
    return [mapView viewForAnnotation:annotation];
}

- (CGFloat)BMapSetPointCenterWithPoint11:(CLLocationCoordinate2D)point1 withPoint2:(CLLocationCoordinate2D)point2 {
    int zoom = 13;
    
    int zooms[] = {50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 25000, 50000,
        100000, 200000, 500000, 1000000, 2000000};
    BMKMapPoint dPoint1 = BMKMapPointForCoordinate(point1);
    BMKMapPoint dPoint2 = BMKMapPointForCoordinate(point2);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(dPoint1, dPoint2);
    
    for (int i = 0; i < 16; i++) {
        if ((zooms[i] - distance) > 0) {
            zoom = 18 - i + 2;
            break;
        }
    }
    return zoom;
    
}

- (CLLocationCoordinate2D)BMapGetCenterWithPoint11:(CLLocationCoordinate2D)point1 withPoint2:(CLLocationCoordinate2D)point2 {
    double lat1 = point1.latitude;
    double lng1 = point1.longitude;
    
    double lat2 = point2.latitude;
    double lng2 = point2.longitude;
    
    double pointLng = (lng1 + lng2) / 2;
    double pointLat = (lat1 + lat2) / 2;
    
    
    return CLLocationCoordinate2DMake(pointLat, pointLng);
}


#pragma mark------地图代理
////开始定位
- (void)startLocation {
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 *此时结束定位，只获取一次用户位置信息
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    
    
    [_mapView updateLocationData:userLocation];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    //结束定位
    [_locService stopUserLocationService];
    
}




- (void)routePlan
{
    BMKRouteSearch *routeSearch = [[BMKRouteSearch alloc] init];
    routeSearch.delegate = self;

    BMKDrivingRoutePlanOption *options = [[BMKDrivingRoutePlanOption alloc] init];

    options.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;

    BMKPlanNode *start = [[BMKPlanNode alloc] init];

    start.pt = CLLocationCoordinate2DMake(_model.nowLatitude, _model.nowLongitude);;

    BMKPlanNode *end = [[BMKPlanNode alloc] init];

    CLLocationCoordinate2D endCor;
    if ([_model.status isEqualToString:@"2"]) {
        endCor = CLLocationCoordinate2DMake(_model.sendLatitude, _model.sendLongitude);
    }else {
        endCor = CLLocationCoordinate2DMake(_model.receiveLatitude, _model.receiveLongitude);
    }

    end.pt = endCor;
    options.from = start;
    options.to = end;

    BOOL suc = [routeSearch drivingSearch:options];

    if (suc) {
        NSLog(@"路线查找成功");
    }

}

#pragma mark - BMKRouteSearchDelegate

- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    searcher.delegate = nil;

    if (error == BMK_SEARCH_NO_ERROR) {
        if (result.routes.count > 0) {
            BMKDrivingRouteLine *drivingRouteLine = result.routes[0];
            _driverOrderDetailView.drivingRouteLine = drivingRouteLine;
            [self addLineWithPlan:drivingRouteLine];
        }

    } else {
        NSLog(@"error code:%u", error);
        [self addPointForMap];
    }
}


#pragma mark 根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
}


- (void)addLineWithPlan:(BMKDrivingRouteLine *)plan {
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    // 计算路线方案中的路段数目
    int size = (int)[plan.steps count];

    int planPointCounts = 0;

    for (int i = 0; i < size; i++) {
        //表示驾车路线中的一个路段
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];


        if(0 == i) {
            RouteAnnotation *item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.starting.location;
            item.title = @"司机位置";
            item.degree = transitStep.direction * 30;
            item.type = 0;
            [_mapView addAnnotation:item]; // 添加起点标注
        }else if (i == size - 1) {
            RouteAnnotation *item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.terminal.location;
            item.type = 1;
            if ([_model.status isEqualToString:@"2"]) {
                item.title = @"发货位置";
            }else {
                item.title = @"收货位置";
            }
            [_mapView addAnnotation:item]; // 添加终点标注
        }

        //添加annotation节点
        RouteAnnotation* item = [[RouteAnnotation alloc]init];
        item.coordinate = transitStep.entrace.location;
        item.title = transitStep.entraceInstruction;
        item.degree = transitStep.direction * 30;
        item.type = 4;
        [_mapView addAnnotation:item];

        //轨迹点总数累计
        planPointCounts += transitStep.pointsCount;
    }

    //添加途经点
    if (plan.wayPoints) {
        for (BMKPlanNode *tempNode in plan.wayPoints) {
            RouteAnnotation *item = [[RouteAnnotation alloc]init];
            item.coordinate = tempNode.pt;
            item.type = 5;
            item.title = tempNode.name;
            [_mapView addAnnotation:item];
        }
    }
    //轨迹点
    BMKMapPoint tempPoints[planPointCounts];

    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKDrivingStep *transitStep = [plan.steps objectAtIndex:j];
        int k = 0;
        for(k = 0; k < transitStep.pointsCount; k++) {
            tempPoints[i].x = transitStep.points[k].x;
            tempPoints[i].y = transitStep.points[k].y;
            i++;
        }
    }
    // 通过points构建BMKPolyline
    BMKPolyline *polyLine = [BMKPolyline polylineWithPoints:tempPoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay

    [self mapViewFitPolyLine:polyLine];
}


#pragma mark  根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *)polyLine
{
    CGFloat ltX, ltY, rbX, rbY;

    if (polyLine.pointCount < 1) {
        return;
    }

    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x;
    ltY = pt.y;
    rbX = pt.x;
    rbY = pt.y;

    for (int i = 0; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;

    rect.origin = BMKMapPointMake(ltX , ltY);

    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);

    [_mapView setVisibleMapRect:rect];

    _mapView.zoomLevel = _mapView.zoomLevel - 0.8;
}


#pragma mark 获取路线的标注，显示到地图
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation {

    BMKAnnotationView *view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];

            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                UIImage *image = [[UIImage imageNamed:@"icon_driver_car"] imageRotatedByDegrees:routeAnnotation.degree];

                view.image = image;
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));

                view.canShowCallout = true;
                view.clipsToBounds = NO;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"start_annotation"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = true;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = true;
            } else {
                [view setNeedsDisplay];
            }
            UIImage *image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    return view;
}

- (NSString*)getMyBundlePath1:(NSString *)filename {

    NSBundle * libBundle = MYBUNDLE;
    if ( libBundle && filename ) {
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent:filename];
        return s;
    }
    return nil ;
}


@end
