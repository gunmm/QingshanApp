//
//  DriverOnWayController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/24.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverOnWayController.h"
#import "OrderByIdRes.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "OrderOnWayView.h"
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPolylineView.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

#import "UIImage+Rotate.h"
#import "RouteAnnotation.h"




#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]





@interface DriverOnWayController () <BMKMapViewDelegate, BMKRouteSearchDelegate, BMKLocationServiceDelegate>
{
    
    BMKLocationService *_locService;

}

@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) UserModel *driverModel;
@property (strong, nonatomic) OrderModel *orderModel;
@property (strong, nonatomic) OrderOnWayView *orderOnWayView;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger nowCount;






@end

@implementation DriverOnWayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavBarWithStatus:@""];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    _locService.delegate = self;


    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];

    
    [self loadAppearData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    _locService.delegate = nil;

    [_timer invalidate];

}

- (void)timerAct {
    _nowCount ++;
    if (_nowCount > 30) {
        [self loadData];
        _nowCount = 0;
    }
}

- (void)initNavBarWithStatus:(NSString *)status {
    
    if ([status isEqualToString:@"1"]) {
        self.title = @"等待接货";
        UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClicked)];
        [cancleBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [self.navigationItem setRightBarButtonItem:cancleBtn];
    }else if([status isEqualToString:@"2"]){
        self.title = @"运送中";
        [self.navigationItem setRightBarButtonItem:nil];
    }else {
        self.title = @"订单状态";
        [self.navigationItem setRightBarButtonItem:nil];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
}

- (void)cancelBtnClicked {
    [AlertView alertViewWithTitle:@"提示" withMessage:@"确认取消订单" withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.orderId forKey:@"orderId"];
        
        [NetWorking postDataWithParameters:param withUrl:@"cancelOrder" withBlock:^(id result) {
            [HUDClass showHUDWithText:@"订单取消成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    } withCancelBlock:^{
        
    }];
    
}

- (void)loadAppearData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.orderId forKey:@"orderId"];
    
    [NetWorking postDataWithParameters:param withUrl:@"getOnWayOrder" withBlock:^(id result) {
        OrderByIdRes *orderByIdRes = [OrderByIdRes mj_objectWithKeyValues:result];
        self.driverModel = orderByIdRes.object.driver;
        self.orderModel = orderByIdRes.object.order;
        if ([self.orderModel.status isEqualToString:@"3"]) {
            [HUDClass showHUDWithText:@"订单完成！"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.orderOnWayView.userModel = orderByIdRes.object.driver;
        self.orderOnWayView.orderModel = orderByIdRes.object.order;
        [self routePlan];
        

        [self initNavBarWithStatus:self.orderModel.status];


    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.orderId forKey:@"orderId"];
    [NetWorking bgPostDataWithParameters:param withUrl:@"getOnWayOrder" withBlock:^(id result) {
        [self startLocation];

        OrderByIdRes *orderByIdRes = [OrderByIdRes mj_objectWithKeyValues:result];
        self.driverModel = orderByIdRes.object.driver;
        self.orderModel = orderByIdRes.object.order;
        
        if ([self.orderModel.status isEqualToString:@"3"]) {
            [self.timer invalidate];
            self.orderModel.phoneNumber = self.driverModel.phoneNumber;
            self.orderModel.nickname = self.driverModel.nickname;
            self.orderModel.personImageUrl = self.driverModel.personImageUrl;
            self.orderModel.nowLatitude = self.driverModel.nowLatitude;
            self.orderModel.nowLongitude = self.driverModel.nowLongitude;
            self.orderModel.plateNumber = self.driverModel.plateNumber;
            self.orderModel.score = self.driverModel.score;
        
            [self.navigationController popViewControllerAnimated:YES];
            if (self.orderCompleteBlock) {
                self.orderCompleteBlock(self.orderModel);
            }
            return;
        }
        
        self.orderOnWayView.userModel = orderByIdRes.object.driver;
        self.orderOnWayView.orderModel = orderByIdRes.object.order;
        [self routePlan];
        [self initNavBarWithStatus:self.orderModel.status];

    } withFailedBlock:^(NSString *errorResult) {
        
    }];
   
}

- (void)addMapAnno {
    BMKPointAnnotation *driverPointAnnotation = [[BMKPointAnnotation alloc]init];
    driverPointAnnotation.coordinate = CLLocationCoordinate2DMake(_driverModel.nowLatitude, _driverModel.nowLongitude);
    driverPointAnnotation.title = @"司机位置";
    [_mapView addAnnotation:driverPointAnnotation];
    
    BMKPointAnnotation *sendPointAnnotation = [[BMKPointAnnotation alloc]init];
   
    
    
    if ([_orderModel.status isEqualToString:@"1"]) {
        sendPointAnnotation.coordinate = CLLocationCoordinate2DMake(_orderModel.sendLatitude, _orderModel.sendLongitude);
        sendPointAnnotation.title = @"发货位置";
    }else if ([_orderModel.status isEqualToString:@"2"]) {
        sendPointAnnotation.coordinate = CLLocationCoordinate2DMake(_orderModel.receiveLatitude, _orderModel.receiveLongitude);
        sendPointAnnotation.title = @"收货位置";
    }
    [_mapView addAnnotation:sendPointAnnotation];

    
    
//    CGFloat latZoom = [NavBgImage BMapSetPointCenterWithPoint11:CLLocationCoordinate2DMake(_driverModel.nowLatitude, _driverModel.nowLongitude) withPoint2:CLLocationCoordinate2DMake(_orderModel.sendLatitude, _orderModel.sendLongitude)];
//    CLLocationCoordinate2D latCenter = [NavBgImage BMapGetCenterWithPoint11:CLLocationCoordinate2DMake(_driverModel.nowLatitude, _driverModel.nowLongitude) withPoint2:CLLocationCoordinate2DMake(_orderModel.sendLatitude, _orderModel.sendLongitude)];
//
//    _mapView.zoomLevel = latZoom;
//    [_mapView setCenterCoordinate:latCenter animated:YES];
    
}

- (void)initView {
    [self initMap];
    [self initInfoView];
    [self initBtnView];
}

- (void)initBtnView {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth-45, _mapView.bottom - 45, 40, 40)];
    [NavBgImage showIconFontForView:backBtn iconName:@"\U0000e786" color:[UIColor blackColor] font:30];
    [self.view addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtnAct) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backBtnAct {
    _nowCount = 0;
    [self loadAppearData];
    
}


- (void)initMap {
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT-200)];
    
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    _mapView.showMapScaleBar = YES;

    [self.view addSubview:_mapView];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake( 0,  _mapView.bottom, kDeviceWidth, kDeviceHeight-_mapView.bottom)];
    bgView.backgroundColor = bgColor;
    [self.view addSubview:bgView];
    
    
    _locService = [[BMKLocationService alloc] init];
    [self startLocation];
    
}

- (void)initInfoView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, _mapView.bottom+5, kDeviceWidth-20, 190)];
    [self.view addSubview:bgView];
    
    _orderOnWayView = [[[NSBundle mainBundle] loadNibNamed:@"OrderOnWayView" owner:nil options:nil] lastObject];
    _orderOnWayView.frame = CGRectMake(0, 0, kDeviceWidth-10, 190);
    [bgView addSubview:_orderOnWayView];
    
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


#pragma mark-----BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation *)annotation];
    }

    if ([annotation.title isEqualToString:@"发货位置"] || [annotation.title isEqualToString:@"收货位置"]) {
        BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location2"];
        annotationView.image = [UIImage imageNamed:@"start_annotation"];
        annotationView.centerOffset = CGPointMake(0, -20);
        
        return annotationView;
    }else if([annotation.title isEqualToString:@"司机位置"]){
        BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location1"];
        annotationView.image = [UIImage imageNamed:@"icon_driver_car"];
        annotationView.centerOffset = CGPointMake(0, -20);
    
        
        return annotationView;
    }
    
    return [mapView viewForAnnotation:annotation];
    
}


- (void)routePlan
{
    BMKRouteSearch *routeSearch = [[BMKRouteSearch alloc] init];
    routeSearch.delegate = self;
    
    BMKDrivingRoutePlanOption *options = [[BMKDrivingRoutePlanOption alloc] init];
    
    options.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    
    start.pt = CLLocationCoordinate2DMake(_driverModel.nowLatitude, _driverModel.nowLongitude);;
    
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    
    CLLocationCoordinate2D endCor;
    if ([_orderModel.status isEqualToString:@"1"]) {
        endCor = CLLocationCoordinate2DMake(_orderModel.sendLatitude, _orderModel.sendLongitude);
    }else {
        endCor = CLLocationCoordinate2DMake(_orderModel.receiveLatitude, _orderModel.receiveLongitude);
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
            _orderOnWayView.drivingRouteLine = drivingRouteLine;
            [self addLineWithPlan:drivingRouteLine];
        }
      
        
    } else {
        NSLog(@"error code:%u", error);
        [self addMapAnno];
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
            if ([_orderModel.status isEqualToString:@"1"]) {
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
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ) {
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent:filename];
        return s;
    }
    return nil ;
}



@end
