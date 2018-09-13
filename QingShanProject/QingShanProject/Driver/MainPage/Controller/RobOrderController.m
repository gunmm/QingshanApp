//
//  RobOrderController.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/10.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "RobOrderController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "OrderModel.h"
#import "FinishOrderRes.h"
#import "RobOrderDetailView.h"
#import "ShortSoundPlay.h"
#import "DriverOrderDetailController.h"


@interface RobOrderController () <BMKMapViewDelegate, BMKLocationServiceDelegate>
{
    BMKLocationService *_locService;

}


@property (strong, nonatomic) BMKMapView *mapView;
@property (nonatomic, strong) OrderModel *model;
@property (nonatomic, strong) RobOrderDetailView *robOrderDetailView;


@end

@implementation RobOrderController

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
}

- (void)initNavBar {
    self.title = @"抢单";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)firstLoadData {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.orderId forKey:@"orderId"];
    [NetWorking postDataWithParameters:param withUrl:@"getBigOrderInfo" withBlock:^(id result) {
        FinishOrderRes *finishOrderRes = [FinishOrderRes mj_objectWithKeyValues:result];
        self.model = finishOrderRes.object;
        [self addPointForMap];
        self.robOrderDetailView.model = self.model;
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)addPointForMap {
    [self startLocation];
    
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

- (void)initView {
    [self initMapView];
    [self initDetailView];
}

- (void)initDetailView {
    _robOrderDetailView = [[[NSBundle mainBundle] loadNibNamed:@"RobOrderDetailView" owner:nil options:nil] lastObject];
    _robOrderDetailView.frame = CGRectMake(0, 0, kDeviceWidth-10, 245);
    
    
    __weak typeof(self) weakSelf = self;

    _robOrderDetailView.robBtnActBlock = ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
        [param setObject:weakSelf.orderId forKey:@"orderId"];
        
        [NetWorking postDataWithParameters:param withUrl:@"robOrder" withBlock:^(id result) {
            [HUDClass showHUDWithText:@"抢单成功！"];
            [ShortSoundPlay playSoundWithPath:@"grab_successed" withType:@"m4a"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if (weakSelf.robSuccessBlock) {
                weakSelf.robSuccessBlock(weakSelf.orderId);
            }
            

        } withFailedBlock:^(NSString *errorResult) {
            [ShortSoundPlay playSoundWithPath:@"grab_failed" withType:@"m4a"];
        }];
    };
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, _mapView.bottom+5, kDeviceWidth-10, 245)];
    [self.view addSubview:bgView];
    
    [bgView addSubview:_robOrderDetailView];
}

- (void)initMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT-255-TABBAR_BOTTOM_HEIGHT)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    _mapView.showMapScaleBar = YES;
    [self.view addSubview:_mapView];
    
    _locService = [[BMKLocationService alloc] init];

}


#pragma mark-------BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
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



@end
